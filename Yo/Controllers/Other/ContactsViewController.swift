//
//  ContactsViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit

import Contacts
import MessageUI

class ContactsViewController: UIViewController, MFMessageComposeViewControllerDelegate {
        
    let navbar = UINavigationBar()
    
    let contactsControllerTableView = UITableView()
    
    var contacts: [String] = []
    
    private let constants = Constants.shared
    
    var contactPhoneNumbers: [String] = []
    
    func fetchAllContacts() {
        
        let store = CNContactStore()
        
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
         
            do {
                
                try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, result in
                                    
                    self?.contacts.append("\(contact.givenName) \(contact.familyName)")
                    
                    self?.contactPhoneNumbers.append(contact.phoneNumbers.first?.value.stringValue ?? "")
                                    
                })
                
            } catch {
                
                self?.showSettingsAlert()
                
            }
        }
        
    }
    
    override func loadView() {
        super.loadView()
        
        fetchAllContacts()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupViewController()
        
        setupNavbar()
        
        setupTableView()
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // do refresh on a main thread
        DispatchQueue.main.async {
            self.contactsControllerTableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        navbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        
        contactsControllerTableView.frame = CGRect(x: 0, y: navbar.frame.height, width: view.frame.width, height: view.frame.height - navbar.frame.height)
        
    }
    
    
    private func setupViewController() {
        
        view.backgroundColor = .systemBackground
        
    }
    
    
    private func setupNavbar() {
        
        view.addSubview(navbar)
        
        navbar.backgroundColor = .systemBackground
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissContactViewController))
        
        let navItem = UINavigationItem(title: "Your contacts")
        
        navItem.leftBarButtonItem = cancelButton
        
        navItem.titleView = setTitle(title: "Your contacts", subtitle: "Tap to invite")
        
        navbar.items = [navItem]
        
        navbar.tintColor = .systemPurple
        
    }
    
    
    func setTitle(title:String, subtitle:String) -> UIView {
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
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        }
        
        present(alert, animated: true)
    }
    
    // MARK: Button Actions
    @objc func dismissContactViewController() {
        
        dismiss(animated: true)
        
    }
    
    // MARK: Send Messages Functions
    private func displayMessageInterface(for userAt: Int) {
        
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        composeVC.recipients = [contactPhoneNumbers[userAt]]
        composeVC.body = "I invited you to YO App."
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            
            DispatchQueue.main.async {
                self.present(composeVC, animated: true, completion: nil)
            }
            
        } else {
            
            constants.presentError(title: "Error", message: "Cannot send message", target: self)
        }
    }
    
    // when message is sent or cancel is pressed
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        controller.dismiss(animated: true)
        
    }


}


extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selectedContactName = contacts[indexPath.row]
        
        let cell = contactsControllerTableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        
        cell.userNameLabel.text = selectedContactName
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75.0
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedContact = contacts[indexPath.row]
        
        displayMessageInterface(for: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
