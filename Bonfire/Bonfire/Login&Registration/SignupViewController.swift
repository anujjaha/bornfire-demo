//
//  SignupViewController.swift
//  Bonfire
//
//  Created by Yash on 18/04/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController
{
    @IBOutlet weak var txtFullName : UITextField!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtUserName : UITextField!
    @IBOutlet weak var txtPassword : UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnSignupPressed()
    {
        if (self.txtFullName.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter fullname", inView: self)
        }
        else if (self.txtEmail.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter email address", inView: self)
        }
        else if (self.txtUserName.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter password", inView: self)
        }
        else
        {
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objTourGuideVC = storyTab.instantiateViewController(withIdentifier: "TourGuideVC") as! TourGuideVC
            self.navigationController?.pushViewController(objTourGuideVC, animated: true)
        }
    }

    @IBAction func btnbackPressed()
    {
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
