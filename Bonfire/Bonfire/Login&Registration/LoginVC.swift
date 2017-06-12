//
//  LoginVC.swift
//  Bonfire
//
//  Created by Yash on 16/04/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    var strCampusCode = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    @IBAction func btnLoginPressed()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objLoginVC = storyTab.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(objLoginVC, animated: true)
    }

    @IBAction func btnSignupPressed()
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objLoginVC = storyTab.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        objLoginVC.campusID = strCampusCode;
        self.navigationController?.pushViewController(objLoginVC, animated: true)
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
