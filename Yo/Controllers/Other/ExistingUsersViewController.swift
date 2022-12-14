//
//  ExistingUsersViewController.swift
//  Yo
//
//  Created by Marko Antoljak on 12/15/22.
//

import UIKit
import Contacts
<<<<<<< HEAD
import JGProgressHUD
=======
>>>>>>> main

class ExistingUsersViewController: UIViewController {
    
    // MARK: Attributes
<<<<<<< HEAD
    private var users: [User] = []
    
    let user: User
    
    private let progressIndicator: JGProgressHUD = {
        let progress = JGProgressHUD(style: .light)
        progress.textLabel.text = "Sending Yo"
        return progress
    }()
=======

    private var users: [User] = []
    
    let user: User
>>>>>>> main
    
    private let constants = Constants.shared
    
    // MARK: UI Elements
    private let navbar = UINavigationBar()
        
    private let existingUsersTableView = UITableView()
    
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
        
        view.backgroundColor = .systemBackground
        
        setupNavbar()
        
        setupTableView()
        
        fetchAllUsers()
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchAllUsers()
            
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        navbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        
        existingUsersTableView.frame = CGRect(x: 0, y: navbar.frame.height, width: view.frame.width, height: view.frame.height - navbar.frame.height)
        
    }
    
    // MARK: View Setup Functions
    
    private func setupNavbar() {
        
        view.addSubview(navbar)
        
        navbar.backgroundColor = .systemBackground
        
        let navItem = UINavigationItem(title: "")
        
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
        
        existingUsersTableView.delegate = self
        
        existingUsersTableView.dataSource = self
        
        view.addSubview(existingUsersTableView)
        
        existingUsersTableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        
        existingUsersTableView.allowsMultipleSelection = true
        
    }
    
    // MARK: Functions
    func fetchAllUsers() {
        
        // fetch all users from database
        DatabaseManager.shared.getAllUsers { [weak self] result in
            
            guard let strongSelf = self else {return}
            
            switch result {
                
            case .failure(let error):
                // present error
                strongSelf.constants.presentError(title: "Error", message: error.localizedDescription, target: strongSelf)
                
            case .success(let users):
                
                DispatchQueue.main.async {
                    
                    strongSelf.users = users
                    
                    strongSelf.existingUsersTableView.reloadData()
                }
                
            }
        }
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
<<<<<<< HEAD
=======
    
    // MARK: Button Actions
    
>>>>>>> main

}

// MARK: TableView Delegate and DataSource

extension ExistingUsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selectedUser = users[indexPath.row]
                
        let cell = existingUsersTableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        
        cell.userNameLabel.text = selectedUser.fullName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75.0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedUser = users[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
<<<<<<< HEAD
        progressIndicator.show(in: view, animated: true)
        
=======
>>>>>>> main
        DatabaseManager.shared.createSenderData(sender: user, receiver: selectedUser) { [weak self] success in
            
            guard let strongSelf = self else {return}
            
            if success {
                
<<<<<<< HEAD
                self?.progressIndicator.dismiss(animated: true)
                
                DispatchQueue.main.async {
                    
=======
                DispatchQueue.main.async {
                    
                    strongSelf.dismiss(animated: true)
                    
>>>>>>> main
                    strongSelf.users.remove(at: indexPath.row)
                    
                    strongSelf.existingUsersTableView.reloadData()
                    
                }
                
            } else {
                
                strongSelf.constants.presentError(title: "Error", message: "Cannot send yo to that user.", target: strongSelf)
            }
        }
        
        
        
        
    }

}
