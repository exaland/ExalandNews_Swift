//
//  TabBarController.swift
//  exaland_NewsMvvm
//
//  Created by Alexandre Magnier on 02/12/2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let homeController = HomeNewsView()
        let galleryViewController = GalleryNewsView()
        
        let homeControllerNavController = createNavControlelr(vc: homeController, itemName: "Accueil", itemImage: "house")
        
        let galleryViewNavController = createNavControlelr(vc: galleryViewController, itemName: "Gallerie", itemImage: "magnifyingglass")
        
        homeController.title = "Accueil"
        
        
        self.setViewControllers([homeControllerNavController,galleryViewNavController], animated: true)
        
        
        guard let items = self.tabBar.items else { return }
        
        
        let images = ["house","magnifyingglass"]
        
        for x in 0...1 {
            items[x].image = UIImage(systemName: images[x])
        }
        
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = AppColor.BottomBar
        self.tabBar.tintColor =  AppColor.BottomBar
        
    }
    
    /**
     Crée une Navigation Bar Controller et l'insert dans la TabController
     */
    
    func createNavControlelr(vc: UIViewController, itemName: String, itemImage: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: itemImage)?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)), tag: 0)
        item.titlePositionAdjustment = .init(horizontal: 0, vertical: 10)
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        return navController
    }
}
