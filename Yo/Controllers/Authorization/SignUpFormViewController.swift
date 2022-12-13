//
//  SignUpFormViewController.swift
//  Yo
//
//  Created by Marko Antoljak on 12/12/22.
//

import UIKit
import SnapKit

class SignUpFormViewController: UIViewController {
    // MARK: Attributes
    private let constants = Constants.shared
    
    // MARK: UI Elements
    // finish button
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.backgroundColor = .black
        button.setTitle("FINISH", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    // titles with separator lines
    private lazy var firstNameView: YoDetailedInfoFormView = {
        let titleView = YoDetailedInfoFormView(title: "FIRST NAME")
        return titleView
    }()
    private lazy var lastNameView: YoDetailedInfoFormView = {
        let titleView = YoDetailedInfoFormView(title: "LAST NAME")
        return titleView
    }()
    private lazy var emailView: YoDetailedInfoFormView = {
        let titleView = YoDetailedInfoFormView(title: "EMAIL ADDRESS")
        return titleView
    }()
    // text fields
    private lazy var firstNameField: UITextField = {
        let field = UITextField()
        field.textColor = .white
        field.tintColor = .white
        field.leftView = UIView(frame: CGRect(x: 10, y: 0, width: 10, height: 0))
        field.font = .systemFont(ofSize: 18, weight: .bold)
        field.autocorrectionType = .no
        field.returnKeyType = .next
        return field
    }()
    private lazy var lastNameField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 10, y: 0, width: 10, height: 0))
        field.textColor = .white
        field.tintColor = .white
        field.font = .systemFont(ofSize: 18, weight: .bold)
        field.autocorrectionType = .no
        field.returnKeyType = .next
        return field
    }()
    private lazy var emailField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 10, y: 0, width: 10, height: 0))
        field.textColor = .white
        field.tintColor = .white
        field.font = .systemFont(ofSize: 18, weight: .bold)
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.placeholder = "(optional) we won't spam you;)"
        return field
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = constants.mainColor
        
        configureNavBar()
        
        addSubviews()
        
        addActions()
        
        setEndEditing()
        
        emailField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        firstNameField.becomeFirstResponder()
    }
    
    // MARK: View Functions
    private func configureNavBar() {
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .black)]
        
        navigationItem.title = "YO!"
        
        UINavigationBar.appearance().backgroundColor = Constants.shared.mainColor
        
        navigationItem.hidesBackButton = true
    }
    
    private func addSubviews() {
        
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(emailField)
        view.addSubview(button)
        view.addSubview(firstNameView)
        view.addSubview(lastNameView)
        view.addSubview(emailView)
    }
    
    // ending editing on tap
    private func setEndEditing() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
    }
    
    private func addActions() {
        
        button.addTarget(self, action: #selector(didTapFinish), for: .touchUpInside)
    }
    
    private func setConstraints() {
        
        firstNameField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(330)
        }
        lastNameField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(430)
        }
        emailField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(535)
        }
        
        button.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(55)
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(782)
        }
        
        firstNameView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(290)
        }
        lastNameView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(390)
        }
        emailView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(495)
        }
        
    }
    
    // MARK: Actions
    @objc
    private func didTap() {
        
        emailField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        
    }
    @objc
    private func didTapFinish() {
        
       validateInput()
    }
    
    // MARK: Function
    // validating user input
    private func validateInput() {
        
        print(firstNameField.text)
        print(lastNameField.text)
        print(emailField.text)
        
        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailField.text,
              !firstName.trimmingCharacters(in: .whitespaces).isEmpty,
              !lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            // if email is entered
            if emailField.text!.count > 1 && !emailField.text!.contains("@") {
                constants.presentError(title: "Error", message: "Please input correct email.", target: self)
                return
            }
            
            constants.presentError(title: "Error", message: "Please enter valid first and last name.", target: self)
            return
        }
        
        // if validation is good register user
        registerUser(firstName: firstName, lastName: lastName, email: email)
    }
    // registering new user
    private func registerUser(firstName: String, lastName: String, email: String) {
        
        validateInput()
        
        guard let userUID = UserDefaults.standard.string(forKey: "userUID") else {return}
        
        // firebase auth registration
        DatabaseManager.shared.insertNewUser(userUID: userUID, firstName: firstName, lastName: lastName, email: email) { [weak self] success in
            
            guard let strongSelf = self else {return}
            
            if success {
                
                let navVC = UINavigationController(rootViewController: MainViewController())
                navVC.modalPresentationStyle = .fullScreen
                
                DispatchQueue.main.async {
                    strongSelf.present(navVC, animated: true)
                }
                
            } else {
                
                strongSelf.constants.presentError(title: "Error", message: "There was a problem. Try again.", target: strongSelf)
            }
        }
        
    }

    
}
// MARK: Text Field Delegate
extension SignUpFormViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstNameField {
            
            lastNameField.becomeFirstResponder()
            
        } else if textField == lastNameField {
            
            emailField.becomeFirstResponder()
            
        } else {
            
            emailField.resignFirstResponder()
            
        }
        return true
    }
}
