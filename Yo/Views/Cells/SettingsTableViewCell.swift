//
//  ProfileSettingsTableViewCell.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/12/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "SettingsCell"
    
    let iconImageView = UIImageView(frame: .zero)
    
    let titleLabel = UILabel(frame: .zero)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        setupProfileTableViewCell()
        
        setupTitle()
        
        setupIconImage()
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    func setupProfileTableViewCell() {
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
        addSubview(iconImageView)
        
        addSubview(titleLabel)
        
        // Set right arrow on cell to be purple
        
        let image = UIImage(systemName: "chevron.right")
        let accessory  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!))
        accessory.image = image
        accessory.tintColor = UIColor.systemPurple
        accessoryView = accessory
                
    }
    
    
    func setupTitle() {
        
        NSLayoutConstraint.activate([
        
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        
        ])
        
        titleLabel.textColor = .label
        
    }
    
    
    func setupIconImage() {
        
        NSLayoutConstraint.activate([
        
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
            
        
        ])
        
        iconImageView.tintColor = .systemPurple
        
    }

    
}
