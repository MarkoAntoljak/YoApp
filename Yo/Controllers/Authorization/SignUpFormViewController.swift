//
//  SignUpFormViewController.swift
//  Yo
//
//  Created by Marko Antoljak on 12/12/22.
//

import UIKit
import SnapKit
import Lottie

class SignUpFormViewController: UIViewController {
    
    // MARK: Attributes
    private let constants = Constants.shared
    
    private var animationView: LottieAnimationView?
    
    // MARK: UI Elements
    // finish button
    private lazy var button: UIButton = {
        let button = UIButton()
        button.isHidden = false
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
        titleView.isHidden = false
        return titleView
    }()
    private lazy var lastNameView: YoDetailedInfoFormView = {
        let titleView = YoDetailedInfoFormView(title: "LAST NAME")
        titleView.isHidden = false
        return titleView
    }()
    private lazy var emailView: YoDetailedInfoFormView = {
        let titleView = YoDetailedInfoFormView(title: "EMAIL ADDRESS")
        titleView.isHidden = false
        return titleView
    }()
    // text fields
    private lazy var firstNameField: YoSignUpTextField = {
        let field = YoSignUpTextField()
        field.returnKeyType = .next
        field.isHidden = false
        return field
    }()
    private lazy var lastNameField: YoSignUpTextField = {
        let field = YoSignUpTextField()
        field.returnKeyType = .next
        field.isHidden = false
        return field
    }()
    private lazy var emailField: YoSignUpTextField = {
        let field = YoSignUpTextField()
        field.keyboardType = .emailAddress
        field.isHidden = false
        field.autocapitalizationType = .none
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
        
        addAnimation()
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        animationView!.stop()
    }
    
    // MARK: View Functions
    private func addAnimation() {
        
        animationView = .init(name: "finished_animation")
         
        animationView!.frame = view.bounds
        
        animationView!.contentMode = .scaleAspectFit
        
        animationView!.loopMode = .loop
          
        view.addSubview(animationView!)
        
        animationView!.isHidden = true
    }
    
    private func showSuccessAnimation() {
        
        animationView!.isHidden = false
        
        animationView!.play()
        
        firstNameView.isHidden = true
        lastNameView.isHidden = true
        emailView.isHidden = true
        firstNameField.isHidden = true
        lastNameField.isHidden = true
        emailField.isHidden = true
        button.isHidden = true
        
        navigationItem.title = ""
    }
    
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
            make.centerY.equalTo(view.height - 55)
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
        
//        print(firstNameField.text!)
//        print(lastNameField.text!)
//        print(emailField.text!)
        
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
        registerUser(firstName: "Marko", lastName: "Antoljak", email: "")
    }
    // registering new user
    private func registerUser(firstName: String, lastName: String, email: String) {
        
        validateInput()
        
        guard let userUID = UserDefaults.standard.string(forKey: "userUID") else {return}
        
        // firebase auth registration
        DatabaseManager.shared.insertNewUser(userUID: userUID, firstName: firstName, lastName: lastName, email: email) { [weak self] success in
            
            guard let strongSelf = self else {return}
            
            if success {
                
                // show success animation
                DispatchQueue.main.async {
                    strongSelf.showSuccessAnimation()
                }
                // navigate to main screen
                let navVC = UINavigationController(rootViewController: MainViewController())
                navVC.modalPresentationStyle = .fullScreen
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
            
            // show success animation
            DispatchQueue.main.async { [weak self] in
                self?.showSuccessAnimation()
            }
        }
        return true
    }
}
