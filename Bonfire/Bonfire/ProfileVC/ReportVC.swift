//
//  ReportVC.swift
//  Bonfire
//
//  Created by Yash on 19/08/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ReportVC: UIViewController
{
    @IBOutlet weak var txtvwReportText: UITextView!
    var strReportID = String()
    var bisFromFeed = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btnsendReport(_ sender: Any)
    {
        showProgress(inView: self.view)
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let userid = final .value(forKey: "userId")
        
        if bisFromFeed == true
        {
            let url = kServerURL + kReportFeed
            let token = final .value(forKey: "userToken")
            let headers = ["Authorization":"Bearer \(token!)"]
            
            let param = ["feed_id":strReportID,"description":txtvwReportText.text!]
            
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
                            let dictemp = json as! NSArray
                            print("dictemp :> \(dictemp)")
                            let temp  = dictemp.firstObject as! NSDictionary
                            // let data  = temp .value(forKey: "data") as! NSArray
                            
                            if temp.count > 0
                            {
                                let alertView = UIAlertController(title: Application_Name, message: (temp .value(forKey: "message") as? String)!, preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default)
                                { (action) in
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                                alertView.addAction(OKAction)
                                
                                self.present(alertView, animated: true, completion: nil)
                            }
                            else
                            {
                                App_showAlert(withMessage: (temp .value(forKey: "message") as? String)!, inView: self)
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
        }
        else
        {
            let url = kServerURL + kReportUser
            let token = final .value(forKey: "userToken")
            let headers = ["Authorization":"Bearer \(token!)"]
            
            let param = ["report_user_id":strReportID,"description":txtvwReportText.text!]
            
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
                            let dictemp = json as! NSArray
                            print("dictemp :> \(dictemp)")
                            let temp  = dictemp.firstObject as! NSDictionary
                            // let data  = temp .value(forKey: "data") as! NSArray
                            
                            if temp.count > 0
                            {
                                let alertView = UIAlertController(title: Application_Name, message: (temp .value(forKey: "message") as? String)!, preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default)
                                { (action) in
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                                alertView.addAction(OKAction)
                                
                                self.present(alertView, animated: true, completion: nil)
                            }
                            else
                            {
                                App_showAlert(withMessage: (temp .value(forKey: "message") as? String)!, inView: self)
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
        }
    }

    @IBAction func backBtnTap(_ sender: Any)
    {
        _ =  self.navigationController?.popViewController(animated: true)
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
