//
//  SceneDelegate.swift
//  Yo
//
//  Created by Tomi Antoljak on 12/10/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
        window = UIWindow(windowScene: windowScene)
        
        // directing user to home screen if it is already signed in
        if AuthManager.shared.isSignedIn {

            window?.rootViewController = TabBarController()

        } else {
            // user is not signed in
            window?.rootViewController = UINavigationController(rootViewController: PhoneNumberViewController())

        }

        window?.makeKeyAndVisible()
        
    }


}

