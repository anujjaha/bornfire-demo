//
//  ProfileVC.swift
//  Bonfire
//
//  Created by Kevin on 30/04/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController
{
    var arrInterest = NSArray()
    var arrGrp = NSArray()
    var strotheruserID = String()
    @IBOutlet weak var btnAddInterest: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnReportUser: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnTermsConditions: UIButton!
    @IBOutlet weak var btnBack: UIButton!

    let tagViewInterest_data = NSMutableArray()
    var picker:UIImagePickerController?=UIImagePickerController()

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImgview: UIImageView!
    @IBOutlet weak var cloudView: CloudTagView!
    @IBOutlet weak var cloudGroupTagView: CloudTagView!
    @IBOutlet weak var cosnt_scrlvMain_height: NSLayoutConstraint!
    @IBOutlet weak var cosnt_cloudViewInterest_height: NSLayoutConstraint!
    @IBOutlet weak var cosnt_cloudGroup_height: NSLayoutConstraint!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        picker?.delegate=self
        
        cloudView.delegate = self
        cloudGroupTagView.delegate = self
    }

    func profileImgSetup()
    {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 35)
        let img = UIImage(named: "Daybar")
        button.setImage(img, for: .normal)
        button.setImage(img, for: .highlighted)
        
        
        button.addTarget(self, action: #selector(ProfileVC.calendarBtnTap(_:)), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = -20 // adjust as needed
        
        
        self.navigationItem.rightBarButtonItems = [barButton,space]
        
        profileImgview.layer.borderWidth = 1
        profileImgview.layer.masksToBounds = false
        profileImgview.layer.borderColor = UIColor.lightGray.cgColor
        profileImgview.layer.cornerRadius = 50
        profileImgview.clipsToBounds = true
        
        //profileImgview.layer.cornerRadius = 50
        //profileImgview.layer.masksToBounds = true

    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if(appDelegate.bisUserProfile)
        {
            btnAddInterest.isHidden = false
            btnLogout.isHidden = false
            btnReportUser.isHidden = true
            btnPrivacy.isHidden = false
            btnTermsConditions.isHidden = false
            btnBack.isHidden = true
        }
        else
        {
            btnAddInterest.isHidden = true
            btnLogout.isHidden = true
            btnReportUser.isHidden = false
            btnPrivacy.isHidden = true
            btnTermsConditions.isHidden = true
            btnBack.isHidden = false
        }
        
        self .profileImgSetup()
        self.callProfileAPI()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTap(_ sender: Any) {
        _ =  self.navigationController?.popViewController(animated: true)
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
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self .openGallary()
        })
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self .openCamera()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(libraryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }

    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func profileTap(_ sender: Any)
    {
        self.openActionsheet()
    }
    
    @IBAction func logoutTap(_ sender: Any)
    {
        UserDefaults.standard.set(false, forKey: kkeyisUserLogin)
        UserDefaults.standard.synchronize()
        
        appDelegate.bisUserLogout = true
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
         let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.isNavigationBarHidden = true
        appDelegate.window!.rootViewController = nav
    }
    @IBAction func btnsendReport(_ sender: Any)
    {
        let alertView = UIAlertController(title: Application_Name, message: "Are you sure want to report user?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default)
        { (action) in
            
            let objReportVC = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "ReportVC") as! ReportVC
            objReportVC.strReportID = self.strotheruserID
            objReportVC.bisFromFeed = false
            self.navigationController?.pushViewController(objReportVC, animated: true)
        }
        alertView.addAction(OKAction)
        let CancelAction = UIAlertAction(title: "No", style: .default)
        {
            (action) in
        }
        alertView.addAction(CancelAction)
        self.present(alertView, animated: true, completion: nil)

    }
    
    @IBAction func btnPrivacyAction(_ sender: Any)
    {
        let objPrivacyTermsVC = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "PrivacyTermsVC") as! PrivacyTermsVC
        objPrivacyTermsVC.bisPrivacy = true
        self.navigationController?.pushViewController(objPrivacyTermsVC, animated: true)
    }
    @IBAction func btnTermsActio(_ sender: Any)
    {
        let objPrivacyTermsVC = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "PrivacyTermsVC") as! PrivacyTermsVC
        objPrivacyTermsVC.bisPrivacy = false
        self.navigationController?.pushViewController(objPrivacyTermsVC, animated: true)
    }

    
    // MARK: - API call
    func callProfileAPI()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        var userid = String()
        if(appDelegate.bisUserProfile == true)
        {
            userid = "\(final.value(forKey: "userId")!)"
        }
        else
        {
            userid = strotheruserID
        }
        
        let url = kServerURL + kUserprofile + String(describing: userid)
//        showProgress(inView: self.view)
        ShowProgresswithImage(inView: nil, image:UIImage(named: "icon_profileloading"))

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
                                let url = data .value(forKey:"profile_picture") as! String
                                let img = UIImage(named: "")
                                
                                self.profileImgview .sd_setImage(with:URL(string: url as String), placeholderImage:img)
                                self.usernameLabel.text = data.value(forKey: "name") as! String?
                                
                                if (data.value(forKey:"interests")) != nil
                                {
                                    self.arrInterest = data.value(forKey:"interests") as! NSArray
                                }
                                
                                if (data .value(forKey:"userGroups")) != nil
                                {
                                    self.arrGrp = data .value(forKey:"userGroups") as! NSArray
                                }
//                                self.createInterestArr(arrInterest: arrInterest)
                                
                                self.cloudView.tags.removeAll()
                                for iIndex in 0..<self.arrInterest.count
                                {
                                    let name = ((self.arrInterest .object(at: iIndex) as! NSDictionary) .value(forKey: "name")) as! String

                                    let differentFontTag = TagView(text: name)
                                    differentFontTag.font = UIFont(name: "Montserrat-Regular", size: 14)!
                                    differentFontTag.tintColor = UIColor.black
                                    differentFontTag.backgroundColor = UIColor(red: 204.0/255.0, green: 228.0/255.0, blue: 254.0/255.0, alpha: 1)
                                    differentFontTag.tag = iIndex
                                    self.cloudView.tags.append(differentFontTag)
                                    self.cosnt_cloudViewInterest_height.constant = self.cloudView.frame.height
                                }

                                self.cloudGroupTagView.tags.removeAll()
                                for iIndexofGroup in 0..<self.arrGrp.count
                                {
                                    let name = ((self.arrGrp .object(at: iIndexofGroup) as! NSDictionary) .value(forKey: "groupName")) as! String
                                    let differentFontTag = TagView(text: name)
                                    differentFontTag.font = UIFont(name: "Montserrat-Regular", size: 14)!
                                    differentFontTag.tintColor = UIColor.black
                                    differentFontTag.backgroundColor = UIColor(red: 235.0/255.0, green: 255.0/255.0, blue: 196.0/255.0, alpha: 1)
                                    differentFontTag.tag = iIndexofGroup
                                    self.cloudGroupTagView.tags.append(differentFontTag)
                                    self.cosnt_cloudGroup_height.constant = self.cloudGroupTagView.frame.height
                                }
                                
                                self.cosnt_scrlvMain_height.constant = 240 + self.cosnt_cloudViewInterest_height.constant + 50 + self.cloudGroupTagView.frame.height + 80
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
        }
    }
    
    func createInterestArr(arrInterest : NSArray)
    {
        if arrInterest.count > 0 {
            for (index, item) in arrInterest.enumerated() {
                print("Found \(item) at position \(index)")
                let intName = (item as! NSDictionary).value(forKey: "name") as! String
                tagViewInterest_data .add("#"+intName)
            }
    
        } else{
            
//            var img = UIImage(named: "adinterest")
//            tagViewInterest_data .add(img)

        }
       // tagViewInterest .reloadData()
    }
    // MARK: - Data
    
    @IBAction func calendarBtnTap(_ sender: Any) {
        let datepicker =  DatePickerViewController .initViewController()
        self.navigationController?.navigationBar.isTranslucent  = false
        self.navigationController?.pushViewController(datepicker, animated: true)        
    }
    
    @IBAction func addInterestTap(_ sender: Any)
    {
        
        let viewController = AddInterestToMessageVC .initViewController()
        viewController.isfromProfile = true
        
        for iInterestSection in 0..<self.arrInterest.count
        {
            viewController.arrInterestSelectedId.add(((self.arrInterest.object(at: iInterestSection) as! NSDictionary).value(forKey: "interestId")!))
            viewController.arrInterestSelected.add(((self.arrInterest.object(at: iInterestSection) as! NSDictionary).value(forKey: "name")!))
        }
        
        //self.arrInterestSelectedId
        self .navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnGroupDetailAction(_ sender: UIButton)
    {
        print("sender :> \(sender.tag)")
        var dic = NSDictionary()
        dic = (self.arrGrp .object(at: sender.tag) as! NSDictionary)
        
        appDelegate.bcalltoRefreshChannel = true
        if(appDelegate.bisUserProfile)
        {
                let grpVcOBj = GroupVC.initViewController()
                grpVcOBj.grpDetail = dic
                grpVcOBj.isFromLeadingGrp = false
                self.navigationController?.pushViewController(grpVcOBj, animated: true)
        }
        else
        {
            if dic.object(forKey: kkeyisMember) as! Int == 0 && dic.object(forKey: kkeyisLeader) as! Int == 0
            {
                let objJoinGroupVC = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "JoingGroupVC") as! JoingGroupVC
                objJoinGroupVC.dicGroupDetail = dic
                self.navigationController?.pushViewController(objJoinGroupVC, animated: true)
            }
            else
            {
                let grpVcOBj = GroupVC.initViewController()
                grpVcOBj.grpDetail = dic
                grpVcOBj.isFromLeadingGrp = false
                self.navigationController?.pushViewController(grpVcOBj, animated: true)
            }
        }
    }
    
    //MARK: Edit Profile User
    func edituserprofile()
    {
        showProgress(inView: self.view)

        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let param = ["name" : "\(usernameLabel.text!)"]
        let url = kServerURL + kEditProfileAPI
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        upload(multipartFormData:{ multipartFormData in
            
            for (key, value) in param {
                multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
            }
            
            if self.profileImgview.image != nil
            {
                let imgData = UIImageJPEGRepresentation(self.profileImgview.image!, 0.5)
                if (imgData != nil)
                {
                    multipartFormData.append((imgData)!, withName: "image", fileName: "test.jpg", mimeType: "image/jpeg")
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
                        if (temp.value(forKey: "error") != nil)
                        {
                            let msg = ((temp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            self.callProfileAPI()
                        }
                    }
                })
                
            case .failure(let encodingError):
                hideProgress()
                print(encodingError)
            }
        })

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


extension ProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImgview.image = chosenImage
        self.edituserprofile()
        dismiss(animated: true, completion: nil)
    }
}
extension ProfileVC : TagViewDelegate
{
    func tagDismissed(_ tag: TagView)
    {
        print("tag dismissed: " + tag.text)
    }
    
    func tagTouched(_ tag: TagView)
    {
        if tag == cloudView
        {
            print("tag touched: " + tag.text)
            print("tag tag: \(tag.tag)")
        }
        else
        {
            var dic = NSDictionary()
            dic = (self.arrGrp .object(at: tag.tag) as! NSDictionary)

            appDelegate.bcalltoRefreshChannel = true
            if(appDelegate.bisUserProfile)
            {
                let grpVcOBj = GroupVC.initViewController()
                grpVcOBj.grpDetail = dic
                grpVcOBj.isFromLeadingGrp = false
                self.navigationController?.pushViewController(grpVcOBj, animated: true)
            }
            else
            {
                if dic.object(forKey: kkeyisMember) as! Int == 0 && dic.object(forKey: kkeyisLeader) as! Int == 0
                {
                    let objJoinGroupVC = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "JoingGroupVC") as! JoingGroupVC
                    objJoinGroupVC.dicGroupDetail = dic
                    self.navigationController?.pushViewController(objJoinGroupVC, animated: true)
                }
                else
                {
                    let grpVcOBj = GroupVC.initViewController()
                    grpVcOBj.grpDetail = dic
                    grpVcOBj.isFromLeadingGrp = false
                    self.navigationController?.pushViewController(grpVcOBj, animated: true)
                    
                }
            }
        }
    }
}


class interestAndGrpCell : UICollectionViewCell
{
    @IBOutlet weak var btnGrp: UIButton!
    
}

class profileInterestCell : UICollectionViewCell
{
    @IBOutlet weak var btnIntereset: UIButton!
    
}
