//
//  CustomUITabBarController.swift
//  Yo
//
//  Created by Marko Antoljak on 12/15/22.
//

import UIKit

class CustomUITabBarController: UITabBarController {
    
    
    var color: UIColor?
    var radius: CGFloat = 15.0
    
    private var shapeLayer: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShape()
        
        tabBar.tintColor = .white
        
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.systemPurple.cgColor
        
        if let oldShapeLayer = self.shapeLayer {
            
            tabBar.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
            
        } else {
            
            tabBar.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    private func createPath() -> CGPath {
        let path = UIBezierPath(
            roundedRect: view.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: 0.0))
        
        return path.cgPath
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.isTranslucent = true
        var tabFrame            = self.tabBar.frame
        tabFrame.size.height    = 65 + (view.safeAreaInsets.bottom)
        tabFrame.origin.y       = self.view.frame.origin.y +   ( self.view.frame.height - 65 - (view.safeAreaInsets.bottom))
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.frame            = tabFrame
        
        self.tabBar.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0) })
        
        
    }
    
    
    
}
