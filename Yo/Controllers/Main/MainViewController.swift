//
//  MainViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Attributes
    private let constants = Constants.shared


    override func viewDidLoad() {
        
        super.viewDidLoad()

        configureMainViewController()
        
    }
    
    
    func configureMainViewController() {
        
        view.backgroundColor = .systemBackground
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        
        addButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    
    @objc func closeButtonTapped() {
        
        print("Tapped!")
        
        signOut()
        
    }
    
    // signing out the user
    private func signOut() {
        
        AuthManager.shared.signOut { [weak self] success in
            
            guard let strongSelf = self else {return}
            
            if success {
                // go back to signIn screen
                DispatchQueue.main.async {
                    
                    let navVC = UINavigationController(rootViewController: PhoneNumberViewController())
                    navVC.modalPresentationStyle = .fullScreen
                    strongSelf.present(navVC, animated: true)
                }
                
            } else {
                strongSelf.constants.presentError(
                    title: "Error",
                    message: "There was a problem with sign out. Please try again.",
                    target: strongSelf)
            }
        }
    }
    
}
