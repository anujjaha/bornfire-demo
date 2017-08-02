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

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func btnJoinGroupAction(_ sender: Any)
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]

        let url = kServerURL + "groups/add-member"
        let parameters = [
            "group_id":  "\(dicGroupDetail.object(forKey: "groupId")!)"
        ]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request(url, method: .post, parameters:parameters, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil {
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
                                    let grpVcOBj = GroupVC.initViewController()
                                    grpVcOBj.grpDetail = self.dicGroupDetail
                                    grpVcOBj.isFromLeadingGrp = false
                                    self.navigationController?.pushViewController(grpVcOBj, animated: true)
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
