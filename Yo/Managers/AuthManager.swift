//
//  AuthManager.swift
//  Yo
//
//  Created by Marko Antoljak on 12/10/22.
//

import Foundation
import FirebaseAuth

struct AuthManager {
    
    // MARK: Attributes
    static let shared = AuthManager()
    
    private let firebaseAuth = Auth.auth()
    
    private let phoneAuth = PhoneAuthProvider.provider()
    // checking if the user is already signed in
    public var isSignedIn: Bool {
        return firebaseAuth.currentUser != nil
    }
    
    // MARK: Functions
    public func sendMessageCode(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        
        phoneAuth.verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            
            guard let verificationID = verificationID, error == nil else {
                // there was an error
                print("Error: there was a problem with sending message to user")
                completion(false)
                return
            }
            // save verification id
            UserDefaults.standard.set(verificationID, forKey: "verificationID")
            UserDefaults.standard.set(phoneNumber, forKey: "phone_number")
            
            // user receives the SMS code
            completion(true)
        }
    }
    
    // MARK: Actions
    // verifying the entered code and signing in the user
    public func verifyCode(SMSCode: String, completion: @escaping (Bool) -> Void) {
        
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID") else {
            // there was an error
            print("Error: there is no verificationID")
            completion(false)
            return
        }
        
        let credidential = phoneAuth.credential(withVerificationID: verificationID, verificationCode: SMSCode)
        
        firebaseAuth.signIn(with: credidential) { result, error in
            
            guard let _ = result, error == nil else {
                print("Error there was a problem with signing in the user")
                completion(false)
                return
            }
            // save current user uid
            guard let currentUser = firebaseAuth.currentUser else {
                print("Error: there is no current user")
                completion(false)
                return
            }
            
            UserDefaults.standard.set(currentUser.uid, forKey: "userUID")
            
            completion(true)
        }
    }
    

    public func signOut(completion: @escaping (Bool) -> Void) {
        
        do {
            print("user signed out")
            try firebaseAuth.signOut()
        } catch {
            print("Error: cannot sign out the user")
            completion(false)
            return
        }
        
        completion(true)
    }
    
}
