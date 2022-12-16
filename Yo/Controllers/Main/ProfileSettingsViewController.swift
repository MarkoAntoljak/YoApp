//
//  ProfileViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit

import SnapKit

import SafariServices

class ProfileSettingsViewController: UIViewController {
    
    let settingsCellData = [
    
        SettingsCell(title: "Notifications", image: UIImage(systemName: "bell.fill")!),
        SettingsCell(title: "Share", image: UIImage(systemName: "square.and.arrow.up.fill")!),
        SettingsCell(title: "Rate", image: UIImage(systemName: "star.fill")!),
        SettingsCell(title: "Contact Us", image: UIImage(systemName: "phone.fill")!),
        SettingsCell(title: "Privacy Policy", image: UIImage(systemName: "checkmark.seal.fill")!),
        SettingsCell(title: "Terms & Conditions", image: UIImage(systemName: "lock.rectangle")!),
        SettingsCell(title: "Logout", image: UIImage(systemName: "rectangle.portrait.and.arrow.right.fill")!),
        SettingsCell(title: "Delete account", image: UIImage(systemName: "delete.backward.fill")!),
        
    ]
    
    private let constants = Constants.shared
    
    let settingsTableView = UITableView()
        
    let usernameLabel = UILabel()
    let profileImageView = UIImageView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
                
        setupTableView()
        
        setupUsername()
        
        setupProfileImage()
                
    }

    // MARK: - all frame, resizing, layout stuff goes in here
    
    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        
        [settingsTableView, profileImageView, usernameLabel].forEach { subview in view.addSubview(subview) }

        setupConstraints()
        
    }
    
    
    func setupConstraints() {
        
        profileImageView.snp.makeConstraints { make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(150)
            
        }
        
        usernameLabel.snp.makeConstraints { make in
            
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            
        }
        
        settingsTableView.snp.makeConstraints { make in
            
            make.top.equalTo(usernameLabel.snp.bottom).offset(40)
            make.width.height.equalTo(view.width)
            
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


extension ProfileSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingsCellData.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as! SettingsTableViewCell
        cell.titleLabel.text = settingsCellData[indexPath.row].title
        cell.iconImageView.image = settingsCellData[indexPath.row].image
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


extension ProfileSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
