//
//  ChannelListVC.swift
//  Bonfire
//
//  Created by Yash on 05/08/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ChannelListVC: UIViewController
{
    var groupDetail = NSMutableDictionary()
    @IBOutlet weak var tblviewListing: UITableView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    var channelArr = NSArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tblviewListing.estimatedRowHeight = 50;
        self.tblviewListing.rowHeight = UITableViewAutomaticDimension;
        // Do any additional setup after loading the view.
        
        showProgress(inView: self.view)
        self.callGetChannelWS()
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

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callGetChannelWS()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let userid = final .value(forKey: "userId")
        
        //        let url = kServerURL + kGetAllChannel
        
        let url = kServerURL + kGetChannelByGroupID
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        let param = [
            "group_id" : "\(groupDetail.object(forKey: "groupId")!)"
        ]
        
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
                        
                        self.channelArr = NSMutableArray()
                        
                        if (temp.value(forKey: "error") != nil)
                        {
                            self.lblNoDataFound.isHidden = false
                            self.tblviewListing.isHidden = true
                        }
                        else
                        {
                            self.lblNoDataFound.isHidden = true
                            self.tblviewListing.isHidden = false
                            
                            let dictemp = json as! NSArray
                            print("dictemp :> \(dictemp)")
                            let temp  = dictemp.firstObject as! NSDictionary
                            let data  = temp .value(forKey: "data") as! NSArray
                            
                            if data.count > 0
                            {
                                self.channelArr = data
                            }
                        }
                        
                        self.tblviewListing.reloadData()
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                hideProgress()
                
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
        
    }

    @IBAction func backBtnTap(_ sender: Any)
    {
        _ =  self.navigationController?.popViewController(animated: true)
    }

    //MARK: Add new Channel
    @IBAction func btnNewChannletap(_ sender: Any)
    {
        self .showPopUp()
    }
    
    func showPopUp()
    {
        let alertController = UIAlertController(title: "New Channel", message: "Please enter name:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            if let field = alertController.textFields?.first
            {
                self.callAddChannelWs(name: field.text!)
            }
            else
            {
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "New Channel"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func callAddChannelWs(name:String)
    {
        showProgress(inView: self.view)
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let userid = final .value(forKey: "userId")
        
        let url = kServerURL + kCreateNewChannel
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        
        let dictGroupCampus = groupDetail.object(forKey: "groupCampus") as! NSDictionary
        
        let param = ["name":name,"user_id":userid!,"campus_id":"\(dictGroupCampus.object(forKey: "campusId")!)","group_id":"\(groupDetail.object(forKey: "groupId")!)"]
        
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
                            hideProgress()
                            App_showAlert(withMessage: (temp .value(forKey: "message") as? String)!, inView: self)
                            self.callGetChannelWS()
                        }
                        else
                        {
                            hideProgress()
                            
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

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ChannelListVC : UITableViewDataSource , UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelListCell") as! ChannelListCell
        cell.lblChannelName.text = (self.channelArr.object(at: indexPath.row) as! NSDictionary) .value(forKey: "channelName") as? String
        
        cell.backgroundColor = UIColor .clear
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.channelArr.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        let dict = self.channelArr.object(at: indexPath.row) as! NSDictionary
        
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let alertView = UIAlertController(title: Application_Name, message: "Are you sure want to delete channel?", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Yes", style: .default)
            { (action) in
                
                // get all home feed api calling
                let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
                let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
                let url = kServerURL + kDeleteChannel
                showProgress(inView: self.view)
                let token = final .value(forKey: "userToken")
                let headers = ["Authorization":"Bearer \(token!)"]
                let param = [
                    "channel_id" :  "\(dict.value(forKey: "channelId")!)",
                    "group_id":  "\(dict.value(forKey: "groupId")!)"
                ]
                
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
                                
                                if (temp.value(forKey: "error") != nil)
                                {
                                    let msg = ((temp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                                    App_showAlert(withMessage: msg as! String, inView: self)
                                }
                                else
                                {
                                        App_showAlert(withMessage: "Channel Deleted Successfully", inView: self)
                                        self.callGetChannelWS()
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
            alertView.addAction(OKAction)
            
            let CancelAction = UIAlertAction(title: "No", style: .default)
            {
                (action) in
            }
            alertView.addAction(CancelAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }

}
class ChannelListCell: UITableViewCell
{
    @IBOutlet weak var lblChannelName: UILabel!
}
