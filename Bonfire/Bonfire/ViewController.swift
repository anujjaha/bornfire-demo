//
//  ViewController.swift
//  Bonfire
//
//  Created by Kevin on 16/04/17.
//  Copyright © 2017 Kevin. All rights reserved.
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        appDelegate.bisUserLogout = false
        if let campuscode = UserDefaults.standard.value(forKey: kkeyCampusCode)
        {
            self.txtCampusCode.text = campuscode as? String
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (self.txtCampusCode.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter campus code", inView: self)
        }
        else
        {
            let arr = UserDefaults.standard.value(forKey: "campusData") as! NSArray
            
            if arr.count>0
            {
                let code = self.txtCampusCode.text!
                
                let campus = NSPredicate(format: "%K = %@", "campusCode",code)
                let arrcampusdata = arr .filtered(using: campus);
                print(arrcampusdata)
                
                if arrcampusdata.count > 0
                {
                    UserDefaults.standard.set(self.txtCampusCode.text!, forKey: kkeyCampusCode)
                    UserDefaults.standard.set((arrcampusdata[0] as AnyObject).value(forKey: kkeyCampusID), forKey: kkeyCampusID)
                    UserDefaults.standard.synchronize()
                    
                    textField.resignFirstResponder()
                    
                    let storyTab = UIStoryboard(name: "Main", bundle: nil)
                    let objLoginVC = storyTab.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    objLoginVC.strCampusCode = self.txtCampusCode.text!
                    objLoginVC.iCampusID = (arrcampusdata[0] as AnyObject).value(forKey: kkeyCampusID) as! Int
                    self.navigationController?.pushViewController(objLoginVC, animated: true)
                }
                else
                {
                    App_showAlert(withMessage: "Please enter valid campus code", inView: self)
                }
            }
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
@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

