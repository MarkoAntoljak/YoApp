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


    
    
}
