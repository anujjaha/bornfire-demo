//
//  ViewController.swift
//  Bonfire
//
//  Created by Yash on 16/04/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var txtCampusCode : UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (self.txtCampusCode.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter campus code", inView: self)
        }
        else
        {
            UserDefaults.standard.set(self.txtCampusCode.text!, forKey: kkeyCampusCode)
            UserDefaults.standard.synchronize()
           
            textField.resignFirstResponder()
            
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objLoginVC = storyTab.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            objLoginVC.strCampusCode = self.txtCampusCode.text!
            self.navigationController?.pushViewController(objLoginVC, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        return true
    }


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

