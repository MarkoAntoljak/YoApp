//
//  PhoneNumberViewController.swift
//  Yo
//
//  Created by Marko Antoljak on 12/10/22.
//

import UIKit
import SnapKit
import PhoneNumberKit

class PhoneNumberViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    // MARK: Attributes
    private let phoneNumberKit = PhoneNumberKit()
    
    private let constants = Constants.shared
    
    // MARK: UI Elements
    private lazy var textField: PhoneNumberTextField = {
        let field = PhoneNumberTextField()
        field.withFlag = true
        field.withExamplePlaceholder = true
        field.textColor = .white
        field.text = "+1 650-555-3434"
        field.font = .systemFont(ofSize: 20,weight: .semibold)
        return field
    }()
    
    private lazy var separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .white
        return line
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "ENTER YOUR PHONE\nNUMBER"
        label.font = .systemFont(ofSize: 24,weight: .black)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.backgroundColor = .black
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: Init
    
    
    // MARK: Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        makeConstraints()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.shared.mainColor
        
        configureNavBar()
        
        addSubviews()
        
        setActions()
        
        setEndEditing()
        
        textField.delegate = self
        
        requestNotificationAuth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    // MARK: View Setup Functions
    private func configureNavBar() {
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .black)]
        
        navigationItem.title = "YO!"
        
        UINavigationBar.appearance().backgroundColor = Constants.shared.mainColor
        
    }
    // ending editing on tap
    private func setEndEditing() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
    }
    
    private func addSubviews() {
        
        view.addSubview(textField)
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(separatorLine)
    }
    
    private func makeConstraints() {
        
        textField.sizeToFit()
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(443)
            make.centerX.equalTo(view.center.x)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(316)
            make.centerX.equalTo(view.center.x)
            make.width.equalTo(view.width)
            make.height.equalTo(80)
        }
        
        button.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(55)
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(view.height - 55)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.centerY.equalTo(463)
            make.height.equalTo(1)
            make.centerX.equalTo(view.center.x)
        }
        
    }
    private func setActions() {
        
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    
    // MARK: Functions
    private func requestNotificationAuth() {
        UNUserNotificationCenter.current().delegate = self
        
        // requesting access to user's notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] accepted, error in
            
            guard let strongSelf = self else {return}
            
            guard accepted == true, error == nil else {
                // if user didn"t allowed notifications, presenting alert
                let alertController = UIAlertController(title: nil, message: "You should enable push notifications for better app experience.", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                alertController.addAction(UIAlertAction(title: "Enable", style: .default, handler: { action in
                    
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }))
                DispatchQueue.main.async {
                    strongSelf.present(alertController, animated: true)
                }
                return
            }
            
            print("user accepted notifications")
        }
    }

    
    // MARK: Actions
    @objc
    private func didTapNext() {
        
        validateInput()
        
    }
    @objc
    private func didTap() {
        
        textField.resignFirstResponder()
        
    }
    
    // MARK: Validating user input
    private func validateInput() {
        
        button.backgroundColor = .black.withAlphaComponent(0.2)
        
        guard let input = textField.text, !input.isEmpty else {
            // show error
            constants.presentError(title: "Error", message: "Please input your phone number.", target: self)
            button.backgroundColor = .black.withAlphaComponent(1)
            return
        }
        
        var phoneString = ""
        
        // validating phone number input
        do {
            let phoneNumberDetails = try phoneNumberKit.parse(input)
            phoneString = phoneNumberDetails.numberString
        }
        catch {
            constants.presentError(title: "Error", message: "Please input correct phone number.", target: self)
            button.backgroundColor = .black.withAlphaComponent(1)
            return
        }
        
        // send code notification
        AuthManager.shared.sendMessageCode(phoneNumber: phoneString) { [weak self] success in
            
            guard let strongSelf = self else {return}
            
            if success {
                // navigate to code vc
                DispatchQueue.main.async {
                    strongSelf.navigationController?.pushViewController(PhoneCodeViewController(), animated: true)
                }
                
            } else {
                // present error to the user
                strongSelf.constants.presentError(
                    title: "Error",
                    message: "There was an error while sending SMS Code. Please try again.",
                    target: strongSelf)
                strongSelf.button.backgroundColor = .black.withAlphaComponent(1)
            }
        }
        
    }
    
    
}
// MARK: UITextField Delegate
extension PhoneNumberViewController: UITextFieldDelegate {
    
    
}
