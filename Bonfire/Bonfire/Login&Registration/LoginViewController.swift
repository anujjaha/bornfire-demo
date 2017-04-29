//
//  LoginViewController.swift
//  Bonfire
//
//  Created by Yash on 17/04/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{

    @IBOutlet weak var txtUserName : UITextField!
    @IBOutlet weak var txtPassword : UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLoginPressed()
    {
        if (self.txtUserName.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter password", inView: self)
        }
        else
        {
            UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
            UserDefaults.standard.synchronize()
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
            self.navigationController?.pushViewController(tabbar, animated: true)
        }
    }

    @IBAction func btnbackPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
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
