//
//  LOLNavigationController.swift
//  SwiftTest
//
//  Created by 吴鼎 on 2017/5/25.
//  Copyright © 2017年 吴鼎. All rights reserved.
//

import UIKit

class LOLNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationAttbutes()
    }
    
    func setupNavigationAttbutes(){
        self.navigationBar.setBackgroundImage(UIImage(named: "nav_bar_bg"), forBarMetrics: .Default)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:WDColor(228.0, 181.0, 121.0, 1.0)]
        self.navigationBar.shadowImage = UIImage()
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count>0 {
            viewController.hidesBottomBarWhenPushed = true
            if viewController.navigationItem.leftBarButtonItem == nil {
                let btn = UIButton(type: .Custom)
                btn.frame = CGRectMake(0, 0, 44, 44)
                btn.contentHorizontalAlignment = .Left
                btn.setImage(UIImage(named: "nav_btn_back_normal"), forState: .Normal)
                btn.setImage(UIImage(named: "nav_btn_back_pressed"), forState: .Normal)
                btn.addTarget(self, action: #selector(UINavigationController.popViewControllerAnimated(_:)), forControlEvents: .TouchUpInside)
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
            }
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
