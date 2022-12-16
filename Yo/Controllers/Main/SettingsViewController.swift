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
        
    let usernameLabel = UILabel()
    let profileImageView = UIImageView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
                
        setupTableView()
        
        setupUsername()
        
        setupProfileImage()
                
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        [settingsTableView, profileImageView, usernameLabel].forEach { subview in view.addSubview(subview) }

        setupConstraints()
        
    }
    
    
    private func setupTableView() {
        
        view.addSubview(settingsTableView)
        
        usernameLabel.snp.makeConstraints { make in
            
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            
        }
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        settingsTableView.separatorStyle = .none
        
    }

    
    // MARK: - Constraints
    
    
    private func setupConstraints() {
        
        settingsTableView.snp.makeConstraints { make in
            
            make.top.equalTo(view.top).offset(40)
            make.height.equalTo(view.height)
            make.leading.equalTo(view.snp.leading).offset(15)
            make.trailing.equalTo(view.snp.trailing).offset(-15)
            
        }
        
    }
    
    
    private func setupUsername() {
                
        usernameLabel.textAlignment = .center
        usernameLabel.textColor = .label
        usernameLabel.numberOfLines = 0
        usernameLabel.font = .boldSystemFont(ofSize: 26)
        usernameLabel.text = "Jeanine, 24"
        
    }
    
    
    private func setupProfileImage() {
        
        profileImageView.image = UIImage(named: "girl")
        profileImageView.contentMode = .scaleAspectFill
        
        profileImageView.layer.cornerRadius = 80
        profileImageView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(editImageTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
    }
    
    
    @objc func editImageTapped() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCameraButton(action:)))
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: openPhotoLibrary(action:)))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
        
    }
    
}

// MARK: - Table View


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
        
        let cellNumber = indexPath.row
        
        let safariVC = SFSafariViewController(url: URL(string: "https://www.blabla.com")!)
        
        switch cellNumber {
            
        case 0:
            // notification settings
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
            UIApplication.shared.open(settingsUrl)
            
        case 1:
            // share app
            present(safariVC, animated: true)
        case 2:
            // rate the app
            present(safariVC, animated: true)
        case 3:
            // contact us
            let email = "tomi@joinhangoo.com"
            if let url = URL(string: "mailto:\(email)") {
              
                UIApplication.shared.open(url)
            }
            
        case 4:
            // privacy policy
            present(safariVC, animated: true)
            
        case 5:
            // terms & conditions
            present(safariVC, animated: true)
            
        case 6:
            // logout
            signOut()
            
        case 7:
            // delete account
            deleteAccount()
            
        default:
            return
            
        }
        
    }
    
}

// MARK: - Image & Library Pickers


extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCameraButton(action: UIAlertAction) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = .camera
            
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true)
            
        }
        
    }
    
    
    func openPhotoLibrary(action: UIAlertAction) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = .photoLibrary
            
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true)
            
        }
        
    }
    
    // MARK: User Logout and Account Deletion
     //signing out the user
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
    
    private func deleteAccount() {
        
        guard let userUID = UserDefaults.standard.string(forKey: "userUID") else {
            print("no userUID")
            return
        }
        
        DatabaseManager.shared.deleteUserAccount(for: userUID) {[weak self] success in
            
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
    }

    
}
