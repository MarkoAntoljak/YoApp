//
//  ProfileViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit

import SafariServices

class ProfileSettingsViewController: UIViewController {
    
    
    let settingsCellData = [
    
        SettingsCell(title: "Notifications", image: UIImage(systemName: "bell.fill")!),
        SettingsCell(title: "Share", image: UIImage(systemName: "square.and.arrow.up.fill")!),
        SettingsCell(title: "Rate", image: UIImage(systemName: "star.fill")!),
        SettingsCell(title: "Contact Us", image: UIImage(systemName: "phone.fill")!),
        
    ]
    
    
    let settingsTableView = UITableView()
        
    let usernameLabel = UILabel()
    
    let footerLogoImageView = UIImageView()
    
    let footerStackView = UIStackView()
    
    let privacyButton = UIButton()
    
    let termsButton = UIButton()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupTableView()
        
        setupFooter()
        
        setupUsername()
        
    }
    
    // MARK: Here we need to put this inside here because we are setting CGRect coordinates and the way to do that by using another subview's frame can only be done inside here
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
                
        let tableViewOffset = usernameLabel.frame.origin.y + usernameLabel.frame.height + 50
        
        settingsTableView.frame = CGRect(x: 0, y: tableViewOffset, width: view.frame.width, height: view.frame.height)
        
    }
    
    
    func setupFooter() {
        
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        footerLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(footerStackView)
        
        view.addSubview(footerLogoImageView)
        
        footerLogoImageView.image = UIImage(named: "YO!")
        
        footerLogoImageView.contentMode = .scaleAspectFit
        
        footerStackView.axis = .horizontal
        
        footerStackView.distribution = .fillEqually
        
        footerStackView.spacing = 20
        
        footerStackView.addArrangedSubview(privacyButton)
        
        footerStackView.addArrangedSubview(termsButton)
        
        NSLayoutConstraint.activate([
            
            footerLogoImageView.bottomAnchor.constraint(equalTo: footerStackView.topAnchor, constant: -30),
            footerLogoImageView.heightAnchor.constraint(equalToConstant: 20),
            
            footerLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            footerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
        ])
        
        termsButton.setTitle("Terms", for: .normal)
        
        privacyButton.setTitle("Privacy", for: .normal)
        
        termsButton.setTitleColor(.systemPurple, for: .normal)
        
        privacyButton.setTitleColor(.systemPurple, for: .normal)
        
        termsButton.contentHorizontalAlignment = .left
        
        privacyButton.contentHorizontalAlignment = .right
        
        termsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        privacyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)

        termsButton.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        
        privacyButton.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
                        
    }
    
    
    private func setupUsername() {
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameLabel)
        
        usernameLabel.textAlignment = .center
        
        usernameLabel.textColor = .label
        
        usernameLabel.numberOfLines = 0
        
        usernameLabel.font = .boldSystemFont(ofSize: 26)
                
        usernameLabel.text = "Tomi Ant"
        
        NSLayoutConstraint.activate([
        
            usernameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ])
        
    }
    
    
    @objc func privacyTapped() {
        
        DispatchQueue.main.async {
            
            let viewController = SFSafariViewController(url: URL(string: "https://www.tesla.com")!)
            
            self.present(viewController, animated: true)
            
        }
        
    }
    
    
    @objc func termsTapped() {
        
        DispatchQueue.main.async {
            
            let viewController = SFSafariViewController(url: URL(string: "https://www.tesla.com")!)
            
            self.present(viewController, animated: true)
            
        }
        
    }
    

}


extension ProfileSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func setupTableView() {
                
        view.addSubview(settingsTableView)
        
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
        
        settingsTableView.isScrollEnabled = false
        
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
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        settingsTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
