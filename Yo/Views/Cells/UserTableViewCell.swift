//
//  UserTableViewCell.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.


import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "UserCell"
    
    let userNameLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        setupUserTableViewCell()
        
    }
    
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    private func setupUserTableViewCell() {
        
        addSubview(userNameLabel)
        
        setupUsername()
        
    }
    
    
    private func setupUsername() {
        
        userNameLabel.lineBreakMode = .byTruncatingTail
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userNameLabel.font = .boldSystemFont(ofSize: 28)
        
        userNameLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
        
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        
        ])
        
    }
    
}
