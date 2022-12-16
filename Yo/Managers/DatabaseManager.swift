//
//  DatabaseManager.swift
//  Yo
//
//  Created by Marko Antoljak on 12/13/22.
//

import Foundation
import FirebaseFirestore

struct DatabaseManager {
    
    // MARK: Attributes
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    // cache current user
    private let cachedUser = NSCache<NSString, User>()
    
    enum ErrorType: Error {
        
        case ErrorGettingUser
        case ErrorGettingAllUsers
        case ErrorGettingSentYos
        case ErrorGettingReceivedYos
    }
    
    // MARK: Functions
    // insert new user into database
    public func insertNewUser(userUID: String, firstName: String, lastName: String, email: String?, completion: @escaping (Bool) -> Void) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: "phone_number") else {return}
        
        let userData: [String: Any] = [
            "first_name" : firstName,
            "last_name" : lastName,
            "phone_number" : phoneNumber,
            "fullname" : "\(firstName) \(lastName)",
            "email" : email ?? ""
        ]
        
        database.collection("users").document(userUID).setData(userData) { error in
            
            guard error == nil else {
                print("Error: there was a problem with setting data into database")
                completion(false)
                return
            }
            
            completion(true)
        }
        
    }
    
    public func getCurrentUserData(for userUID: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        database.collection("users").document(userUID).getDocument { snapshot, error in
            
            // if current user is already cached
            if let userObj = cachedUser.object(forKey: "currentUser") {
                print("user is cached")
                completion(.success(userObj))
                return
            }
            
            guard let snapshot = snapshot, error == nil else {
                print("Error: there was an error with snapshot or there is no user with uid: \(userUID)")
                completion(.failure(ErrorType.ErrorGettingUser))
                return
            }
            // get data from user document
            guard let data = snapshot.data(),
                  let firstName = data["first_name"] as? String,
                  let lastName = data["last_name"] as? String,
                  let email = data["email"] as? String,
                  let fullname = data["fullname"] as? String,
                  let phoneNumber = data["phone_number"] as? String else {
                print("Error: wrong field, something is mising")
                completion(.failure(ErrorType.ErrorGettingUser))
                return
            }
            
            let user = User(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, fullname: fullname)
            
            // cache user
            self.cachedUser.setObject(user, forKey: "currentUser")
            
            completion(.success(user))
            
        }
    }
    
    // checking if the user is already in the database
    public func checkIfUserExists(userUID: String, completion: @escaping (Bool) -> Void) {
        
        database.collection("users").getDocuments { snapshot, error in
            
            guard let snapshot = snapshot, error == nil else {
                print("Error: there was an error with snapshot")
                return
            }
            
            for document in snapshot.documents {
                
                if document.documentID == userUID {
                    // user exists
                    completion(true)
                    return
                }
            }
            // user doesn't exist
            completion(false)
        }
        
    }
    
    // get all Yo users
    public func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        
        var allUsers: [User] = [User]()
        
        database.collection("users").getDocuments { snapshot, error in
            
            guard let currentUserUID = UserDefaults.standard.string(forKey: "userUID") else {
                print("No user uid")
                completion(.failure(ErrorType.ErrorGettingAllUsers))
                return
            }
            
            guard let snapshot = snapshot, error == nil else {
                print("Error: there was a problem with snapshot")
                completion(.failure(ErrorType.ErrorGettingAllUsers))
                return
            }
            
            for document in snapshot.documents {
                // skip current user
                if document.documentID == currentUserUID {
                    continue
                }
                // get all info from user
                let data = document.data()
                let firstName = data["first_name"] as! String
                let lastName = data["last_name"] as! String
                let email = data["email"] as! String
                let fullname = data["fullname"] as! String
                let phoneNumber = data["phone_number"] as! String
                
                let user = User(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, fullname: fullname)
                
                allUsers.append(user)
                
            }
            
            completion(.success(allUsers))
        }
        
    }
    
    // deleting user account
    public func deleteUserAccount(for userUID: String, completion: @escaping (Bool) -> Void) {
        
        database.collection("users").getDocuments { snapshot, error in
            
            guard let snapshot = snapshot, error == nil else {
                print("Error: there was an error with snapshot")
                completion(false)
                return
            }
            
            for document in snapshot.documents {
                
                if document.documentID == userUID {
                    // delete user data
                    print("user deleted")
                    database.collection("users").document(document.documentID).delete()
                    completion(true)
                    return
                }
            }
            // user uid didn't mached database
            print("cannot find user in the database with uid: \(userUID)")
            completion(false)
        }
        
    }
    
    // MARK: Sending sender data into database
    public func createSenderData(sender currentUser: User, receiver receiverUser: User, completion: @escaping (Bool) -> Void) {
        
        guard let currentUserUID = UserDefaults.standard.string(forKey: "userUID") else {
            print("no current user UID")
            return
        }
        let path = database.collection("users").document(currentUserUID)
        
        path.getDocument { snapshot, error in
            
            guard let snapshot = snapshot, error == nil, var document = snapshot.data() else {
                print("Error: there was a problem with snapshot or cannot find useruid: \(currentUserUID) document")
                completion(false)
                return
            }
            
            if var sentYOS = document["sent_yos"] as? [User]{
                // create
                sentYOS.append(receiverUser)
                
                document["sent_yos"] = sentYOS
                
            } else {
                //append if array exists
                document["sent_yos"] = [receiverUser]
                
            }
            
            path.setData(document) { error in
                
                guard error == nil else {
                    print("Error: problem while setting new data into document")
                    completion(false)
                    return
                }
                
                createReceiverData(sender: currentUser, recevier: receiverUser) { success in
                    
                    completion(success)
                }
            }
        }
    }
    
    // MARK: Sending receiver data into database
    public func createReceiverData(sender currentUser: User, recevier receiverUser: User, completion: @escaping (Bool) -> Void) {
            
        database.collection("users").getDocuments { snapshot, error in
            
            guard let snapshot = snapshot,
                  error == nil else {
                print("Error there was a problem with snapshot, or there are no documents")
                completion(false)
                return
            }
            
            var receiverDocumentName: String = ""
            
            // go through all document and find a document name
            for document in snapshot.documents {
                
                if document["fullname"] as? String == receiverUser.fullName {
                    
                    receiverDocumentName = document.documentID
                    
                } else {
                    print("Error: there is no user with name \(receiverUser.fullName)")
                    completion(false)
                }
            }
            
            let path = database.collection("users").document(receiverDocumentName)
            
            path.getDocument { snapshot, error in
                
                guard let snapshot = snapshot,
                      error == nil,
                      var document = snapshot.data() else {
                    print("Error there was a problem with snapshot, or there are no documents")
                    completion(false)
                    return
                }
                
                if var receivedYOS = document["received_yos"] as? [User] {
                    // create
                    receivedYOS.append(currentUser)
                    
                    document["received_yos"] = receivedYOS
                    
                } else {
                    //append if array exists
                    document["received_yos"] = [currentUser]
                    
                }
                
                path.setData(document) { error in
                    
                    guard error == nil else {
                        print("Error: problem while setting new data into document")
                        completion(false)
                        return
                    }
                    
                    completion(true)
                }
            }
        }
    }
    
    // MARK: Fetch sent yos
    public func getSentYos(completion: @escaping (Result<[User],Error>) -> Void) {
        
        guard let currentUserUID = UserDefaults.standard.string(forKey: "userUID") else {
            print("no userUID")
            return
        }
        
        database.collection("users").document(currentUserUID).getDocument { snapshot, error in
            
            guard let snapshot = snapshot,
                  error == nil,
                  let document = snapshot.data() else {
                print("Error: there was a problem with snapshot")
                completion(.failure(ErrorType.ErrorGettingSentYos))
                return
            }
            
            if var users = document["sent_yos"] as? [User] {
                // append every user in the document
                for user in users {
                    
                    users.append(user)
                }
                
                completion(.success(users))
                
            } else {
                // send back empty array if there are no users
                completion(.success([]))
            }
        }
        
    }
    
    // MARK: Fetch received yos
    public func getReceivedYos(completion: @escaping (Result<[User],Error>) -> Void) {
        
        guard let currentUserUID = UserDefaults.standard.string(forKey: "userUID") else {
            print("no userUID")
            return
        }
        
        database.collection("users").document(currentUserUID).getDocument { snapshot, error in
            
            guard let snapshot = snapshot,
                  error == nil,
                  let document = snapshot.data() else {
                print("Error: there was a problem with snapshot")
                completion(.failure(ErrorType.ErrorGettingSentYos))
                return
            }
            
            if var users = document["received_yos"] as? [User] {
                // append every user in the document
                for user in users {
                    
                    users.append(user)
                }
                
                completion(.success(users))
                
            } else {
                // send back empty array if there are no users
                completion(.success([]))
            }
        }
    }
    
    
    
    
    
}
