//
//  MainViewController.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//
import DLLocalNotifications
import UIKit

class MainViewController: UIViewController {
    
    // MARK: Attributes
    private let constants = Constants.shared
    
    private var userUID: String? {
        guard let uid = UserDefaults.standard.string(forKey: "userUID") else {return nil}
        return uid
    }


    override func viewDidLoad() {
        
        super.viewDidLoad()

        configureMainViewController()
        
        dailyNotification()
        
    }
    
    private func dailyNotification() {
        var dateComponents = DateComponents()
        dateComponents.hour = 12

        let dailyNotification = DLNotification(identifier: "firstNotification", alertTitle: "Hey we miss you 😔", alertBody: "Come back and send someone a Yo 👊", fromDateComponents: dateComponents, repeatInterval: .daily)

        let scheduler = DLNotificationScheduler()
        scheduler.scheduleNotification(notification: dailyNotification)
        scheduler.scheduleAllNotifications()
    }
    
    
    func configureMainViewController() {
        
        view.backgroundColor = .systemBackground
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        
        addButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    
    @objc func closeButtonTapped() {
        
        print("Tapped!")
        
        AuthManager.shared.signOut { [weak self] success in
            
            let navVC = UINavigationController(rootViewController: PhoneNumberViewController())
            navVC.modalPresentationStyle = .fullScreen
            self?.present(navVC, animated: true)
        }
        
    }
    

    
}
