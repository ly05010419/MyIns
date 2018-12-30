//
//  InsTabBarController.swift
//  MyIns
//
//  Created by LiYong on 2018/12/7.
//  Copyright © 2018年 Liyong. All rights reserved.
//

import UIKit

class InsTabBarController: UITabBarController,UITabBarControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self;
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "relogin"), object: nil, queue: OperationQueue.main) { (Notification) in
            self.selectedIndex = 0;
        }
        
    }
    
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{

        let index = tabBarController.viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            
            self.performSegue(withIdentifier: "shareSegue", sender: nil)
            
            return false
        }
        
        return true
        
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        
        let index = tabBarController.viewControllers?.firstIndex(of: viewController)
        
        if index == 0 {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "playVideo"), object: nil)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "stopVideo"), object: nil)
            
        }
    }
    

}
