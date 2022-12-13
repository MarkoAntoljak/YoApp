//
//  ProfileViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit

import SafariServices

class ProfileViewController: UIViewController {
    
    
    let settingsCellData = [
    
        SettingsCell(title: "Notifications", image: UIImage(systemName: "bell.fill")!),
        SettingsCell(title: "Share", image: UIImage(systemName: "square.and.arrow.up.fill")!),
        SettingsCell(title: "Rate", image: UIImage(systemName: "star.fill")!),
        SettingsCell(title: "Contact Us", image: UIImage(systemName: "phone.fill")!),
        
    ]
    
    
    let settingsTableView = UITableView()
        
    let usernameLabel = UILabel()
    
    let logoFooterLabel = UILabel()
    
    let footerStackView = UIStackView()
    
    let privacyButton = UIButton()
    
    let termsButton = UIButton()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        viewDidLayoutSubviews()

        setupTableView()
        
        setupStackView()
        
        setupLogoFooter()
        
        setupTermsFooter()
        
        setupPrivacyFooter()
        
        setupUsername()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
                
        let tableViewOffset = usernameLabel.frame.origin.y + usernameLabel.frame.height + 50
        
        settingsTableView.frame = CGRect(x: 0, y: tableViewOffset, width: view.frame.width, height: view.frame.height)
        
    }
    
    
    func setupStackView() {
        
        view.addSubview(footerStackView)
        
        footerStackView.axis = .horizontal
        
        footerStackView.distribution = .fillEqually
        
        footerStackView.spacing = 20
        
        footerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            footerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            footerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        ])
        
        footerStackView.addArrangedSubview(privacyButton)
        
        footerStackView.addArrangedSubview(termsButton)
        
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
        
            usernameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ])
        
    }
    
    
    private func setupLogoFooter() {
        
        logoFooterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoFooterLabel)
        
        logoFooterLabel.text = "YO!"
        
        logoFooterLabel.numberOfLines = 0
        
        logoFooterLabel.tintColor = .label
        
        logoFooterLabel.textAlignment = .center
        
        logoFooterLabel.font = .boldSystemFont(ofSize: 24)
        
        NSLayoutConstraint.activate([
            
            logoFooterLabel.bottomAnchor.constraint(equalTo: footerStackView.topAnchor, constant: -30),
            logoFooterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoFooterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoFooterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
    }
    
    
    private func setupTermsFooter() {
        
        termsButton.setTitle("Terms", for: .normal)
        
        termsButton.contentHorizontalAlignment = .left
        
        termsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        termsButton.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        
        termsButton.setTitleColor(.systemPurple, for: .normal)
        
    }
    
    
    private func setupPrivacyFooter() {
        
        privacyButton.setTitle("Privacy", for: .normal)
        
        privacyButton.contentHorizontalAlignment = .right
        
        privacyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        privacyButton.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        
        privacyButton.setTitleColor(.systemPurple, for: .normal)
        
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
    
    
    private func setupTableView() {
                
        view.addSubview(settingsTableView)
        
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        settingsTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier)
        
        settingsTableView.isScrollEnabled = false
        
        settingsTableView.delegate = self
        
        settingsTableView.dataSource = self
        
    }

}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingsCellData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath) as! ProfileTableViewCell
                            
        cell.titleLabel.text = settingsCellData[indexPath.row].title
        
        cell.iconImageView.image = settingsCellData[indexPath.row].image
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        settingsTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
