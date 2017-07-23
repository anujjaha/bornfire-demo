//
//  ProfileVC.swift
//  Bonfire
//
//  Created by Yash on 30/04/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, HTagViewDelegate, HTagViewDataSource {

    @IBOutlet weak var clviewGrp: UICollectionView!
    @IBOutlet weak var clviewInterest: UICollectionView!
    
    
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
        
        
//        tagViewInterest.delegate = self
//        tagViewInterest.dataSource = self
//        tagViewInterest.multiselect = false
//        tagViewInterest.marg = 0
//        tagViewInterest.btwTags = 10
//        tagViewInterest.btwLines = 8
//        tagViewInterest.fontSize = 15
//        tagViewInterest.tagMainBackColor = UIColor(red: 204.0/255.0, green: 228.0/255.0, blue: 254.0/255.0, alpha: 1)
//        tagViewInterest.tagMainTextColor = UIColor.black
//        tagViewInterest.tagSecondBackColor = UIColor(red: 204.0/255.0, green: 228.0/255.0, blue: 254.0/255.0, alpha: 1)
//        tagViewInterest.tagSecondTextColor = UIColor.black
//        
//        tagViewGroups.delegate = self
//        tagViewGroups.dataSource = self
//        tagViewGroups.multiselect = false
//        tagViewGroups.marg = 0
//        tagViewGroups.btwTags = 10
//        tagViewGroups.btwLines = 8
//        tagViewGroups.fontSize = 15
//        tagViewGroups.tagMainBackColor = UIColor(red: 234.0/255.0, green: 255.0/255.0, blue: 196.0/255.0, alpha: 1)
//        tagViewGroups.tagMainTextColor = UIColor.black
//        tagViewGroups.tagSecondBackColor =  UIColor(red: 234.0/255.0, green: 255.0/255.0, blue: 196.0/255.0, alpha: 1)
//        tagViewGroups.tagSecondTextColor = UIColor.black
//                
//
//        tagViewInterest.reloadData()
//        tagViewGroups.reloadData()
        
        self .profileImgSetup()
        //self.callProfileAPI()

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
    override func viewWillAppear(_ animated: Bool) {
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
    @IBAction func profileTap(_ sender: Any) {
        self.openActionsheet()
    }
    
    @IBAction func logoutTap(_ sender: Any) {
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.isNavigationBarHidden = true
        appdelegate.window!.rootViewController = nav
        
        
    }
    // MARK: - API call
    func callProfileAPI() {
        

        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let userid = final .value(forKey: "userId")
        
        let url = kServerURL + kUserprofile + String(describing: userid!)
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
                        let data  = temp .value(forKey: "data") as! NSDictionary
                      
                        if data.count > 0 {
                            
                            if let err  =  data.value(forKey: kkeyError) {
                                App_showAlert(withMessage: err as! String, inView: self)
                            }else {
                                print("no error")
                                let url = data .value(forKey:"profile_picture") as! String
                                let img = UIImage(named: "")
                                
                                self.profileImgview .sd_setImage(with:URL(string: url as String), placeholderImage:img)
                                
                                self.usernameLabel.text = data.value(forKey: "name") as! String?
                                
                                var arrInterest = data .value(forKey:"interests") as! NSArray
                                
                                self.createInterestArr(arrInterest: arrInterest)
                                
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
        if collectionView == self.clviewGrp {
            return 10
        } else{
            return 2
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == self.clviewGrp {
            let identifier = "grpcell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! interestAndGrpCell
            
            cell.btnGrp .setTitle("test", for: .normal)
            
            return cell
        } else {
            let identifier = "intCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! profileInterestCell
            
            cell.btnIntereset .setTitle("testIntereset", for: .normal)
            
            if indexPath.row == 1 {
                
//                cell.btnIntereset .setTitle("", for: .normal)
//                cell.btnIntereset .setImage(UIImage(named: "addinterest"), for: .normal)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 28.0)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//    }
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


extension ProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImgview.image = chosenImage
        self.profileImgview.contentMode = .scaleToFill
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
