//
//  JoingGroupVC.swift
//  Bonfire
//
//  Created by Kevin on 01/08/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class JoingGroupVC: UIViewController {

    var dicGroupDetail = NSDictionary()
    @IBOutlet weak var imageViewCoverPhoto: UIImageView!
    @IBOutlet weak var lblGroupTitle: UILabel!
    @IBOutlet weak var lblGroupDescription: UILabel!
    @IBOutlet weak var btnJoinGroup : UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let strurl = dicGroupDetail["groupImage"] as! String
        let url  = URL.init(string: strurl)
        imageViewCoverPhoto.sd_setImage(with: url, placeholderImage: nil)
        
        lblGroupTitle.text = dicGroupDetail["groupName"] as? String
        lblGroupDescription.text = dicGroupDetail["groupDescription"] as? String
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true

        if dicGroupDetail.object(forKey: kkeyisPrivate) as! Int == 0
        {
//            btnJoinGroup.setTitle("Join +", for: .normal)
//            let myNormalAttributedTitle = NSAttributedString(string: "Join +",
//                                                             attributes: [NSForegroundColorAttributeName : UIColor.black])
//            btnJoinGroup.setAttributedTitle(myNormalAttributedTitle, for: .normal)

            btnJoinGroup.setImage(UIImage(named: "icon_join"), for: .normal)
            btnJoinGroup.backgroundColor = UIColor.clear
        }
        else
        {
//            btnJoinGroup.setTitle("Request +", for: .normal)
            let myNormalAttributedTitle = NSAttributedString(string: "Request +",
                                                             attributes: [NSForegroundColorAttributeName : UIColor.black])
            btnJoinGroup.setAttributedTitle(myNormalAttributedTitle, for: .normal)
            btnJoinGroup.backgroundColor = UIColor(red: 232.0/255.0, green: 223.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            btnJoinGroup.setImage(UIImage(named: ""), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        UIApplication.shared.isStatusBarHidden = false
    }

    @IBAction func btnJoinGroupAction(_ sender: Any)
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]

        let url = kServerURL + "groups/add-member"

        let userid = "\(final.value(forKey: "userId")!)"

        let parameters = [
            "group_id":  "\(dicGroupDetail.object(forKey: "groupId")!)",
            "user_id": userid
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request(url, method: .post, parameters:parameters, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                        
                        if (temp.value(forKey: "error") != nil)
                        {
                            let msg = ((temp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            let data  = temp .value(forKey: "data") as! NSDictionary
                            
                            if data.count > 0
                            {
                                if let err  =  data.value(forKey: kkeyError)
                                {
                                    App_showAlert(withMessage: err as! String, inView: self)
                                }
                                else
                                {
                                    if self.dicGroupDetail.object(forKey: kkeyisPrivate) as! Int == 0
                                    {
                                        appDelegate.bcalltoRefreshChannel = true
                                        let grpVcOBj = GroupVC.initViewController()
                                        grpVcOBj.grpDetail = NSMutableDictionary(dictionary: self.dicGroupDetail)
                                        grpVcOBj.isFromLeadingGrp = false
                                        self.navigationController?.pushViewController(grpVcOBj, animated: true)
                                    }
                                    else
                                    {
                                        _ = self.navigationController?.popViewController(animated: true)

                                    }
                                }
                            }
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
    
    @IBAction func backBtnTap(_ sender: Any)
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
