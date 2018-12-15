//
//  MainTabBarController.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/21/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            return false
            
        } 
    
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        UITabBar.appearance().tintColor = .gold()
        UITabBar.appearance().unselectedItemTintColor = .gold()
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        setupViewControllers()
        
        
    }
    
    func setupViewControllers() {
        
        //Home
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        //Search
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // plus
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_selected"))
        
        // likes
        let likesNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
        // User profile
        let layout = UICollectionViewFlowLayout()
        let userProfileController =  UserProfileController(collectionViewLayout: layout)
        
        
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        // Image literals are set (this variables are not empty you can't see the value bc the background color.
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        viewControllers = [homeNavController, searchNavController, plusNavController, likesNavController, userProfileNavController]
        
        // Modify tab bar item insets
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
        
    }
}
