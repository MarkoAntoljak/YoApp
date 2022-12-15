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
    
    let settingsTableView = UITableView()
        
    let usernameLabel = UILabel(frame: .zero)
    let profileImageView = UIImageView(frame: .zero)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
                
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
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
            UIApplication.shared.open(settingsUrl)
            
        case 1:
            present(safariVC, animated: true)
            
        case 2:
            present(safariVC, animated: true)
            
        case 3:
            present(safariVC, animated: true)
            
        case 4:
            present(safariVC, animated: true)
            
        case 5:
            present(safariVC, animated: true)
            
        case 6:
            present(safariVC, animated: true)
            
        case 7:
            present(safariVC, animated: true)
        
        default:
            return
            
        }
        
    }
    
}
