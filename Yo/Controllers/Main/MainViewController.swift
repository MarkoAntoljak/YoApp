//
//  MainViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Attributes

    var sentUsers: [User] = []
    
    private var currentUser: User

    private let constants = Constants.shared
    
    // MARK: UI Elements
    let mainControllerTableView = UITableView()
    
    private lazy var emptyStateBigLabel: UILabel = {
        let label = UILabel()
        label.text = "No YO-s for now..."
        label.font = .systemFont(ofSize: 24, weight: .black)
        label.textAlignment = .center
        label.textColor = .systemPurple.withAlphaComponent(0.7)
        label.numberOfLines = 1
        return label
    }()
    private lazy var emptyStateSmallLabel: UILabel = {
        let label = UILabel()
        label.text = "Send to existing users or invite your friends."
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemPurple.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: Init
    init(user: User) {

        self.currentUser = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupMainViewController()
                
        setupMainTableView()
        
        setConstraints()
        
        showEmptyState()
        
        // title
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemPurple, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .black)]
        
        navigationItem.title = "YO!"
    
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        mainControllerTableView.translatesAutoresizingMaskIntoConstraints = false
        
        mainControllerTableView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
        
    }
    
    // MARK: View Setup Functions

    private func setupMainTableView() {
        
        view.addSubview(mainControllerTableView)
                
        mainControllerTableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        
        mainControllerTableView.delegate = self
        
        mainControllerTableView.dataSource = self
        
    }
    
    private func setupMainViewController() {
        
        view.backgroundColor = .systemBackground
        
        // add subviews
        view.addSubview(emptyStateBigLabel)
        view.addSubview(emptyStateSmallLabel)
        
        // right bar button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        addButton.tintColor = .systemPurple
        
        navigationItem.rightBarButtonItem = addButton
        
        //left bar button
        let inviteFriendsButton = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.plus"), style: .done, target: self, action: #selector(inviteFriendsTapped))
        
        inviteFriendsButton.tintColor = .systemPurple
        
        navigationItem.leftBarButtonItem = inviteFriendsButton
        
    }
    
    private func showEmptyState() {
        
        if sentUsers.isEmpty {
            // show labels if no users
            mainControllerTableView.isHidden = true
            emptyStateSmallLabel.isHidden = false
            emptyStateBigLabel.isHidden = false
            
        } else {
            // show table view if there are users
            mainControllerTableView.isHidden = false
            emptyStateSmallLabel.isHidden = true
            emptyStateBigLabel.isHidden = true
            
        }
        
    }
    
    private func setConstraints() {
        
        emptyStateBigLabel.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).offset(100)
            make.height.equalTo(40)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(-30)
        }
        
        emptyStateSmallLabel.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).offset(100)
            make.height.equalTo(40)
            make.center.equalTo(view.snp.center)
        }
        
    }
    
    // MARK: Button actions

    @objc private func addButtonTapped() {
        
        
        
    }
    
    @objc private func inviteFriendsTapped() {
        
        let contactsViewController = ContactsViewController()
        
        DispatchQueue.main.async { [weak self] in
            self?.present(contactsViewController, animated: true)
        }
        
    }
    
    // MARK: Functions
    // sorting users based on time (the most recent one is first in tableview)
    private func sortData() {
        
        sentUsers.sort { user1, user2 in
            
            if let dateAndTime1 = user1.dateAndTimeSent, let dateAndTime2 = user2.dateAndTimeSent {
                
                return dateAndTime1 > dateAndTime2
                
            }
            
            return false
            
        }
        
    }
    
}

// MARK: ContactsViewControllerDelegate
extension MainViewController: ExistingUsersControllerDelegate {
    
    func sendUsers(users: [User]) {
        
        for user in users {
            
            if let index = sentUsers.firstIndex(where: { $0.fullName == user.fullName } ) {
                
                sentUsers[index].dateAndTimeSent = Date()
                
            } else {
                
                sentUsers.append(user)
                
                sentUsers[sentUsers.count - 1].dateAndTimeSent = Date()
                
            }
            
        }
        
        sortData()
        
        self.mainControllerTableView.reloadData()
        
    }
    
}

// MARK: TableView Delegate and Data Source
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sentUsers.count
        
    }
    
    // cell styling
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userName = sentUsers[indexPath.row].fullName
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        
        userCell.userNameLabel.text = userName
        
        return userCell
        
    }
    
    // selection of rows
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        sentUsers[indexPath.row].dateAndTimeSent = Date()
        
        sortData()
        
        tableView.reloadData()
        
    }
    
    // row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
        
    }
    
    // removing on swipe cell left
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            sentUsers.remove(at: indexPath.row)
            
            mainControllerTableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
}
