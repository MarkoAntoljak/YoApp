//
//  Extensions.swift
//  Yo
//
//  Created by Marko Antoljak on 12/10/22.
//

import Foundation
import UIKit


// extension of uiview for easier naming convention
extension UIView {
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.origin.x + width
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + height
    }
    
    public var width: CGFloat {
        return frame.width
    }
    
    public var height: CGFloat {
        return frame.height
    }
}

