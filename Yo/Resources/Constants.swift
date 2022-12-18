//
//  Constants.swift
//  Yo
//
//  Created by Marko Antoljak on 12/10/22.
//

import Foundation
import UIKit

struct Constants {
    
    // MARK: Attributes
    
    static let shared = Constants()
    
    // main color
    public let mainColor: UIColor = UIColor(named: "Color")!
    
    
    // MARK: Functions
    // present error
    public func presentError(title: String, message: String, target: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        DispatchQueue.main.async { [weak target] in
            target?.present(alert, animated: true)
        }
        
    }
   

}
