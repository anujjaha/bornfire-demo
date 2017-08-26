//
//  TabBarViewController.swift
//  VIZI
//
//  Created by Bhavik on 16/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate
{
    override func viewDidLoad()
    {
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        appDelegate.bcalltoRefreshChannel = true
        
        if selectedIndex == 0 {
            let nav = viewController as! UINavigationController
            
            if !(nav.visibleViewController?.isKind(of:DiscoverVC.self))! {
                nav.popToRootViewController(animated: true)
            }
        }
        
        else if selectedIndex == 1 {
            let nav = viewController as! UINavigationController
            
            if !(nav.visibleViewController?.isKind(of:MessageVC.self))! {
                nav.popToRootViewController(animated: true)
            }
        }
        
        else if selectedIndex == 2 {
            let nav = viewController as! UINavigationController
            
            if !(nav.visibleViewController?.isKind(of:ActivityVC.self))! {
                nav.popToRootViewController(animated: true)
            }
        }
        else if selectedIndex == 3
        {
            appDelegate.bisUserProfile = true

            let nav = viewController as! UINavigationController
            if !(nav.visibleViewController?.isKind(of:ProfileVC.self))! {
                nav.popToRootViewController(animated: true)
            }
        }
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
