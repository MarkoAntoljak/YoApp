//
//  RequestsViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/14/22.
//

import UIKit

class RequestsViewController: UIViewController {
    
    // MARK: Attributes
    
    var receviedUsers: [User] = []
    
    let requestsTableView = UITableView()
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchUsers()
        
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationItem.title = "Your YOs"
        
        setupTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchUsers()
    }
    
    // MARK: Functions
    private func fetchUsers() {
        
        DatabaseManager.shared.getReceivedYos { result in
            
            switch result {
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
            case .success(let users):
                
                DispatchQueue.main.async { [weak self] in
                    
                    self?.receviedUsers = users
                    
                    print(users.first?.fullName)
                    
                    self?.requestsTableView.reloadData()
                }
                
            }
        }
        
    }


    
}


extension RequestsViewController: UITableViewDelegate, UITableViewDataSource, RequestTableViewCellDelegate {
    
    func setupTableView() {
        
        requestsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(requestsTableView)
        
        requestsTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.top)
            make.height.equalTo(view.snp.height).offset(-(navigationController?.tabBarController?.tabBar.height ?? 100))
        }
        
        requestsTableView.delegate = self
        
        requestsTableView.dataSource = self
                
        requestsTableView.register(RequestTableViewCell.self, forCellReuseIdentifier: RequestTableViewCell.reuseIdentifier)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receviedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentUser = receviedUsers[indexPath.row]
        
        let cell = requestsTableView.dequeueReusableCell(withIdentifier: RequestTableViewCell.reuseIdentifier, for: indexPath) as! RequestTableViewCell
    
        cell.requestTableViewCellDelegate = self
        
        cell.usernameLabel.text = currentUser.fullName
        
        return cell
        
    }
    
    
    func yoButtonTapped(title: String) {
        
        print(title)
        
    }

}
