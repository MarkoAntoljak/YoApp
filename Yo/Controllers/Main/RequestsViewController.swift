//
//  RequestsViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/14/22.
//

import UIKit

class RequestsViewController: UIViewController {
    
    
    let dummyUsers = UserData.users
    
    let requestsTableView = UITableView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        viewDidLayoutSubviews()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        navigationItem.title = "Your YOs"
        
        setupTableView()
        
    }
    
}


extension RequestsViewController: UITableViewDelegate, UITableViewDataSource, RequestTableViewCellDelegate {
    
    
    
    func setupTableView() {
        
        requestsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(requestsTableView)
        
        requestsTableView.frame = CGRect(x: 0, y: 110, width: view.frame.width, height: view.frame.height)
        
        requestsTableView.delegate = self
        
        requestsTableView.dataSource = self
                
        requestsTableView.register(RequestTableViewCell.self, forCellReuseIdentifier: RequestTableViewCell.reuseIdentifier)
        
    }
    
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentUser = dummyUsers[indexPath.row]
        
        let cell = requestsTableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.reuseIdentifier, for: indexPath) as! RequestTableViewCell
    
        cell.requestTableViewCellDelegate = self
        
        cell.usernameLabel.text = currentUser.name
        
        return cell
        
    }
    
    
    func yoButtonTapped(title: String) {
        
        print(title)
        
    }

}
