//
//  GroupEventDetailVC.swift
//  Bonfire
//
//  Created by Sanjay Makvana on 13/05/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class GroupEventDetailVC: UIViewController {

    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var profileCollectonview: UICollectionView!
    @IBOutlet weak var channelTblView: UITableView!
    @IBOutlet weak var tableEventDesc: UITableView!
    @IBOutlet weak var lblGrpName: UILabel!
    var channelArr = NSArray()
    var arrGrpEvent = NSArray()
    var groupDetails = NSDictionary()
    var grpname = String()
    
    var grpMember = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableEventDesc .dataSource = self
        self.tableEventDesc .reloadData()
        
//        tableEventDesc.separatorColor = UIColor .clear
//        tableEventDesc.separatorStyle = UITableViewCellSeparatorStyle.none
//        tableEventDesc.separatorInset = UIEdgeInsets.zero
        
        self.channelTblView .dataSource = self
        self.channelTblView .delegate = self
        self.channelTblView .reloadData()
        
        self.profileCollectonview.delegate = self
        self.profileCollectonview.dataSource = self
        
//        self.callGellChannelWS()
        // Do any additional setup after loading the view.
        self .getAllGrpEvents()
    }

    @IBAction func channelTap(_ sender: Any) {
            }
    
    @IBAction func backTap(_ sender: Any) {
//        _ = self.navigationController?.popViewController(animated: false)
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    @IBAction func buttonLeaveGrp(_ sender: Any)
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        var userid = String()
            userid = "\(final.value(forKey: "userId")!)"
        
        let url = kServerURL + kRemoveGroup
        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let param = [
            "group_id" :  "\(groupDetails.object(forKey: "groupId")!)",
            "user_id" : userid
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
                            let data  = temp .value(forKey: "data") as! NSDictionary
                            if data.count > 0
                            {
                                let msg = (data.value(forKey: "success"))
//                                App_showAlert(withMessage: msg as! String, inView: self)
                                
                                let alertView = UIAlertController(title: Application_Name, message: msg as! String, preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default)
                                { (action) in
                                    
                                    _ = self.navigationController?.popToRootViewController(animated: true)
                                }
                                alertView.addAction(OKAction)
                                
                                self.present(alertView, animated: true, completion: nil)

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

//        _ = self.navigationController?.popViewController(animated: false)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        self.lblGrpName.text = self.grpname
        
        self.lblMember.text = ""
        self.lblMember.text = String(self.grpMember.count) + " members"
    
        self.profileCollectonview .reloadData()
    }
    override  func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    static func initViewController() -> GroupEventDetailVC
    {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "GroupEventDetailView") as! GroupEventDetailVC
    }
    
    func getAllGrpEvents()
    {
        // get all home feed api calling
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetGrpEvents
        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let param = ["group_id" :  "\(groupDetails.object(forKey: "groupId")!)"]
        
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
                        }
                        else
                        {
                            let data  = temp .value(forKey: "data") as! NSArray
                            
                            if data.count > 0
                            {
                                print(data)
                                self.arrGrpEvent = data
                                self.tableEventDesc .reloadData()
                            }
                            else
                            {
                                //                            App_showAlert(withMessage: data[kkeyError]! as! String, inView: self)
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
}

extension GroupEventDetailVC : UITableViewDataSource , UITableViewDelegate{
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.channelTblView {
            var isShowHeader = false
            if indexPath.row == 0 {
                isShowHeader = true
                
            }else{
                isShowHeader = false
            }
            
            
            let chanelName = (self.channelArr .object(at: indexPath.row) as! NSDictionary) .value(forKey: "channelName") as? String
            let chanelId = (self.channelArr .object(at: indexPath.row) as! NSDictionary) .value(forKey: "channelId") 
            
            let dict = [ "isShowHeader" : chanelName,"channelId" :chanelId]
            let notificationName = Notification.Name("updateTopHeader")
            NotificationCenter.default.post(name: notificationName, object: dict)
            _ = self.navigationController?.popViewController(animated: false)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.channelTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GroupEventDetailCell
            cell.channelName.text = (self.channelArr .object(at: indexPath.row) as! NSDictionary) .value(forKey: "channelName") as? String
            
            if indexPath.row == 0
            {
                cell.downiconImage.isHidden = false
                cell.channelBadgeNo.isHidden = true
            } else
            {
                if indexPath.row == 1
                {
//                    cell.channelBadgeNo .setTitle("11", for: .normal)
                cell.channelBadgeNo.backgroundColor = UIColor.clear
//                    cell.channelBadgeNo.backgroundColor = UIColor .init(colorLiteralRed: 255.0/255.0, green: 0.0/255.0, blue: 103.0/255.0, alpha: 1.0)
                    
                } else {
                    cell.channelBadgeNo .setTitle("", for: .normal)
                    cell.channelBadgeNo.backgroundColor = UIColor .clear
                }
                
                
                cell.channelBadgeNo.layer.cornerRadius = cell.channelBadgeNo.frame.height/2;
                cell.channelBadgeNo.isHidden = false
                cell.downiconImage.isHidden = true
            }
            
            cell.backgroundColor = UIColor .clear
            cell.channelBadgeNo .setTitleColor(UIColor.white, for: .normal)
            cell.selectionStyle = .none
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupEventDetailCell") as! grpEventCell
            let dict = self.arrGrpEvent .object(at: indexPath.row) as! NSDictionary
            cell.lblDescription.text = dict .value(forKey: "eventName") as! String?
            cell.lblMonName.text = dict .value(forKey: "eventMonth") as! String?
            cell.lblDayName.text = dict .value(forKey: "eventDate") as! String?
            cell.lblEventTitle.text = dict .value(forKey: "eventTitle") as! String?
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.channelTblView {
            return self.channelArr.count
        } else {
            return self.arrGrpEvent.count
        }
    }
}
extension GroupEventDetailVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.grpMember.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "profileCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! profileCollectonviewCell
        
        let dic = self.grpMember .object(at: indexPath.row) as! NSDictionary
        cell.imgView .sd_setImage(with: URL(string:dic .value(forKey: "profile_picture") as! String), placeholderImage: nil)

        cell.imgView.layer.cornerRadius = 20.0
        cell.imgView.layoutIfNeeded() //This is important line
        //cell.imgView.layer.masksToBounds = true
        cell.imgView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let flowLayout = (collectionViewLayout as! UICollectionViewFlowLayout)
        let cellSpacing = flowLayout.minimumInteritemSpacing
        let cellWidth = flowLayout.itemSize.width
        let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
        
        let collectionViewWidth = collectionView.bounds.size.width
        
        let totalCellWidth = cellCount * cellWidth
        let totalCellSpacing = cellSpacing * (cellCount - 1)
        
        let totalCellsWidth = totalCellWidth + totalCellSpacing
        
        let edgeInsets = (collectionViewWidth - totalCellsWidth) / 2.0
        
        return edgeInsets > 0 ? UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets) : UIEdgeInsetsMake(0, cellSpacing, 0, cellSpacing)
    }
}


class grpEventCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDayName: UILabel!
    @IBOutlet weak var lblMonName: UILabel!
    @IBOutlet weak var lblEventTitle : UILabel!
}
