//
//  YoDetailedInfoFormView.swift
//  Yo
//
//  Created by Marko Antoljak on 12/12/22.
//

import UIKit

class YoDetailedInfoFormView: UIView {

    // MARK: Attributes
    private let title: String
    
    // MARK: UI Elements
    /// title
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .black)
        return label
    }()
    /// separator line
    private lazy var separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .white
        return line
    }()
    
    // MARK: Init
    
    init(title: String) {
        self.title = title
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
        // setup view
        self.setUpView()

    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: View Setup
    private func setUpView() {
        // add subview
        addSubview(titleLabel)
        addSubview(separatorLine)
        // set constraints
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(400)
        }
        separatorLine.snp.makeConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.bottom).offset(100)
        }
        
    }

}
