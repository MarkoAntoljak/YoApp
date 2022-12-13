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
    
    public func getUserData(for userUID: String, completion: @escaping (Bool) -> Void) {
        
        database.collection("users").document(userUID).getDocument { snapshot, error in
            
            guard let snapshot = snapshot, error == nil else {
                print("Error: there was an error with snapshot or there is no user with uid: \(userUID)")
                completion(false)
                return
            }
            // get data from user document
            guard let data = snapshot.data(),
                    let firstName = data["firstName"] as? String,
                  let lastName = data["lastName"] as? String,
                  let email = data["email"] as? String,
                  let phoneNumber = data["phone_number"]as? String else {
                print("No user data")
                completion(false)
                return
            }
//
//            let user = User(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
//            completion(user)
            completion(true)
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
