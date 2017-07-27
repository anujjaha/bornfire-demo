//
//  GroupVC.swift
//  Bonfire
//
//  Created by IOS User on 12/05/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class GroupVC: UIViewController {

    @IBOutlet weak var blGrpMember: UILabel!
    @IBOutlet weak var lblGrpName: UILabel!
    @IBOutlet weak var lblChannel: UILabel!
    
    @IBOutlet weak var const_topview_height: NSLayoutConstraint!
    var isFromLeadingGrp = false
    var grpDetail = NSDictionary()
    var grpMemeber = NSArray()
    
     var channelArr = NSArray()
     var arrChannelFeed = NSArray()
    
    @IBOutlet weak var dropDownIcon: UIImageView!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet weak var txtAnythingTosay: UITextField!
    @IBOutlet var profileCollectonview: UICollectionView!
    
    @IBOutlet weak var tblviewListing: UITableView!
    
    var tableData :NSMutableArray  = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum is simply dummy text of the printing ","Lorem Ipsum is simply dummy text of the printing  Lorem Ipsum is simply dummy text of the printing and typesetting industry","Lorem Ipsum is simply dummy text of the printing  Lorem Ipsum is simply dummy text of the printing"]
    
    static func initViewController() -> GroupVC {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "GroupView") as! GroupVC
    }
    
    @IBAction func channelBtnTap(_ sender: Any) {
        
        let groupEventObj  = GroupEventDetailVC .initViewController()
        groupEventObj.channelArr = self.channelArr
        self.navigationController?.pushViewController(groupEventObj, animated: false)
    }
   
    
   
    @IBAction func profileButtonTap(_ sender: Any) {
        print("tap")
    }
    @IBAction func backBtnTap(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtnTap(_ sender: Any) {
        
        let createGrpObj = SettingVC.initViewController()
        createGrpObj.grpDetail = grpDetail
        self.navigationController?.pushViewController(createGrpObj, animated: true)
    }
    
    func updateHeader (notification : NSNotification) {

        let dict =  notification .value(forKey: "object") as! NSDictionary
        let selectedChannel =   dict .value(forKey: "isShowHeader")
        let selectedChannelID =   dict .value(forKey: "channelId") as! Int
        
        
        self.lblChannel.text = selectedChannel as? String

        self .getAllChannelfeed(channelId: selectedChannelID)
//      let isShow =   dict .value(forKey: "isShowHeader") as! Bool
//        
//        if isShow {
//            self.const_topview_height.constant  = 130
//        } else {
//            self.const_topview_height.constant  = 0
//        }
    }
    
    @IBAction func plusBtnTap(_ sender: Any) {
        self.callApiToCreateNewChannelFeed()
    }
    
    
    
    func callApiToCreateNewChannelFeed() {
        
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let intid:[String] = ["1"]
        
        let grpId = self.grpDetail .value(forKey: "groupId") as! Int
        let param:[String:Any] = ["is_campus_feed" : "0","group_id" : grpId ,"channel_id" : "1","description":"this is from appside","interests": intid]
        
        
        let url = kServerURL + kCreateNewFeed
        
        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .post, parameters:param, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil {
                    print(response.result.value!)
                    
                    if let json = response.result.value {
                        
                    }
                    else {
                        
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
    
    
    
    func getAllChannelfeed(channelId:Int) {
        
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        
        let param:[String:Any] = ["channel_id" : channelId]
        
        
        let url = kServerURL + kGetAllChannelFeed
        
        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .post, parameters:param, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil {
                    print(response.result.value!)
                    
                    if let json = response.result.value {
                        let dictemp = json as! NSArray
                        print("dictemp :> \(dictemp)")
                        let temp  = dictemp.firstObject as! NSDictionary
                        
                        if (temp.value(forKey: "error") != nil) {
                            
                            let msg = ((temp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            
                            App_showAlert(withMessage: msg as! String, inView: self)
                            
                        } else {
                            let data  = temp .value(forKey: "data") as! NSArray
                            
                            if data.count > 0 {
                                print(data)
                                self.arrChannelFeed = data as NSArray
                                
                                self.tblviewListing.dataSource = self
                                self.tblviewListing.delegate = self
                                self.tblviewListing.reloadData()
                            }
                            else
                            {
                                //                            App_showAlert(withMessage: data[kkeyError]! as! String, inView: self)
                            }
                        }
                        
                    }
                    else {
                        
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
    
    
    
    func callGellChannelWS() {
        
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let userid = final .value(forKey: "userId")
        
        let url = kServerURL + kGetAllChannel
        
        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil {
                    print(response.result.value!)
                    
                    if let json = response.result.value {
                        let dictemp = json as! NSArray
                        print("dictemp :> \(dictemp)")
                        let temp  = dictemp.firstObject as! NSDictionary
                        let data  = temp .value(forKey: "data") as! NSArray
                        
                        if data.count > 0 {
                            self.channelArr = data
                            self.lblChannel.text = (self.channelArr.firstObject as! NSDictionary) .value(forKey: "channelName") as? String
                        }
                        else
                        {
                            //App_showAlert(withMessage: data[kkeyError]! as! String, inView: self)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.txtAnythingTosay.delegate = self
        self.txtAnythingTosay .setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        
       
        self.tblviewListing.rowHeight = UITableViewAutomaticDimension
        self.tblviewListing.estimatedRowHeight = 88.0
        
        
        // Do any additional setup after loading the view.
        
        self.tblviewListing.estimatedRowHeight = 80;
        self.tblviewListing.rowHeight = UITableViewAutomaticDimension;
        
        
        self.callGellChannelWS()
        self.getAllChannelfeed(channelId: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblGrpName.text = self.grpDetail .value(forKey: "groupName") as?    String
        
         grpMemeber = self.grpDetail .value(forKey: "group_members") as! NSArray
        self.blGrpMember.text = String(grpMemeber.count) + " members"
        
        self.profileCollectonview.dataSource = self
        self.profileCollectonview.delegate = self
        self.profileCollectonview.reloadData()
        
        
        let notificationName = Notification.Name("updateTopHeader")
        //        // Stop listening notification
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeader), name: notificationName, object: nil)
        
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        
        if self.isFromLeadingGrp {
            self.menuButton.isHidden = true
            self.dropDownIcon.isHidden = true
        } else {
            self.menuButton.isHidden = false
            self.dropDownIcon.isHidden = false
            
        }
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension GroupVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return grpMemeber.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "profileCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! profileCollectonviewCell
        
        let dic = self.grpMemeber .object(at: indexPath.row) as! NSDictionary
        
        
        cell.imgView .sd_setImage(with: URL(string:dic .value(forKey: "profile_picture") as! String), placeholderImage: nil)
        cell.imgView.layer.cornerRadius = 11.0;
        cell.imgView.layoutIfNeeded() //This is important line
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

extension GroupVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate method
  
        self.txtAnythingTosay .placeholder = nil
        //IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        //IQKeyboardManager.sharedManager().enableAutoToolbar = true
        if (textField.text?.characters.count)! > 0 {
            tableData .add(textField.text) 
            self.tblviewListing .reloadData()
        }
        
        textField.text = nil
        self.txtAnythingTosay .placeholder = "Anything to say?"
        self.view .layoutIfNeeded()
        self.view .layoutSubviews()
        self.tblviewListing .layoutIfNeeded()
    }
}
extension GroupVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GroupCell
        cell.imgView.backgroundColor = UIColor.gray
//        cell.lblDetail?.text = tableData[indexPath.row] as? String
//        cell.lblName.text = "Ryan"
        
        if indexPath.row == 1 {
            cell.Const_LinkBtn_height.constant = 10
            cell.btnLink.isHidden = false
        }else {
           // cell.Const_LinkBtn_height.constant = 0
            cell.btnLink.isHidden = true
        }
        
        let dict = self.arrChannelFeed[indexPath.row] as! NSDictionary
        
        cell.lblDetail.text = dict .value(forKey: "description") as! String?
        
        let feeddict = dict  .value(forKey: "feedCreator") as? NSDictionary
        cell.lblName.text = feeddict? .value(forKey: "name") as? String
        
        
        let profileurl = feeddict? .value(forKey: "profile_picture") as? String
        cell.imgView .sd_setImage(with: URL(string: (profileurl)!), placeholderImage: nil)
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrChannelFeed.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    func  tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "MAR 10"
    }
     func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (view is UITableViewHeaderFooterView) {
            let tableViewHeaderFooterView: UITableViewHeaderFooterView? = (view as? UITableViewHeaderFooterView)
            tableViewHeaderFooterView?.textLabel?.textAlignment = .center
            tableViewHeaderFooterView?.backgroundColor = UIColor .clear
        }
    }
}
