//
//  ContactPickerViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit

import Contacts

protocol ContactsViewControllerDelegate: AnyObject {
    
    func sendUsers(users: [User])
    
}

class ContactsViewController: UIViewController {
    
    let navbar = UINavigationBar()
        
    let contactsControllerTableView = UITableView()
    
        
    weak var contactsDelegate: ContactsViewControllerDelegate!
    
    
    var users: [User] = []
    
    var selectedUsers: [User] = []
    
    
    func fetchAllContacts() async {
        
        let store = CNContactStore()
        
        let keys = [CNContactGivenNameKey] as [CNKeyDescriptor]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            
            try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, result in
                                
                self.users.append(User(name: contact.givenName))
                                
            })
            
        } catch {
            
            self.showSettingsAlert()
            
        }
        
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewDidLayoutSubviews()
        
        setupViewController()
        
        setupNavbar()
        
        setupTableView()
        
        Task.init {
            
            await self.fetchAllContacts()
            
        }
                
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        navbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        contactsControllerTableView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height - 50)
        
    }
    
    
    private func setupViewController() {
        
        view.backgroundColor = .systemBackground
        
        contactsControllerTableView.delegate = self
        
        contactsControllerTableView.dataSource = self
        
    }
    
    
    private func setupNavbar() {
        
        view.addSubview(navbar)
        
        navbar.backgroundColor = .systemBackground
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissContactViewController))
        
        let sendButton = UIBarButtonItem(title: "Send Yo", style: .done, target: self, action: #selector(sendButtonTapped))
        
        let navItem = UINavigationItem(title: "")
        
        navItem.leftBarButtonItem = cancelButton
        
        navItem.rightBarButtonItem = sendButton
        
        navbar.items = [navItem]
        
    }
    
    
    private func setupTableView() {
        
        view.addSubview(contactsControllerTableView)
        
        contactsControllerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactsTableViewCell")
        
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


extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selectedUser = users[indexPath.row]
                
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ContactsTableViewCell")
                            
        cell.textLabel?.text = selectedUser.name
        
        return cell
        
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
