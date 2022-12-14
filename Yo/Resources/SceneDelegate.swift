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
                
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        window?.windowScene = windowScene
        
        // directing user to home screen if it is already signed in
//        if AuthManager.shared.isSignedIn {
//
//
//
//        } else {
//            // user is not signed in
//            window?.rootViewController = UINavigationController(rootViewController: PhoneNumberViewController())
//
//        }
        window?.rootViewController = setupTabBar()
        
        window?.makeKeyAndVisible()
        
    }
    
    
    func setupMainNavController() -> UINavigationController {
        
        let mainViewController = MainViewController()
        
        mainViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "thunder"), tag: 0)
        
        mainViewController.title = ""
        
        return UINavigationController(rootViewController: mainViewController)
        
    }
    
    
    func setupRequestsNavController() -> UINavigationController {
        
        let requestsViewController = RequestsViewController()
        
        requestsViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "star"), tag: 1)
        
        requestsViewController.title = ""
        
        return UINavigationController(rootViewController: requestsViewController)
        
    }
    
    
    func setupProfileNavController() -> UINavigationController {
        
        let profileViewController = ProfileSettingsViewController()
        
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "user"), tag: 2)
        
        profileViewController.title = ""
        
        return UINavigationController(rootViewController: profileViewController)
        
    }
    
    
    func setupTabBar() -> UITabBarController {
        
        let tabBarController = UITabBarController()
        
        UITabBar.appearance().tintColor = .systemPurple
        
        let tabBarLineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBarController.tabBar.frame.size.width, height: 0.2))
        
        tabBarLineView.backgroundColor = UIColor.systemGray6
        
        tabBarController.tabBar.addSubview(tabBarLineView)
                
        tabBarController.viewControllers = [setupMainNavController(), setupRequestsNavController(), setupProfileNavController()]
        
        return tabBarController
        
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

