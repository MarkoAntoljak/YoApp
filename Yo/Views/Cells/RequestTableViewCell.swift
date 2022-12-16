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


    static let reuseIdentifier = "RequestCell"
    
    weak var requestTableViewCellDelegate: RequestTableViewCellDelegate?
    
    let usernameLabel = UILabel(frame: .zero)
    
    let yoButtton = UIButton()
    
    lazy var profileImage: UIImageView = {
        let pic = UIImageView()
        pic.image = UIImage(named: "user")
        pic.image = pic.image?.withRenderingMode(.alwaysTemplate)
        pic.tintColor = UIColor.systemPurple
        pic.layer.masksToBounds = false
        pic.layer.cornerRadius = pic.frame.height / 2
        pic.clipsToBounds = true
        return pic
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutSubviews()
                
        setupTableViewCell()
        
    }
    
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
    
    
    func setupTableViewCell() {
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        yoButtton.translatesAutoresizingMaskIntoConstraints = false
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(usernameLabel)
        
        addSubview(yoButtton)
        
        addSubview(profileImage)
        
        NSLayoutConstraint.activate([
            
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
        
            usernameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20),
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: yoButtton.leadingAnchor, constant: -40),
            
            yoButtton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            yoButtton.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
        
        usernameLabel.lineBreakMode = .byTruncatingTail
        
        yoButtton.setTitle("Send", for: .normal)
        
        yoButtton.setTitleColor(.systemYellow, for: .normal)
        
        yoButtton.addTarget(self, action: #selector(self.yoTapped), for: .touchUpInside)
        
    }
    
    
    @objc func yoTapped() {
        
        requestTableViewCellDelegate?.yoButtonTapped(title: usernameLabel.text!)
        
    }

}
