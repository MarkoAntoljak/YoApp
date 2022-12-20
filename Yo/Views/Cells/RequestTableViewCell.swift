//
//  RequestTableViewCell.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/14/22.
//

import UIKit

protocol RequestTableViewCellDelegate: AnyObject {
    
    func yoButtonTapped(title: String)
    
}

class RequestTableViewCell: UITableViewCell {

    // MARK: Attributes

    static let reuseIdentifier = "RequestCell"
    
    weak var requestTableViewCellDelegate: RequestTableViewCellDelegate?
    
    let usernameLabel = UILabel()
    
    let yoButtton = UIButton()
    
    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutSubviews()
                
        setupTableViewCell()
        
    }
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    // MARK: Lifecycle

    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    
    func setupTableViewCell() {
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        yoButtton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(usernameLabel)
        
        addSubview(yoButtton)
    
        
        NSLayoutConstraint.activate([
        
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: yoButtton.leadingAnchor, constant: -40),
            
            yoButtton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            yoButtton.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
        
        usernameLabel.lineBreakMode = .byTruncatingTail
        
        yoButtton.setTitle("Send", for: .normal)
        
        yoButtton.setTitleColor(.systemYellow, for: .normal)
        
        
    }

}
