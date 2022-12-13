//
//  Constants.swift
//  Yo
//
//  Created by Marko Antoljak on 12/10/22.
//

import Foundation
import UIKit

struct Constants {
    
    // MARK: Attributes
    
    static let shared = Constants()
    
    // main color
    public let mainColor: UIColor = UIColor(named: "Color")!
    
    
    // MARK: Functions
    // present error
    public func presentError(title: String, message: String, target: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        DispatchQueue.main.async { [weak target] in
            target?.present(alert, animated: true)
        }
        
    }
    
    // MARK: User Logout and Account Deletion
    // signing out the user
//    private func signOut() {
//        
//        AuthManager.shared.signOut { [weak self] success in
//            
//            guard let strongSelf = self else {return}
//            
//            if success {
//                // go back to signIn screen
//                DispatchQueue.main.async {
//                    
//                    let navVC = UINavigationController(rootViewController: PhoneNumberViewController())
//                    navVC.modalPresentationStyle = .fullScreen
//                    strongSelf.present(navVC, animated: true)
//                }
//                
//            } else {
//                strongSelf.constants.presentError(
//                    title: "Error",
//                    message: "There was a problem with sign out. Please try again.",
//                    target: strongSelf)
//            }
//        }
//    }
//    
//    private func deleteAccount() {
//        
//        DatabaseManager.shared.deleteUserAccount(for: userUID ?? "") {[weak self] success in
//            
//            guard let strongSelf = self else {return}
//            
//            if success {
//                AuthManager.shared.signOut { success in
//                    if success {
//                        // go back to sign in screen
//                        DispatchQueue.main.async {
//                            let navc = UINavigationController(rootViewController: PhoneNumberViewController())
//                            navc.modalPresentationStyle = .fullScreen
//                            strongSelf.present(navc, animated: true)
//                        }
//                        
//                    } else {
//                        strongSelf.constants.presentError(title: "Error", message: "Cannot sign out the user", target: strongSelf)
//                    }
//                }
//            } else {
//                strongSelf.constants.presentError(title: "Error", message: "Cannot delete account", target: strongSelf)
//            }
//        }
//    }


}
