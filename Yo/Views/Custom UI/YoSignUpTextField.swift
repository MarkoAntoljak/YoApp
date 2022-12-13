//
//  YoSignUpTextField.swift
//  Yo
//
//  Created by Marko Antoljak on 12/14/22.
//

import UIKit

class YoSignUpTextField: UITextField {

    // MARK: Attributes
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = .white
        tintColor = .white
        leftView = UIView(frame: CGRect(x: 10, y: 0, width: 10, height: 0))
        font = .systemFont(ofSize: 18, weight: .bold)
        autocorrectionType = .no
    }

    required init?(coder: NSCoder) {
        fatalError()
    }


}
