//
//  LOLTabBarController.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/5/25.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

class LOLTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor.init(red: 68/255.0, green: 135/255.0, blue: 194/255.0, alpha: 1.0)

        let newsVC = LOLNewsViewController.init()
        newsVC.tabBarItem.title = "资讯"
        newsVC.tabBarItem.image = UIImage(named: "tab_icon_news_normal")?.imageWithRenderingMode(.AlwaysOriginal)
        newsVC.tabBarItem.selectedImage = UIImage(named: "tab_icon_news_press")?.imageWithRenderingMode(.AlwaysOriginal)
        
        let friendsVC = LOLNewsViewController.init()
        friendsVC.tabBarItem.title = "好友"
        friendsVC.tabBarItem.image = UIImage(named: "tab_icon_friend_normal")?.imageWithRenderingMode(.AlwaysOriginal)
        friendsVC.tabBarItem.selectedImage = UIImage(named: "tab_icon_friend_press")?.imageWithRenderingMode(.AlwaysOriginal)
        
        let findVC = LOLNewsViewController.init()
        findVC.tabBarItem.title = "发现"
        findVC.tabBarItem.image = UIImage(named: "tab_icon_quiz_normal")?.imageWithRenderingMode(.AlwaysOriginal)
        findVC.tabBarItem.selectedImage = UIImage(named: "tab_icon_quiz_press")?.imageWithRenderingMode(.AlwaysOriginal)
        
        let mineVC = LOLNewsViewController.init()
        mineVC.tabBarItem.title = "我"
        mineVC.tabBarItem.image = UIImage(named: "tab_icon_more_normal")?.imageWithRenderingMode(.AlwaysOriginal)
        mineVC.tabBarItem.selectedImage = UIImage(named: "tab_icon_more_press")?.imageWithRenderingMode(.AlwaysOriginal)
        
        let navi1 = LOLNavigationController(rootViewController:newsVC)
        let navi2 = LOLNavigationController(rootViewController:friendsVC)
        let navi3 = LOLNavigationController(rootViewController:findVC)
        let navi4 = LOLNavigationController(rootViewController:mineVC)
        self.viewControllers = [navi1,navi2,navi3,navi4]
        
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.shadowImage = UIImage.init()
    }
}
