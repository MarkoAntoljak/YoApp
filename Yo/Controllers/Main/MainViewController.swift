//
//  MainViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit

class MainViewController: UIViewController {
    
    var sentUsers: [User] = []
    
    let mainControllerTableView = UITableView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupMainViewController()
        
        viewDidLayoutSubviews()
        
        setupMainTableView()
        
    }
    

    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        mainControllerTableView.translatesAutoresizingMaskIntoConstraints = false
        
        mainControllerTableView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
        
    }
    
    
    private func setupMainTableView() {
        
        view.addSubview(mainControllerTableView)
                
        mainControllerTableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        
        mainControllerTableView.delegate = self
        
        mainControllerTableView.dataSource = self
        
    }
    
    
    func setupMainViewController() {
        
        view.backgroundColor = .systemBackground
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        addButton.tintColor = .systemPurple
        
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    
    @objc func addButtonTapped() {
        
        let contactsViewController = ContactsViewController()
        
        present(contactsViewController, animated: true)
        
        contactsViewController.contactsDelegate = self
        
    }
    
    
    func sortData() {
        
        sentUsers.sort { user1, user2 in
            
            if let dateAndTime1 = user1.dateAndTimeSent, let dateAndTime2 = user2.dateAndTimeSent {
                
                return dateAndTime1 > dateAndTime2
                
            }
            
            return false
            
        }
        
    }
    
}


extension MainViewController: ContactsViewControllerDelegate {
    
    func sendUsers(users: [User]) {
        
        for user in users {
            
            if let index = sentUsers.firstIndex(where: { $0.name == user.name } ) {
                
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


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sentUsers.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userName = sentUsers[indexPath.row].name
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        
        userCell.userNameLabel.text = userName
        
        return userCell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        sentUsers[indexPath.row].dateAndTimeSent = Date()
        
        sortData()
        
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            sentUsers.remove(at: indexPath.row)
            
            mainControllerTableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
}
