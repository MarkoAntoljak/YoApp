//
//  MainViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        configureMainViewController()
        
    }
    
    
    func configureMainViewController() {
        
        view.backgroundColor = .systemBackground
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        addButton.tintColor = .systemPurple
        
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    
    @objc func addButtonTapped() {
        
        print("Tapped!")
        
    }
    
}
