//
//  ProfileSettingsTableViewCell.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/12/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "SettingsCell"
    
    let iconImageView = UIImageView()
    
    let titleLabel = UILabel()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
                
        setupConstraints()
        
        setupProfileTableViewCell()
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    private func addSubviews() {
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        
    }
    
    
    func setupProfileTableViewCell() {
        
        titleLabel.textColor = .systemPurple
        
        iconImageView.tintColor = .systemPurple
        
        let image = UIImage(systemName: "chevron.right")
        let accessory  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!))
        accessory.image = image
        accessory.tintColor = UIColor.systemPurple
        accessoryView = accessory
                
    }
    
    
    private func setupConstraints() {
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
    }

    
}
