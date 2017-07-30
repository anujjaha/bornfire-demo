//
//  GroupTitleVC.swift
//  Bonfire
//
//  Created by Yash on 21/05/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class GroupTitleVC: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    @IBAction func btngotoActivityAction(_ sender: UIButton)
    {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
      _ = self .navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func buttonBackTap(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
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
