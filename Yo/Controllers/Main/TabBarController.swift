//
//  TabBarController.swift
//  Yo
//
//  Created by Marko Antoljak on 12/15/22.
//

import UIKit

class TabBarController: CustomUITabBarController {
    
    // MARK: Propreties
    private var user: User?
    
    private let constants = Constants.shared

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.backgroundColor = .systemBackground

        setUpTabBar()
    }
    
    // MARK: View Setup Functions
    private func setUpTabBar() {
        
        guard let userUID = UserDefaults.standard.string(forKey: "userUID") else {
            print("no userUID")
            return
        }
        
        DatabaseManager.shared.getCurrentUserData(for: userUID) { [weak self] result in

            switch result {
                
            case .success(let user):
                
                self?.user = user
                
                // main screen
                let mainScreen = UINavigationController(rootViewController: MainViewController(user: user))
                
                mainScreen.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "heart"), tag: 0)
                
                mainScreen.title = ""
            
                // requests screen
                let requestsScreen = UINavigationController(rootViewController: RequestsViewController())
                
                requestsScreen.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "bell"), tag: 1)
                
                requestsScreen.title = ""
                
                // profile settings screen
                let profileSettingsScreen = UINavigationController(rootViewController: SettingsViewController())
                
                profileSettingsScreen.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "user"), tag: 1)
                
                profileSettingsScreen.title = ""
                
                // add all navVCs
                self?.setViewControllers([mainScreen, requestsScreen, profileSettingsScreen], animated: false)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
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
