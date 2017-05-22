//
//  SettingVC.swift
//  Bonfire
//
//  Created by Sanjay Makvana on 17/05/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var memberSearch: UITextField!
    @IBOutlet weak var leaderSearch: UITextField!
    
    @IBOutlet weak var textViewGrpDescription: UITextView!
    @IBOutlet weak var textViewEventDescription: UITextView!
    @IBOutlet weak var txtGrpName: UITextField!
    
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var clvChannelList: UICollectionView!
    
    @IBOutlet weak var btnNewChannel: UIButton!
    @IBOutlet weak var btncoverPhoto: UIButton!
    @IBOutlet weak var clvMember: UICollectionView!
    @IBOutlet weak var clvLeader: UICollectionView!

    var picker:UIImagePickerController?=UIImagePickerController()
    
    var search:String=""
    var  isSearchMember : Bool  = false
    var  isSearchLeader : Bool  = false
    
    
    @IBAction func removeChannelTap(_ sender: AnyObject) {
        let tag = sender.tag - 101;
        self.arrChannelList .remove(at: tag)
        clvChannelList .reloadData()
    }
    
    
    var arrChannelList = [String]()
    var arrLeader = [String]()
    var arrMember = [String]()
    
    var arrMemberSearch = [String]()
    var arrLeaderSearch = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrChannelList = ["channel"]
        arrLeader = ["leader","lead","leader1"]
        arrMember = ["member","user","test"]
        
          self.leaderSearch .setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
          self.memberSearch .setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        
        self.leaderSearch.delegate = self
        self.memberSearch.delegate = self
        
        self.memberSearch.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
       
        self.clvChannelList.dataSource = self
        self.clvChannelList.delegate = self
        
        self.clvLeader.dataSource = self
        self.clvLeader.delegate = self
        
        self.clvMember.dataSource = self
        self.clvMember.delegate = self
        
        
        self.view .layoutIfNeeded()
        self.btnNewChannel.layer.cornerRadius = self.btnNewChannel.bounds.size.height/2;
        
        self.btncoverPhoto.layer.cornerRadius = self.btncoverPhoto.bounds.size.height/2;
        self.btnEditInterests.layer.cornerRadius = self.btnEditInterests.bounds.size.height/2;
        self.view .layoutIfNeeded()
        
        self.memberSearch.backgroundColor = UIColor .white
        self.memberSearch.layer.borderColor = UIColor.white.cgColor
        self.memberSearch.layer.borderWidth  = 1.0
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        
      
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    static func initViewController() -> SettingVC {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "SettingView") as! SettingVC
    }

    @IBOutlet weak var btnEditInterests: UIButton!
    
    @IBAction func btnPlusTap(_ sender: Any) {
    }
    @IBAction func btnCoverPhotoTap(_ sender: Any) {
        self.openActionsheet()
    }
    @IBAction func btnEditInterestTap(_ sender: Any) {
        let interst = InterestVC .initViewController()
        self.navigationController?.pushViewController(interst, animated: true)
    }
    @IBAction func btnNewChannletap(_ sender: Any) {
        self .showPopUp()
    }
    
    func showPopUp(){
        let alertController = UIAlertController(title: "New Channel", message: "Please enter name:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                // store your data
              self.arrChannelList.append(field.text!)
                self.clvChannelList .reloadData()
            } else {
                // user did not fill field
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        dismiss(animated: true, completion: nil)
    }
}


extension SettingVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == memberSearch {
            self.isSearchMember = true
        }else {
            self.isSearchMember = false
        }
        
        if textField == leaderSearch {
            self.isSearchLeader = true
        }else {
            self.isSearchLeader = false
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty
        {
            search = String(search.characters.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        
        if textField == memberSearch {
            print(search)
            let predicate = NSPredicate(format: "SELF CONTAINS[cd] %@", search)
            let arr=(self.arrMember as NSArray).filtered(using: predicate)
            
            if arr.count > 0
            {
                self.arrMemberSearch.removeAll()
                self.arrMemberSearch = arr as! [String]
            }
            else
            {
                self.arrMemberSearch = self.arrMember
            }
            
            self.clvMember .reloadData()

        }
        else {
            print(search)
            let predicate = NSPredicate(format: "SELF CONTAINS[cd] %@", search)
            let arr=(self.arrLeader as NSArray).filtered(using: predicate)
            
            if arr.count > 0
            {
                self.arrLeaderSearch.removeAll()
                self.arrLeaderSearch = arr as! [String]
            }
            else
            {
                self.arrLeaderSearch = self.arrLeader
            }
            
            self.clvLeader .reloadData()

        }
                return true
    }
    
}
extension SettingVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == clvChannelList {
            return self.arrChannelList.count
            //return 2
        }
        else if collectionView == clvMember {
            
            if self.isSearchMember {
                return self.arrMemberSearch.count
            }
            return self.arrMember.count
            
        } else if collectionView == clvLeader {
            
            if self.isSearchLeader {
                return self.arrLeaderSearch.count
            }
            
            return self.arrMember.count
        }
        else {
            return 3
        }
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        var calCulateSizze: CGSize? = (self.arrChannelList[indexPath.row]).size(attributes: nil)
//        //print("\(calCulateSizze?.height)\(calCulateSizze?.width)")
//        let num = Int((calCulateSizze?.width)!)
//        
//        if collectionView == clvChannelList {
//            
//            if num <= 42 {
//                calCulateSizze?.width = (calCulateSizze?.width)! + 45
//            } else{
//                calCulateSizze?.width = (calCulateSizze?.width)! + 50
//            }
//            
//            calCulateSizze?.height = (calCulateSizze?.height)! + 10
//            return calCulateSizze!
//        }
//        return CGSize.zero
//    }
//    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
    
        
        if collectionView == clvChannelList {
            
            let identifier = "channelCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! ChannelCell
            cell.channelName.text = self.arrChannelList[indexPath.row]
            cell.btnClose.tag = indexPath.row + 101;
            
            return cell
        }
        else if collectionView == clvMember {
            let identifier = "memberCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! MemberCell
            if isSearchMember {
                cell.labelMemberName.text = self.arrMemberSearch[indexPath.row]
            } else {
                cell.labelMemberName.text = self.arrMember[indexPath.row]
            }
            
            cell.layoutIfNeeded()
            cell.imgViewMember.backgroundColor = UIColor .gray
            cell.imgViewMember.layer.cornerRadius = cell.imgViewMember.frame.height/2
            cell.layoutIfNeeded()
            return cell
            
        } else if collectionView == clvLeader {
            
            let identifier = "leaderCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! MemberCell
            
            if isSearchLeader {
                cell.labelLeaderName.text =  self.arrLeaderSearch[indexPath.row]
            } else {
                cell.labelLeaderName.text = self.arrLeader[indexPath.row]
            }
            
            cell.layoutIfNeeded()
            cell.imgViewLeader.backgroundColor = UIColor .gray
            cell.imgViewLeader.layer.cornerRadius = cell.imgViewLeader.frame.height/2
            
            cell.layoutIfNeeded()
            
            //cell.imgViewLeader.clipsToBounds = true
            
            return cell
        }
        else {
            let identifier = "settingCell"

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! profileCollectonviewCell
            
            cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2.0;
            cell.imgView.layoutIfNeeded() //This is important line
            //cell.imgView.layer.masksToBounds = true
            cell.imgView.clipsToBounds = true
            
            return cell
        }

    }
    
}

