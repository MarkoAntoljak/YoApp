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
    }
    
    // MARK: Functions
    // insert new user into database
    public func insertNewUser(userUID: String, firstName: String, lastName: String, email: String?, completion: @escaping (Bool) -> Void) {
        
        guard let phoneNumber = UserDefaults.standard.string(forKey: "phone_number") else {return}
        
        let userData: [String: Any] = [
            "first_name" : firstName,
            "last_name" : lastName,
            "phone_number" : phoneNumber,
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
                  let phoneNumber = data["phone_number"] as? String else {
                print("Error: wrong field, something is mising")
                completion(.failure(ErrorType.ErrorGettingUser))
                return
            }
            
            let user = User(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
            
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
                let phoneNumber = data["phone_number"] as! String
                
                let user = User(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
                
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
    
    
    
}
