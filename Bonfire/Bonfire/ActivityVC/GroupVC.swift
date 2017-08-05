//
//  GroupVC.swift
//  Bonfire
//
//  Created by IOS User on 12/05/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class GroupVC: UIViewController {

    @IBOutlet weak var blGrpMember: UILabel!
    @IBOutlet weak var lblGrpName: UILabel!
    @IBOutlet weak var lblChannel: UILabel!
    
    @IBOutlet weak var btnImage: UIButton!
    var selectedChannelID = Int()
    
    var picker:UIImagePickerController?=UIImagePickerController()
    
    var imagview = UIImageView()
    
    @IBOutlet weak var const_topview_height: NSLayoutConstraint!
    var isFromLeadingGrp = false
    var grpDetail = NSDictionary()
    var grpMemeber = NSArray()
    
     var channelArr = NSArray()
     var arrChannelFeed = NSArray()
    var arrInterestForMessage = NSArray()

    @IBOutlet weak var dropDownIcon: UIImageView!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet weak var txtAnythingTosay: UITextField!
    @IBOutlet var profileCollectonview: UICollectionView!
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var vwFooterView: UIView!
    @IBOutlet weak var const_vwFooterView_height: NSLayoutConstraint!

    
    @IBOutlet weak var tblviewListing: UITableView!
    var isInterestTap = false
    
    

    
    var tableData :NSMutableArray  = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum is simply dummy text of the printing ","Lorem Ipsum is simply dummy text of the printing  Lorem Ipsum is simply dummy text of the printing and typesetting industry","Lorem Ipsum is simply dummy text of the printing  Lorem Ipsum is simply dummy text of the printing"]

    //MARK: Channel Feed Posting
    @IBAction func upArrowTap(_ sender: Any)
    {
        if !(self.txtAnythingTosay.text?.isEmpty)! && selectedChannelID != 0
        {
            self.callApiToCreateNewChannelFeed()
        }
        else
        {
            App_showAlert(withMessage: "Please enter message to post feed", inView: self)
        }
    }
    
    static func initViewController() -> GroupVC
    {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "GroupView") as! GroupVC
    }
    
    @IBAction func BtnimageTap(_ sender: Any)
    {
        self .openActionsheet()
    }
    
    //MARK: Go to Channel Listing
    @IBAction func channelBtnTap(_ sender: Any)
    {
        let groupEventObj  = GroupEventDetailVC .initViewController()
        groupEventObj.grpname = self.lblGrpName.text!
        groupEventObj.grpMember = self.grpMemeber
        groupEventObj.channelArr = self.channelArr
        groupEventObj.groupDetails = grpDetail
        
        self.navigationController?.pushViewController(groupEventObj, animated: false)
    }
   
    
   
    @IBAction func profileButtonTap(_ sender: Any) {
        print("tap")
    }
    @IBAction func backBtnTap(_ sender: Any) {
//        _ = self.navigationController?.popViewController(animated: true)

        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func menuBtnTap(_ sender: Any) {
        
        let createGrpObj = SettingVC.initViewController()
        createGrpObj.grpDetail = NSMutableDictionary(dictionary: grpDetail)
        self.navigationController?.pushViewController(createGrpObj, animated: true)
    }
    
    //MARK: Channel Refresh
    func updateHeader (notification : NSNotification)
    {
        let dict =  notification .value(forKey: "object") as! NSDictionary
        let selectedChannel =   dict .value(forKey: "isShowHeader")
        selectedChannelID =   dict .value(forKey: "channelId") as! Int
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
    
    @IBAction func plusBtnTap(_ sender: Any)
    {
        isInterestTap = true
        let viewController = AddInterestToMessageVC .initViewController()
        viewController.isfromChannel = true
        self .navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    func openActionsheet()
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self .openGallary()
        })
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self .openCamera()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func callApiToCreateNewChannelFeed()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let grpId = self.grpDetail .value(forKey: "groupId") as! Int
        
//        let strint = self.arrInterestForMessage.componentsJoined(by: ",")

//        let param = ["is_campus_feed" : "0","group_id" : String(grpId) ,"channel_id" : String(selectedChannelID),"description":self.txtAnythingTosay.text!,"interests": strint]
        
        let param = ["is_campus_feed" : "0","group_id" : String(grpId) ,"channel_id" : String(selectedChannelID),"description":self.txtAnythingTosay.text!]
        let url = kServerURL + kCreateNewFeed
        
        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
//        UIImageJPEGRepresentation(imagview.image!, 1.0)
//        if imagview.image != nil {
//            let imgData = UIImagePNGRepresentation(imagview.image!)
//        }
        
        
        upload(multipartFormData:{ multipartFormData in
            
            for (key, value) in param {
                multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
            }
            
            if self.imagview.image != nil
            {
                //                let imgData = UIImagePNGRepresentation(self.imagview.image!)
                let imgData = UIImageJPEGRepresentation(self.imagview.image!, 0.5)
                if (imgData != nil)
                {
                    multipartFormData.append((imgData)!, withName: "attachment", fileName: "test.jpg", mimeType: "image/jpeg")
                }
            }
            
        } ,usingThreshold:UInt64.init(),
         to:url,
         method:.post,
         headers:headers,
         
         encodingCompletion: { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload .responseJSON(completionHandler: { (response) in
                    hideProgress()
                    debugPrint(response)
//                    self .getAllChannelfeed(channelId: self.selectedChannelID)
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSArray
                        print("dictemp :> \(dictemp)")
                        let temp  = dictemp.firstObject as! NSDictionary
                        let data  = temp .value(forKey: "data") as! NSDictionary
                        if data.count > 0
                        {
                            self.txtAnythingTosay.text = ""
                            self.imagview.image = UIImage(named : "")
                            self.arrInterestForMessage = NSArray()
                            self .getAllChannelfeed(channelId: self.selectedChannelID)
                        }
                    }
                })
                
            case .failure(let encodingError):
                hideProgress()
                print(encodingError)
            }
        })
        
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
            self.txtAnythingTosay.placeholder = "Anythig to say?"
            
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil {
                    print(response.result.value!)
                    
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSArray
                        print("dictemp Channelfeed :> \(dictemp)")
                        let temp  = dictemp.firstObject as! NSDictionary
                        
                        if (temp.value(forKey: "error") != nil)
                        {
                            let msg = ((temp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            let data  = temp .value(forKey: "data") as! NSArray
                            if data.count > 0
                            {
                                print(data)
                                self.arrChannelFeed = data as NSArray
                                print("self.arrChannelFeed :> \(self.arrChannelFeed)")

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
                    else
                    {
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
    func callGellChannelWS()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let userid = final .value(forKey: "userId")
        
//        let url = kServerURL + kGetAllChannel

        let url = kServerURL + kGetChannelByGroupID

        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        let param = [
            "group_id" : "\(grpDetail.object(forKey: "groupId")!)"
        ]
        
        request(url, method: .post, parameters:param, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
//                            let msg = ((temp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
//                            App_showAlert(withMessage: msg as! String, inView: self)
                            self.lblNoDataFound.isHidden = false
                            self.tblviewListing.isHidden = true
                            self.vwFooterView.isHidden = true
                        }
                        else
                        {
                            self.lblNoDataFound.isHidden = true
                            self.tblviewListing.isHidden = false
                            self.vwFooterView.isHidden = false
                            
                            let dictemp = json as! NSArray
                            print("dictemp :> \(dictemp)")
                            let temp  = dictemp.firstObject as! NSDictionary
                            let data  = temp .value(forKey: "data") as! NSArray
                            
                            if data.count > 0 {
                                self.channelArr = data
                                self.lblChannel.text = (self.channelArr.firstObject as! NSDictionary) .value(forKey: "channelName") as? String
                                
                                if let channel = (self.channelArr.firstObject)
                                {
                                    self.selectedChannelID =  (self.channelArr.firstObject as! NSDictionary) .   value(forKey: "channelId") as! Int
                                    self.getAllChannelfeed(channelId: self.selectedChannelID)
                                }
                            }
                            else
                            {
                                //App_showAlert(withMessage: data[kkeyError]! as! String, inView: self)
                            }
                        }
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
    
    //MARK: View Lif Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.txtAnythingTosay.delegate = self
//        self.txtAnythingTosay .setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        
        picker?.delegate=self
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "selectedInterestforChannel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectedInterestForChannel(notification:)), name:Notification.Name(rawValue: "selectedInterestforChannel"), object: nil)


        // Do any additional setup after loading the view.
        self.tblviewListing.estimatedRowHeight = 94;
        self.tblviewListing.rowHeight = UITableViewAutomaticDimension;
        
    }
    
    func selectedInterestForChannel(notification:Notification)
    {
        let str =  notification.object
        arrInterestForMessage = NSArray(array: str as! NSArray)
        print(str!)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.lblGrpName.text = self.grpDetail .value(forKey: "groupName") as? String
        
        self.blGrpMember.text = ""
        if let member = self.grpDetail .value(forKey: "group_members")
        {
            grpMemeber = self.grpDetail .value(forKey: "group_members") as! NSArray
            self.blGrpMember.text = String(grpMemeber.count) + " members"
        }
        
        self.profileCollectonview.dataSource = self
        self.profileCollectonview.delegate = self
        self.profileCollectonview.reloadData()
        
        
        let notificationName = Notification.Name("updateTopHeader")
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeader), name: notificationName, object: nil)
        
        self.navigationController?.navigationBar.isHidden = true
        
        if self.isFromLeadingGrp
        {
            self.menuButton.isHidden = false
           // self.dropDownIcon.isHidden = false
            self.const_vwFooterView_height.constant = 40
        }
        else
        {
            if grpDetail.object(forKey: kkeyisLeader) as! Int == 1
            {
                self.menuButton.isHidden = false
                self.const_vwFooterView_height.constant = 40
            }
            else
            {
                self.menuButton.isHidden = true
                self.const_vwFooterView_height.constant = 0
            }
        }
        self.dropDownIcon.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true
        
        if (appDelegate.bcalltoRefreshChannel == true)
        {
            appDelegate.bcalltoRefreshChannel = false
            showProgress(inView: self.view)
            self.callGellChannelWS()
        }
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        if(isInterestTap)
        {
            isInterestTap = false
        }
        else
        {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    //MARK: Share Image
    @IBAction func shareTextButton(_ sender: Any, event: Any)
    {
        let touches = (event as AnyObject).allTouches!
        let touch = touches?.first!
        let currentTouchPosition = touch?.location(in: self.tblviewListing)
        var indexPath = self.tblviewListing.indexPathForRow(at: currentTouchPosition!)!

        let dataarray = ((self.arrChannelFeed[indexPath.section] as AnyObject).object(forKey: "values") as! NSArray)
        let dict = dataarray[indexPath.row] as! NSDictionary

        // text to share
        let text = "\(dict.object(forKey: kkeyattachment_link)!)"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension GroupVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
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
        cell.imgView.layer.cornerRadius = 20.0;
        cell.imgView.layoutIfNeeded() //This is important line
        cell.imgView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dic = self.grpMemeber.object(at: indexPath.row) as! NSDictionary
        print("memebers dict -> \(dic)")
        
        appDelegate.bisUserProfile = false
        let objProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        objProfileVC.strotheruserID = "\(dic.value(forKey: "userId")!)"
        self.navigationController?.pushViewController(objProfileVC, animated: true)
    }

}

extension GroupVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate method
  
//        self.txtAnythingTosay .placeholder = nil
        //IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //IQKeyboardManager.sharedManager().enableAutoToolbar = true
        if (textField.text?.characters.count)! > 0
        {
//            tableData .add(textField.text) 
//            self.tblviewListing .reloadData()
        }
        
//        textField.text = nil
//        self.txtAnythingTosay .placeholder = "Anything to say?"
        self.view .layoutIfNeeded()
        self.view .layoutSubviews()
        self.tblviewListing .layoutIfNeeded()
    }
}
extension GroupVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GroupCell
        cell.imgView.backgroundColor = UIColor.gray
        
        let dataarray = ((self.arrChannelFeed[indexPath.section] as AnyObject).object(forKey: "values") as! NSArray)
        let dict = dataarray[indexPath.row] as! NSDictionary
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let dateinstr = dict .value(forKey: "createdAt")
        let date = formatter .date(from: dateinstr! as! String)
        
        let formatternew = DateFormatter()
        formatternew.dateFormat = "hh:mm"
        let time = formatternew .string(from: date!)
        
        cell.lblTime.text = time
        
        cell.lblDetail.text = dict .value(forKey: "description") as! String?
        
        let feeddict = dict  .value(forKey: "feedCreator") as? NSDictionary
        cell.lblName.text = feeddict? .value(forKey: "name") as? String
        
        let profileurl = feeddict? .value(forKey: "profile_picture") as? String
        cell.imgView .sd_setImage(with: URL(string: (profileurl)!), placeholderImage: nil)
        
        
        if dict.object(forKey: kkeyis_attachment) as! Int == 1
        {
            cell.Const_LinkBtn_height.constant = 27
            cell.btnLink.setTitle(dict .value(forKey: "attachmentName") as! String?, for: .normal)
            cell.btnLink.isHidden = false
        }
        else
        {
            cell.Const_LinkBtn_height.constant = 0
            cell.btnLink.isHidden = true
        }
        cell.btnLink.tag = indexPath.row
        cell.btnLink.addTarget(self, action: #selector(GroupVC.shareTextButton(_:event:)), for: .touchUpInside)

        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ((self.arrChannelFeed[section] as AnyObject).object(forKey: "values") as! NSArray).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.arrChannelFeed.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.0
    }
    func  tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "\((self.arrChannelFeed[section] as AnyObject).object(forKey: "dataMonthKey")!)"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        if (view is UITableViewHeaderFooterView)
        {
            let tableViewHeaderFooterView: UITableViewHeaderFooterView? = (view as? UITableViewHeaderFooterView)
            tableViewHeaderFooterView?.textLabel?.textAlignment = .center
            tableViewHeaderFooterView?.backgroundColor = UIColor .clear
        }
    }
}

extension GroupVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imagview.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
}
