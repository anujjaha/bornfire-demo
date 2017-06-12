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
            self.view .endEditing(true)
            self.callLoginAPI()

        }
    }

    func callLoginAPI() {
        
            let url = kServerURL + kLogin
            let parameters: [String: Any] = ["username": self.txtUserName.text!, "password": self.txtPassword.text!]
            
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
                                    appDelegate.arrLoginData = dictemp
                                    let data = NSKeyedArchiver.archivedData(withRootObject: appDelegate.arrLoginData)
                                    UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                    
                                    UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                    UserDefaults.standard.synchronize()
                                    let storyTab = UIStoryboard(name: "Main", bundle: nil)
                                    let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
                                    self.navigationController?.pushViewController(tabbar, animated: true)
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
