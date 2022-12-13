//
//  YoPhoneCodeTextField.swift
//  Yo
//
//  Created by Marko Antoljak on 12/12/22.
//
import UIKit

class YoPhoneCodeTextField: UITextField {

    // MARK: Attributes
    var didEnterLastDigit: ((String) -> Void)?
    
    var defaultCharacter = "-"
    
    private var digitLabels = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    // MARK: Configuration
    func configure() {
        
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: 6)
        addSubview(labelsStackView)
        
        labelsStackView.snp.makeConstraints { make in
            make.top.bottom.right.left.equalToSuperview()
        }
        
        addGestureRecognizer(tapRecognizer)
        
    }

    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.center.x = self.center.x
        
        for _ in 1 ... count {
            
            let label = UILabel()
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 45)
            label.textColor = .white
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
            
        }
        
        return stackView
    }
    
    // MARK: Text editing
    @objc
    private func textDidChange() {
        
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
                
            } else {
                
                currentLabel.text = defaultCharacter
                
            }
        }
        
        if text.count == digitLabels.count {
            
            didEnterLastDigit?(text)
            
        }
        
    }
    
}
// MARK: TextField Delegate
extension YoPhoneCodeTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let characterCount = textField.text?.count else { return false }
        
        return characterCount < digitLabels.count || string == ""
        
    }
    
}
