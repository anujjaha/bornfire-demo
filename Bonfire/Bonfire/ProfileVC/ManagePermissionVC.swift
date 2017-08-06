//
//  ManagePermissionVC.swift
//  Bonfire
//
//  Created by Yash on 06/08/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ManagePermissionVC: UIViewController
{
    var arrLeader = NSMutableArray()
    var arrSelectedLeader = NSMutableArray()
    @IBOutlet weak var tabelview: UITableView!
    var strGroupID = String()
    var dicGroupDetail = NSDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let namePredicate = NSPredicate(format: "%K = %d", "isMember",1)
        let temp = (self.dicGroupDetail.value(forKey: "group_members") as! NSArray).filter { namePredicate.evaluate(with: $0) } as! NSMutableArray
        if (temp.count > 0)
        {
            for i in 0..<temp.count
            {
                let dic = temp[i] as! NSDictionary
//                self.arrSelectedLeader.add(dic.value(forKey: "userId")!)
                arrLeader.add(dic)
            }
        }
        
        let namePredicate1 = NSPredicate(format: "%K = %d", "memberStatus",1)
        let tempmemberStatus = (self.dicGroupDetail.value(forKey: "group_members") as! NSArray).filter { namePredicate1.evaluate(with: $0) } as! NSMutableArray
        if (tempmemberStatus.count > 0)
        {
            for i in 0..<tempmemberStatus.count
            {
                let dic = tempmemberStatus[i] as! NSDictionary
                self.arrSelectedLeader.add(dic.value(forKey: "userId")!)
            }
        }

        
        self.tabelview .reloadData()

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

    
    @IBAction func backBtnTap(_ sender: Any) {
        _ =  self.navigationController?.popViewController(animated: true)
    }

    @IBAction func saveTap(_ sender: Any)
    {
        let url = kServerURL + kManagePermission
        showProgress(inView: self.view)
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        let arrid = self.arrSelectedLeader as NSArray
        let strint = self.arrSelectedLeader.componentsJoined(by: ",")

        var param = [String : Any]()
        param = ["group_id" : strGroupID ,"user_id" : strint]         
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
                        print("dictempkAddMemberAPI :> \(dictemp)")
                        let temp  = dictemp[0] as! NSDictionary
                        
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
                                let tempobject = NSMutableDictionary(dictionary: data)
                                NotificationCenter .default.post(name: NSNotification.Name(rawValue: "updateGroupDetails"), object: tempobject, userInfo: nil)
                                _ =  self.navigationController?.popViewController(animated: true)
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

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
extension ManagePermissionVC :UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        let dic = self.arrLeader[indexPath.row] as! NSDictionary
        
        if self.arrSelectedLeader.count > 0
        {
            if self.arrSelectedLeader.contains(dic.value(forKey: "userId")!)
            {
                cell.accessoryType = .checkmark
            }
            else
            {
                cell.accessoryType = .none
            }
        }
        cell.textLabel?.text = dic["name"] as? String
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dic = self.arrLeader[indexPath.row] as! NSDictionary
        
        if !self.arrSelectedLeader.contains(dic.value(forKey: "userId")!)
        {
            self.arrSelectedLeader.add(dic.value(forKey: "userId")!)
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        }
        else
        {
            self.arrSelectedLeader.remove(dic.value(forKey: "userId")!)
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let dic = self.arrLeader[indexPath.row] as! NSDictionary
        self.arrSelectedLeader.remove(dic.value(forKey: "userId")!)
        
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrLeader.count
    }
    
}
