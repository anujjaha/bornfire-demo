//
//  SignupViewController.swift
//  Bonfire
//
//  Created by Kevin on 18/04/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController
{
    @IBOutlet weak var txtFullName : UITextField!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtUserName : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    var campusID = String()
    
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
            self.view .endEditing(true)
            self.callSignUPAPI()
        }
    }

    func callSignUPAPI() {
        let url = kServerURL + kSignUP
        let parameters: [String: Any] = ["name": self.txtFullName.text!, "email": self.txtEmail.text!, "password": self.txtPassword.text!,"username": self.txtUserName.text!,"campus_id":Int(campusID)!]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request(url, method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil {
                    print(response.result.value!)
                    
                    if let json = response.result.value {
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if dictemp.count > 0 {
                            
                            if let err  =  dictemp.value(forKey: kkeyError) {
                                App_showAlert(withMessage: err as! String, inView: self)
                            }else {
//                                let storyTab = UIStoryboard(name: "Main", bundle: nil)
//                                let objTourGuideVC = storyTab.instantiateViewController(withIdentifier: "TourGuideVC") as! TourGuideVC
//                                self.navigationController?.pushViewController(objTourGuideVC, animated: true)
             
                                let data = NSKeyedArchiver.archivedData(withRootObject: dictemp)
                                UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                UserDefaults.standard.synchronize()
                                
                                UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                UserDefaults.standard.synchronize()
                                
                                let interst = InterestVC .initViewController()
                                self.navigationController?.navigationBar.isTranslucent  = false
                                self.navigationController?.pushViewController(interst, animated: true)
                            }
                        
                        }
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeyError]! as! String, inView: self)
                        }
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
        
        /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
         debugPrint(response)
         }*/

    }
    @IBAction func btnbackPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        if textField == self.txtFullName
        {
            self.txtEmail.becomeFirstResponder()
        }
        else if textField == self.txtEmail
        {
            self.txtUserName.becomeFirstResponder()
        }
        else if textField == self.txtUserName
        {
            self.txtPassword.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        return true
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
