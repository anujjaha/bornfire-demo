//
//  MessageGroupListVC.swift
//  Bonfire
//
//  Created by Hardik on 21/06/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class MessageGroupListVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var msgArr = NSArray()
    var selectedIndex = Int()
    var arrSelectedLeader = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.callProfileAPI()

    }
    // MARK: - API call
    func callProfileAPI()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        var userid = String()
        userid = "\(final.value(forKey: "userId")!)"
        
        let url = kServerURL + kUserprofile + String(describing: userid)
        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                        print("dictProfile :> \(dictemp)")
                        let temp  = dictemp.firstObject as! NSDictionary
                        let data  = temp .value(forKey: "data") as! NSDictionary
                        
                        if data.count > 0
                        {
                            if let err  =  data.value(forKey: kkeyError)
                            {
                                App_showAlert(withMessage: err as! String, inView: self)
                            }
                            else
                            {
                                print("no error")
                                if (data .value(forKey:"userGroups")) != nil
                                {
                                    self.msgArr = data .value(forKey:"userGroups") as! NSArray

                                    let namePredicate = NSPredicate(format: "%K = %d", "isLeader",1)
                                    self.msgArr = self.msgArr.filter { namePredicate.evaluate(with: $0) } as NSArray
                                }
                            }
                        }
                        else
                        {
                            App_showAlert(withMessage: data[kkeyError]! as! String, inView: self)
                        }
                    }
                }
                
                break
                
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
            
            self.tableview.dataSource = self
            self.tableview.delegate = self
            self.tableview .reloadData()
        }
    }

    @IBAction func btnBackTap(_ sender: Any)
    {
//        let grpname = self.msgArr[selectedIndex]
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateSelectedGroup"), object: grpname)
      _ =  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveTap(_ sender: Any)
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateSelectedGroup"), object: self.arrSelectedLeader)
        _ =  self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden  = true
        
    }
        
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    static func initViewController() -> MessageGroupListVC
    {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "MessageGroupListView") as! MessageGroupListVC
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MessageGroupListVC : UITableViewDataSource , UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let name = ((self.msgArr.object(at: indexPath.row) as! NSDictionary) .value(forKey: "groupName")) as! String
        cell?.textLabel?.text = name
        cell?.selectionStyle = .none
        
        let dic = self.msgArr.object(at: indexPath.row) as! NSDictionary
        if self.arrSelectedLeader.count > 0
        {
            if self.arrSelectedLeader.contains(dic.value(forKey: "groupId")!)
            {
                cell?.accessoryType = .checkmark
            }
            else
            {
                cell?.accessoryType = .none
            }
        }
        else
        {
            cell?.accessoryType = .none
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dic = self.msgArr.object(at: indexPath.row) as! NSDictionary
        self.arrSelectedLeader = NSMutableArray()
        if tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType == .checkmark
        {
        }
        else
        {
            
            if !self.arrSelectedLeader.contains(dic.value(forKey: "groupId")!)
            {
                self.arrSelectedLeader.add(dic.value(forKey: "groupId")!)
                tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
            }
            else
            {
                self.arrSelectedLeader.remove(dic.value(forKey: "groupId")!)
                tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        self.arrSelectedLeader = NSMutableArray()
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.msgArr.count
    }
}

