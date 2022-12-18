//
//  ProfileViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit

import SnapKit

import SafariServices

class SettingsViewController: UIViewController {
    
    // MARK: Attributes
    private var user: User
    
    private let settingsCellData = [
        SettingsSection(title: "Basic", cells: [SettingsCell(title: "Notifications", icon: UIImage(systemName: "bell.fill")!),]),
        SettingsSection(title: "About", cells: [SettingsCell(title: "Share", icon: UIImage(systemName: "square.and.arrow.up.fill")!),
                        SettingsCell(title: "Rate", icon: UIImage(systemName: "star.fill")!),
                        SettingsCell(title: "Contact Us", icon: UIImage(systemName: "phone.fill")!),
                        SettingsCell(title: "Privacy Policy", icon: UIImage(systemName: "checkmark.seal.fill")!),
                        SettingsCell(title: "Terms & Conditions", icon: UIImage(systemName: "lock.rectangle")!)]),
        SettingsSection(title: "Account", cells: [SettingsCell(title: "Logout", icon: UIImage(systemName: "rectangle.portrait.and.arrow.right.fill")!),
                                           SettingsCell(title: "Delete account", icon: UIImage(systemName: "delete.backward.fill")!)])
    ]
    
    private let constants = Constants.shared
    
    let settingsTableView = UITableView()
    
    // MARK: Init
    init(user: User) {
        
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = user.fullName
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        setupTableView()
                
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        settingsTableView.snp.makeConstraints { make in
            
            make.top.equalTo(view.snp.top).offset(40)
            make.height.equalTo(view.height)
            make.width.equalToSuperview()
            
        }
        
    }
    
    // MARK: View Setup Functions

    private func setupTableView() {
        
        view.addSubview(settingsTableView)
        
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        settingsTableView.separatorStyle = .none
        
    }
    
    // MARK: User Logout and Account Deletion
    
     //signing out the user
    private func signOut() {
        
        let alert = UIAlertController(title: "Are you sure?", message: "You are about to logout.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            
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
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
        
    }
    // deleting account
    private func deleteAccount() {
        
        let alert = UIAlertController(title: "Are you sure?", message: "You are about to delete your account.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
            guard let userUID = UserDefaults.standard.string(forKey: "userUID") else {
                print("no userUID")
                return
            }
            
            DatabaseManager.shared.deleteUserAccount(for: userUID) { [weak self] success in
                
                guard let strongSelf = self else {return}
                
                if success {
                    
                    AuthManager.shared.signOut { success in
                        
                        if success {
                            // go back to sign in screen
                            DispatchQueue.main.async {
                                let navc = UINavigationController(rootViewController: PhoneNumberViewController())
                                navc.modalPresentationStyle = .fullScreen
                                strongSelf.present(navc, animated: true)
                            }
                        } else {
                            strongSelf.constants.presentError(title: "Error", message: "Cannot sign out the user", target: strongSelf)
                        }
                    }
                } else {
                    strongSelf.constants.presentError(title: "Error", message: "Cannot delete account", target: strongSelf)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
} // end of main class

// MARK: - Table View DataSource and Delegate
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        settingsCellData[section].cells.count
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return settingsCellData[section].title.uppercased()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30.0
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return settingsCellData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as! SettingsTableViewCell
        
        let cellLocation = settingsCellData[indexPath.section].cells[indexPath.row]
        
        cell.titleLabel.text = cellLocation.title
        cell.iconImageView.image = cellLocation.icon
        
        return cell
        
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        settingsTableView.deselectRow(at: indexPath, animated: true)
        
        let sectionNumber = indexPath.section
        
        let safariVC = SFSafariViewController(url: URL(string: "http://spiceapp.co")!)
        
        switch sectionNumber {
            
            // basics section
        case 0:
            // notification settings
            if indexPath.row == 0 {
    
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
                
                UIApplication.shared.open(settingsUrl)
                
            }
            // about section
        case 1:
            
            if indexPath.row == 0 {
                // share app
                present(safariVC, animated: true)
                
            } else if indexPath.row == 1 {
                // rate app
                present(safariVC, animated: true)
                
            } else if indexPath.row == 2 {
                // contact us
                let email = "tomi@joinhangoo.com"
                if let url = URL(string: "mailto:\(email)") {
                  
                    UIApplication.shared.open(url)
                }
                
            } else if indexPath.row == 3 {
                // privacy policy
                present(safariVC, animated: true)
                
            } else if indexPath.row == 4 {
                // terms & conditions
                present(safariVC, animated: true)
            }
            // account settings
        case 2:
            
            if indexPath.row == 0 {
                // logout
                signOut()
                
            } else if indexPath.row == 1 {
                // delete account
                deleteAccount()
            }
        default:
            return
        }
    }
    
}


    
    

    

