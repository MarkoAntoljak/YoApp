//
//  PhoneCodeViewController.swift
//  Yo
//
//  Created by Marko Antoljak on 12/12/22.
//

import UIKit
import MaterialComponents

class PhoneCodeViewController: UIViewController {
    
    // MARK: Attributes
    private let constants = Constants.shared
    
    // MARK: UI Elements
    private lazy var textField: YoPhoneCodeTextField = {
        let field = YoPhoneCodeTextField()
        field.isHidden = false
        return field
    }()
    private lazy var activityIndicator: MDCActivityIndicator = {
        let indicator = MDCActivityIndicator()
        indicator.cycleColors = [.white]
        indicator.radius = 24
        indicator.strokeWidth = 5
        indicator.stopAnimating()
        return indicator
    }()
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "ENTER CONFIRMATION\nCODE"
        label.font = .systemFont(ofSize: 24,weight: .black)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    private lazy var resendCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Didn't get code? Resend.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
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
        
        configureCodeField()
        
        setEndEditing()
        
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
        
        navigationItem.backButtonTitle = ""
        
        navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(didTapBackButton))
        
        backButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = backButton
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
        view.addSubview(resendCodeButton)
        view.addSubview(activityIndicator)
    }
    private func makeConstraints() {
        
        textField.snp.makeConstraints { make in
            make.width.equalTo(288)
            make.height.equalTo(40)
            make.centerY.equalTo(423)
            make.centerX.equalTo(view.center.x)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(316)
            make.centerX.equalTo(view.center.x)
            make.width.equalTo(view.width)
            make.height.equalTo(80)
        }
        
        resendCodeButton.snp.makeConstraints { make in
            make.width.equalTo(view.width)
            make.height.equalTo(20)
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(view.height - 150)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
    }
    private func configureCodeField() {
        
        textField.configure()
        textField.didEnterLastDigit = { [weak self] code in
            
            self?.textField.endEditing(true)
            self?.userAuth(with: code)
            
        }
    }
    private func setActions() {
        
        resendCodeButton.addTarget(self, action: #selector(didTapResendCode), for: .touchUpInside)
    }
    // MARK: Actions
    @objc
    private func didTapNext() {
        
        navigationController?.pushViewController(SignUpFormViewController(), animated: true)
        
    }
    @objc
    private func didTapResendCode() {
        
        resendCodeButton.setTitle("New code is sent.", for: .normal)
        resendCodeButton.isEnabled = false
        
        // sent code
        print("Sending code...")
    }
    @objc
    private func didTapBackButton() {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    @objc
    private func didTap() {
        
        textField.resignFirstResponder()
        
    }
    // MARK: User Authentication
    private func userAuth(with code: String) {
        
        // show activity indicator
        activityIndicator.startAnimating()
        textField.isHidden = true
        
        print(code)
        // authenticate user with Firebase
        AuthManager.shared.verifyCode(SMSCode: code) { [weak self] success in
            
            guard let strongSelf = self else {return}
            
            if success {
                
                guard let userUID = UserDefaults.standard.string(forKey: "userUID") else {return}
                
                DatabaseManager.shared.checkIfUserExists(userUID: userUID) { [weak self] exists in
                    
                    guard let strongSelf = self else {return}
                    
                    if exists {
                        
                        DatabaseManager.shared.getUserData(for: userUID) { [weak self] user in
                            
                            guard let strongSelf = self else {return}
                            
                            // navigate to main screen if user exists
                            let navVC = UINavigationController(rootViewController: MainViewController(/*user: user*/))
                            navVC.modalPresentationStyle = .fullScreen
                            
                            DispatchQueue.main.async {
                                strongSelf.activityIndicator.stopAnimating()
                                strongSelf.present(navVC, animated: true)
                            }
                        }
                        
                    } else {
                        // if user doesnt exist send him to register
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            
                            strongSelf.activityIndicator.stopAnimating()
                            strongSelf.navigationController?.pushViewController(SignUpFormViewController(), animated: true)
                        }
                    }
                }
            } else {
                // present if any error occured
                strongSelf.constants.presentError(title: "Error", message: "Wrong verification code.", target: strongSelf)
            }
        }
    }
    
    
    
}
