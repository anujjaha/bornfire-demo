//
//  ProfileVC.swift
//  Bonfire
//
//  Created by Kevin on 30/04/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, HTagViewDelegate, HTagViewDataSource
{
    @IBOutlet weak var clviewGrp: UICollectionView!
    @IBOutlet weak var clviewInterest: UICollectionView!
    
    var arrInterest = NSArray()
    var arrGrp = NSArray()
    var strotheruserID = String()
    @IBOutlet weak var btnAddInterest: UIButton!
    @IBOutlet weak var btnLogout: UIButton!


    let tagViewInterest_data = NSMutableArray()
    @IBOutlet weak var tagViewInterest: HTagView!
    @IBOutlet weak var tagViewGroups: HTagView!
    var picker:UIImagePickerController?=UIImagePickerController()

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImgview: UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        picker?.delegate=self
        
        clviewGrp.dataSource = self
        clviewGrp.delegate = self
        
        clviewInterest.dataSource = self
        clviewInterest.delegate = self
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
        if(appDelegate.bisUserProfile)
        {
            btnAddInterest.isHidden = false
            btnLogout.isHidden = false
        }
        else
        {
            btnAddInterest.isHidden = true
            btnLogout.isHidden = true
        }

        self .profileImgSetup()
        self.callProfileAPI()
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.isNavigationBarHidden = true
        appDelegate.window!.rootViewController = nav
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
                                self.clviewGrp .reloadData()
                                self.clviewInterest.reloadData()
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
    func createInterestArr(arrInterest : NSArray)  {
       
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
    
    var tagViewGroups_data = ["Group"]
    
    // MARK: - HTagViewDataSource
    func numberOfTags(_ tagView: HTagView) -> Int {
        switch tagView {
        case tagViewInterest:
            return tagViewInterest_data.count
        case tagViewGroups:
            return tagViewGroups_data.count
        default:
            return 0
        }
    }
    @IBAction func calendarBtnTap(_ sender: Any) {
        let datepicker =  DatePickerViewController .initViewController()
        self.navigationController?.navigationBar.isTranslucent  = false
        self.navigationController?.pushViewController(datepicker, animated: true)        
    }
    
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        switch tagView
        {
        case tagViewInterest:
            return tagViewInterest_data[index] as! String
        case tagViewGroups:
            return tagViewGroups_data[index]
        default:
            return "???"
        }
    }
    
    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
        switch tagView
        {
        case tagViewInterest:
            return .select
        case tagViewGroups:
            return .select
        default:
            return .select
        }
    }
    
    // MARK: - HTagViewDelegate
    func tagView(_ tagView: HTagView, tagSelectionDidChange selectedIndices: [Int])
    {
        print("tag with indices \(selectedIndices) are selected")
    }
    
    func tagView(_ tagView: HTagView, didCancelTagAtIndex index: Int)
    {
        print("tag with index: '\(index)' has to be removed from tagView")
        tagViewGroups_data.remove(at: index)
        tagView.reloadData()
    }


    @IBAction func addInterestTap(_ sender: Any) {
        
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

extension ProfileVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == self.clviewGrp
        {
            return self.arrGrp.count
        }
        else
        {
            return self.arrInterest.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == self.clviewGrp
        {
            let identifier = "grpcell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! interestAndGrpCell
            let name = ((self.arrGrp .object(at: indexPath.row) as! NSDictionary) .value(forKey: "groupName")) as! String
            cell.btnGrp.setTitle(name, for: .normal)
            cell.btnGrp.tag = indexPath.row
            cell.btnGrp.addTarget(self, action: #selector(btnGroupDetailAction(_:)), for: .touchUpInside)

            return cell
        }
        else
        {
            let identifier = "intCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! profileInterestCell
            
                let name = ((self.arrInterest .object(at: indexPath.row) as! NSDictionary) .value(forKey: "name")) as! String
                cell.btnIntereset .setTitle(name, for: .normal)
                cell.btnIntereset.titleLabel?.lineBreakMode = .byTruncatingTail

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var size = CGSize()
        
        if collectionView == self.clviewGrp
        {
            let name = ((self.arrGrp .object(at: indexPath.row) as! NSDictionary) .value(forKey: "groupName")) as! String
            size = name.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)]) //you can add NSForegroundColorAttributeName as well
            return CGSize(width: size.width+15, height: 28.0)

        }
        else
        {
            let name = ((self.arrInterest .object(at: indexPath.row) as! NSDictionary) .value(forKey: "name")) as! String
            size = name.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)]) //you can add NSForegroundColorAttributeName as well
        }


        return CGSize(width: size.width+10, height: 28.0)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        if collectionView == self.clviewGrp
        {
            return 0
        }
        else
        {
            return 5.0
        }
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if collectionView == self.clviewGrp
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else
        {
            if (self.arrInterest.count > 2)
            {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            else
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
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var dic = NSDictionary()
        dic = (self.arrGrp .object(at: indexPath.row) as! NSDictionary)
        
        if  collectionView == self.clviewGrp
        {
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

class interestAndGrpCell : UICollectionViewCell
{
    @IBOutlet weak var btnGrp: UIButton!
    
}

class profileInterestCell : UICollectionViewCell
{
    @IBOutlet weak var btnIntereset: UIButton!
    
}
