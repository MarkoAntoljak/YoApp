//
//  ExistingUsersViewController.swift
//  Yo
//
//  Created by Marko Antoljak on 12/15/22.
//

import UIKit

import UIKit

import Contacts

protocol ExisitngUsersControllerDelegate: AnyObject {
    
    func sendUsers(users: [User])
    
}

class ExisitngUsersViewController: UIViewController {
    
    let navbar = UINavigationBar()
        
    let contactsControllerTableView = UITableView()
    
    weak var contactsDelegate: ExisitngUsersControllerDelegate!
    
    var users: [User] = []
    
    var selectedUsers: [User] = []
    
    func fetchAllUsers() async {
        
        // fetch all users from database
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavbar()
        
        setupTableView()
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Task.init {
            
            await self.fetchAllUsers()
            
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        navbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        
        contactsControllerTableView.frame = CGRect(x: 0, y: navbar.frame.height, width: view.frame.width, height: view.frame.height - navbar.frame.height)
        
    }
    
    
    private func setupNavbar() {
        
        view.addSubview(navbar)
        
        navbar.backgroundColor = .systemBackground
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissContactViewController))
        
        let sendButton = UIBarButtonItem(title: "Send Yo", style: .done, target: self, action: #selector(sendButtonTapped))
        
        let navItem = UINavigationItem(title: "")
        
        navItem.leftBarButtonItem = cancelButton
        
        navItem.rightBarButtonItem = sendButton
        
        navItem.titleView = setTitle(title: "All YO users", subtitle: "Tap to select")
        
        navbar.items = [navItem]
        
        navbar.tintColor = .systemPurple
        
    }
    
    
    func setTitle(title: String, subtitle: String) -> UIView {
        let titleLabel = UILabel(frame: CGRectMake(0, -2, 0, 0))

        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.text = title
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel(frame: CGRectMake(0, 22, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clear
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = .systemGray2
        subtitleLabel.sizeToFit()

        let titleView = UIView(frame: CGRectMake(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width

        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }

        return titleView
    }
    
    private func setupTableView() {
        
        contactsControllerTableView.delegate = self
        
        contactsControllerTableView.dataSource = self
        
        view.addSubview(contactsControllerTableView)
        
        contactsControllerTableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        
        contactsControllerTableView.allowsMultipleSelection = true
        
    }
    
    
    private func showSettingsAlert() {
        
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Go to Settings to grant access.", preferredStyle: .alert)
        
        if let settings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settings) {
            
                alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
                                        
                    UIApplication.shared.open(settings)
                    
            })
        }
        
        present(alert, animated: true)
    }
    
    
    @objc func dismissContactViewController() {
                        
        dismiss(animated: true)
                
    }
    
    
    @objc func sendButtonTapped() {
        
        contactsDelegate?.sendUsers(users: selectedUsers)
                                
        dismiss(animated: true)
        
    }

}


extension ExisitngUsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selectedUser = users[indexPath.row]
                
        let cell = contactsControllerTableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        
        cell.userNameLabel.text = selectedUser.fullName
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75.0
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedUser = users[indexPath.row]
        
        if selectedUsers.contains(selectedUser) {
                        
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
            selectedUsers.removeAll { $0 == selectedUser }
                        
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                                
            selectedUsers.append(selectedUser)
                                                                        
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}