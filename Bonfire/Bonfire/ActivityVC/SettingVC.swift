//
//  SettingVC.swift
//  Bonfire
//
//  Created by Sanjay Makvana on 17/05/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var const_plusBtn_Top: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var memberSearch: UITextField!
    @IBOutlet weak var leaderSearch: UITextField!
    @IBOutlet weak var btnEditInterests: UIButton!
    
    @IBOutlet weak var btnPlus: UIButton!
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
    var cnt = Int()
    var prevView = UIView()
    var textFieldDate = UITextField()
    var textFieldTime = UITextField()
    
    @IBAction func removeChannelTap(_ sender: AnyObject) {
        let tag = sender.tag - 101;
        self.arrChannelList .remove(at: tag)
        clvChannelList .reloadData()
    }
    
    @IBOutlet weak var const_containerViewHeight: NSLayoutConstraint!
    
    var arrChannelList = [String]()
    var arrLeader = [String]()
    var arrMember = [String]()
    
    var arrMemberSearch = [String]()
    var arrLeaderSearch = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cnt = 1
        arrChannelList = ["channel"]
        arrLeader = ["leader","lead","leader1"]
        arrMember = ["member","user","test"]
        
        self.leaderSearch .setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        self.memberSearch .setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        
        self.txtGrpName.setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        self.txtDate.setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        self.txtTime.setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        
        self.leaderSearch.delegate = self
        self.memberSearch.delegate = self
        
        self.textViewEventDescription.delegate = self
        self.textViewGrpDescription.delegate = self
        
        prevView = self.textViewEventDescription
        
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
        
        self.txtDate.delegate = self
        self.txtTime.delegate = self
        
        self.setRoundCorner()
        
        
        
    }
  
    
    @IBAction func menuButtonClick(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setRoundCorner() {
        self.view .layoutIfNeeded()
        self.btnNewChannel.layer.cornerRadius = self.btnNewChannel.bounds.size.height/2;
        
        self.btncoverPhoto.layer.cornerRadius = self.btncoverPhoto.bounds.size.height/2;
        self.btnEditInterests.layer.cornerRadius = self.btnEditInterests.bounds.size.height/2;
        
        self.view .layoutIfNeeded()
        
        self.memberSearch.layer.cornerRadius = 15
        self.leaderSearch.layer.cornerRadius = 15
        self.textViewGrpDescription.layer.cornerRadius = 15
        self.textViewEventDescription.layer.cornerRadius = 15
        self.txtGrpName.layer.cornerRadius = 15
        self.txtTime.layer.cornerRadius = 15
        self.txtDate.layer.cornerRadius = 15
        
        self.txtTime.backgroundColor = UIColor .white
        self.txtTime.layer.borderColor = UIColor.white.cgColor
        self.txtTime.layer.borderWidth  = 1.0
        
        
        self.txtDate.backgroundColor = UIColor .white
        self.txtDate.layer.borderColor = UIColor.white.cgColor
        self.txtDate.layer.borderWidth  = 1.0
        
        
        self.txtGrpName.backgroundColor = UIColor .white
        self.txtGrpName.layer.borderColor = UIColor.white.cgColor
        self.txtGrpName.layer.borderWidth  = 1.0
        
        self.memberSearch.backgroundColor = UIColor .white
        self.memberSearch.layer.borderColor = UIColor.white.cgColor
        self.memberSearch.layer.borderWidth  = 1.0
        
        self.leaderSearch.backgroundColor = UIColor .white
        self.leaderSearch.layer.borderColor = UIColor.white.cgColor
        self.leaderSearch.layer.borderWidth  = 1.0
        
        self.textViewGrpDescription.backgroundColor = UIColor .white
        self.textViewGrpDescription.layer.borderColor = UIColor.white.cgColor
        self.textViewGrpDescription.layer.borderWidth  = 1.0
        
        self.textViewEventDescription.backgroundColor = UIColor .white
        self.textViewEventDescription.layer.borderColor = UIColor.white.cgColor
        self.textViewEventDescription.layer.borderWidth  = 1.0
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

    func openDatePicker() -> UIDatePicker  {
        let datepicker = UIDatePicker()
        datepicker .setDate(NSDate() as Date, animated: true)
        datepicker.datePickerMode = .date
        datepicker.minimumDate = NSDate() as Date
        return datepicker
        
    }
    func openTimePicker() -> UIDatePicker  {
        let datepicker = UIDatePicker()
        datepicker .setDate(NSDate() as Date, animated: true)
        datepicker.datePickerMode = .time
        return datepicker
    }
    
    @IBAction func btnPlusTap(_ sender: Any) {
        self.adEventControl()
    }
    
    func adEventControl()  {
        
       // var previousTxtview = self.textViewEventDescription
        
        let viewtxt = UIView()
//        viewtxt.backgroundColor = UIColor.red
        viewtxt.translatesAutoresizingMaskIntoConstraints = false
        viewtxt.tag = 16000 + cnt
        containerView.addSubview(viewtxt)
        
    

        self.const_plusBtn_Top.isActive = false
        // Left constraint

        containerView.addConstraint(NSLayoutConstraint(item: viewtxt, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.containerView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 15))
        
        // Right constraint
        containerView.addConstraint(NSLayoutConstraint(item: viewtxt, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.containerView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -24))
        
        
        // Top constraint
        containerView.addConstraint(NSLayoutConstraint(item: viewtxt, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: prevView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 20))
        
        // bottom constraint
       let con =  NSLayoutConstraint(item: self.btnPlus, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: viewtxt, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 5)
        self.const_plusBtn_Top = con
        containerView.addConstraint(con)

        
        viewtxt.addConstraint(NSLayoutConstraint(item: viewtxt, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem:nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 100))
        
//         : UITextField! = UITextField()
        textFieldDate.placeholder  = "Date"
        textFieldDate.borderStyle = UITextBorderStyle.roundedRect
        textFieldDate.font = UIFont.systemFont(ofSize: 14)
        textFieldDate.translatesAutoresizingMaskIntoConstraints = false
        textFieldDate.delegate = self
        
        
        textFieldDate.layer.cornerRadius = 15
        textFieldDate.layer.masksToBounds  = true
        textFieldDate.backgroundColor = UIColor .white
        textFieldDate.layer.borderColor = UIColor.white.cgColor
        textFieldDate.layer.borderWidth  = 1.0
        
        viewtxt.addSubview(textFieldDate)
//        textFieldDate.backgroundColor = UIColor.yellow


        // Left constraint
        viewtxt.addConstraint(NSLayoutConstraint(item: textFieldDate, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: viewtxt, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0))


        // Top constraint
        viewtxt.addConstraint(NSLayoutConstraint(item: viewtxt, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:textFieldDate, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 00))

//                // bottom constraint
       viewtxt.addConstraint(NSLayoutConstraint(item: textFieldDate, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem:nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 168))

        viewtxt.addConstraint(NSLayoutConstraint(item: textFieldDate, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem:nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 30))
        
        
        
        
//        let textFieldTime : UITextField! = UITextField()
        textFieldTime.placeholder  = "Time"
        textFieldTime.borderStyle = UITextBorderStyle.roundedRect
        textFieldTime.font = UIFont.systemFont(ofSize: 14)
        textFieldTime.translatesAutoresizingMaskIntoConstraints = false
        textFieldTime.delegate = self
        viewtxt.addSubview(textFieldTime)
//        textFieldTime.backgroundColor = UIColor.green
        
        
        // Left constraint
        viewtxt.addConstraint(NSLayoutConstraint(item: textFieldTime, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: textFieldDate, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 20))

        
        // Top constraint
        viewtxt.addConstraint(NSLayoutConstraint(item: viewtxt, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:textFieldTime, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 00))
        
        //width
        viewtxt.addConstraint(NSLayoutConstraint(item: textFieldTime, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem:nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 72))
        
//        viewtxt.addConstraint(NSLayoutConstraint(item: textFieldTime, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem:nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 44))
        
     viewtxt.addConstraint(NSLayoutConstraint(item: textFieldTime, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem:nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 30))
        
        let textview : UITextView! = UITextView()

        textview.font = UIFont.systemFont(ofSize: 14)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.delegate = self
        viewtxt.addSubview(textview)
//        textview.backgroundColor = UIColor.green
        
        textview.text = "Event Description"
        // Left constraint
        viewtxt.addConstraint(NSLayoutConstraint(item: textview, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: viewtxt, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0))
        
//         Right constraint
        viewtxt.addConstraint(NSLayoutConstraint(item: textview, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem:viewtxt, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 2))
        
        
        // Top constraint
        viewtxt.addConstraint(NSLayoutConstraint(item: textview, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:textFieldDate, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 10))
        
        
        viewtxt.addConstraint(NSLayoutConstraint(item: textview, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem:nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 48))

        prevView = viewtxt
        cnt = cnt+1
        
        
        self.view .layoutIfNeeded()
        textFieldTime.layoutIfNeeded()
        
        textview.backgroundColor = UIColor .white
        textview.layer.borderColor = UIColor.white.cgColor
        textview.layer.borderWidth  = 1.0
        

        
        textFieldTime.backgroundColor = UIColor .white
        textFieldTime.layer.borderColor = UIColor.white.cgColor
        textFieldTime.layer.borderWidth  = 1.0
        
        

        textFieldTime.layer.masksToBounds = true
        textview.layer.cornerRadius = 15
        textFieldTime.layer.cornerRadius = 15
        
        //self.containerView .layoutSubviews()
        
        self.view .layoutIfNeeded()
        //containerView .layoutIfNeeded()
    self.view .layoutSubviews()
        
        
        self.const_containerViewHeight.constant = self.const_containerViewHeight.constant + 100
        self.view .layoutIfNeeded()
        containerView .layoutIfNeeded()
       
        textFieldTime.setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        textFieldDate.setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
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
        
        if textField == self.txtDate  {
            textField.inputView = self .openDatePicker()
        }
        if textField == self.textFieldDate  {
            textField.inputView = self .openDatePicker()
        }
        if textField == self.textFieldTime  {
            textField.inputView = self .openDatePicker()
        }

        if textField == self.txtTime {
            textField.inputView = self .openTimePicker()
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

extension SettingVC : UITextViewDelegate {
    
     public func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == textViewGrpDescription {
            if textView.text == "Group Description" {
                textView.text = ""
            }
        } else {
            if textView.text == "Event Description" {
                textView.text = ""
            }
        }
       
    }
     public func textViewDidEndEditing(_ textView: UITextView) {
        if textView == textViewGrpDescription {
            if textView.text == "" {
                textView.text = "Group Description"
            }
        } else {
            if textView.text == "" {
                textView.text = "Event Description"
            }
        }
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        
        if collectionView == clvChannelList {
            
            var calCulateSizze: CGSize? = (self.arrChannelList[indexPath.row]).size(attributes: nil)
            //print("\(calCulateSizze?.height)\(calCulateSizze?.width)")
            let num = Int((calCulateSizze?.width)!)
            
            if num <= 42 {
                calCulateSizze?.width = (calCulateSizze?.width)! + 45
            } else{
                calCulateSizze?.width = (calCulateSizze?.width)! + 50
            }
            
            calCulateSizze?.height = (calCulateSizze?.height)! + 10
            return calCulateSizze!
        } else {
        
//            let cell = clvLeader.cellForItem(at: indexPath) as! MemberCell
//            return CGSize(width: cell.frame.size.width, height: cell.frame.size.height)
            return CGSize(width: 62, height: 69)
        }
       // return CGSize.zero
    }

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
