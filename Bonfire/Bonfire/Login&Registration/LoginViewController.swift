//
//  LoginViewController.swift
//  Bonfire
//
//  Created by Kevin on 17/04/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    @IBOutlet weak var backbtn: UIButton!

    @IBOutlet weak var txtUserName : UITextField!
    @IBOutlet weak var txtPassword : UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if appDelegate.bisUserLogout
        {
            self.backbtn.isHidden = true
        }
        else
        {
            self.backbtn.isHidden = false
        }
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

    func callLoginAPI()
    {
        
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
                        
                        if dictemp.count > 0
                        {
                            if let err  =  dictemp.value(forKey: kkeyError)
                            {
                                App_showAlert(withMessage: err as! String, inView: self)
                            }
                            else
                            {
                                appDelegate.arrLoginData = dictemp
                                let data = NSKeyedArchiver.archivedData(withRootObject: appDelegate.arrLoginData)
                                UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                
                                UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                UserDefaults.standard.synchronize()
                                
                                self.RegisterDeviceToken()
//                                let storyTab = UIStoryboard(name: "Main", bundle: nil)
//                                let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
//                                self.navigationController?.pushViewController(tabbar, animated: true)
//                                
//                                AppDelegate .shared.getAllcampusUser()
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
    
    func RegisterDeviceToken()
    {
        // get all home feed api calling
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + kkeySetDeviceToken
        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let param = ["device_token" :  "\(appDelegate.strDeviceToken)"]
        
        request(url, method: .post, parameters:param, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value!)
                    
                    if let json = response.result.value
                    {
                        
                        let storyTab = UIStoryboard(name: "Main", bundle: nil)
                        let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
                        self.navigationController?.pushViewController(tabbar, animated: true)
                        
                        AppDelegate .shared.getAllcampusUser()
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
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
