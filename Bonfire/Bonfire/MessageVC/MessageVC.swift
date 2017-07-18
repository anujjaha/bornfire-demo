//
//  MessageVC.swift
//  Bonfire
//
//  Created by Yash on 30/04/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class MessageVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var clvwMessage: UICollectionView!
    @IBOutlet weak var tblMessages: UITableView!

    @IBOutlet var const_TxtAnything_leading: NSLayoutConstraint!
    @IBOutlet var buttonUpArrow: UIButton!
    @IBOutlet var buttonPlus: UIButton!
    @IBOutlet var btnHashTag: UIButton!
    
    @IBOutlet var btnG: UIButton!
    var arrMessages = NSMutableArray()
    
    @IBOutlet var btnBackBtn: UIButton!
    
   
    @IBOutlet var txtAnythingTosay: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblMessages.estimatedRowHeight = 138.0
        tblMessages.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "updateSelectedGroup"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageVC.selectedGrpForMessage(notification:)), name:Notification.Name(rawValue: "updateSelectedGroup"), object: nil)
       
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "selectedInterest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageVC.selectedInterestForMessage(notification:)), name:Notification.Name(rawValue: "selectedInterest"), object: nil)
        
        
        
        self.txtAnythingTosay.setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        self.txtAnythingTosay.delegate = self
        self.btnBackBtn.isHidden = true
        
        for _ in 1...10 {
            arrMessages .add("Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ")
        }
        
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 35)
        let img = UIImage(named: "Daybar")
        button.setImage(img, for: .normal)
        button.setImage(img, for: .highlighted)

        
        button.addTarget(self, action: #selector(MessageVC.calendarBtnTap(_:)), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = -20 // adjust as needed
    
        
        self.navigationItem.rightBarButtonItems = [barButton,space]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.setTabbar()
        tblMessages.reloadData()
        
    }
    
    func handleAction(action:UIAlertAction)  {
        
    }
    
    func selectedInterestForMessage(notification:Notification){
        let str =  notification.object
        print(str!)
    }
    
    func selectedGrpForMessage(notification:Notification){
        let str =  notification.object
        print(str!)
    }
    
    @IBAction func btnGrpTap(_ sender: Any) {
    }

    @IBAction func btnMesssageTap(_ sender: Any) {
        
        let leadGrp = UIAlertController(title: "Leading group", message: "", preferredStyle: .actionSheet)
        for i in ["interest1", "interest2", "interest3", "interest4","interest5","interest6","interest7","interest8","interest9","interest10","interest11"] {
            
            leadGrp.addAction(UIAlertAction(title: i, style: .default, handler: handleAction))
        }
        
        leadGrp.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: handleAction))
        
        self .present(leadGrp, animated: true) {
            
        }

    }
    func setTabbar(){
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.buttonPlus.isHidden = false
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
        self.tabBarController?.tabBar.isHidden = false
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMessages.count
    }
   
    
    @IBAction func btnAcceptTap(_ sender: Any) {
        print("accepted")
    }
    
    @IBAction func btnRejectTap(_ sender: Any) {
         print("accepted")
    }
    
    
    @IBAction func btnHasTagTap(_ sender: Any) {
          self.tabBarController?.tabBar.layer.zPosition = 0
//        if let viewController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: kIdentifire_AddInterestToMsgView) as? AddInterestToMsgVC {
//            
//            viewController.bfromGroup = false
//            self .navigationController?.pushViewController(viewController, animated: true)
//            
//            }
        let viewController = AddInterestToMessageVC .initViewController()
        self .navigationController?.pushViewController(viewController, animated: true)
    }
  
    @IBAction func buttonUpArrowTap(_ sender: Any) {
        self.txtAnythingTosay .resignFirstResponder()
        self.setTabbar()
        
    }
    
    @IBAction func btnGTap(_ sender: AnyObject) {

        let  messagevc = MessageGroupListVC .initViewController()
        messagevc.msgArr = ["Group1", "Group2", "Group3", "Group4"]
        self.navigationController?.pushViewController(messagevc, animated: true)
        
      
    }
     func calendarBtnTap(_ sender: Any) {
       let datepicker =  DatePickerViewController .initViewController()
        self.navigationController?.navigationBar.isTranslucent  = false
        self.navigationController?.pushViewController(datepicker, animated: true)
    }
   
    @IBAction func buttonBackArrowTap(_ sender: Any) {
        self.txtAnythingTosay .resignFirstResponder()
        self.txtAnythingTosay.text = nil
        
    }
    
    @IBAction func buttonPlusTap(_ sender: Any)
    {
        self.buttonPlus.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1
        self.tabBarController?.tabBar.isUserInteractionEnabled = false;
        self.tabBarController?.tabBar.isHidden = true
        self.txtAnythingTosay.text = nil
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
      
        cell.btnInterest.layer.cornerRadius = 10.0
        cell.btnGroup.layer.cornerRadius = 10.0
       
        // For Testign Purpose i have  set cell here
//        if indexPath.row == 1 || indexPath.row == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell") as! InviteCell
//            return cell
//        }
        
        cell.selectionStyle = .none
        cell.lblMessageText.text = self.arrMessages[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
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
extension MessageVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "DiscoverCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! DiscoverCell
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods
extension MessageVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
}
extension MessageVC : UITextFieldDelegate
{

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.btnG.isHidden = false
        self.btnHashTag.isHidden = false
        self.buttonUpArrow.isHidden = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        self.txtAnythingTosay.placeholder = "Anything to say?"
        self.btnBackBtn.isHidden = true
        
        self.const_TxtAnything_leading.constant = 10
        
        arrMessages .add(textField.text)
        self.tblMessages .reloadData()
        
        self.setTabbar()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        self.const_TxtAnything_leading.constant = -20
        self.btnG.isHidden = true
        self.btnHashTag.isHidden = true
        self.buttonUpArrow.isHidden = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        self.txtAnythingTosay.placeholder = nil
        self.btnBackBtn.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField .resignFirstResponder()
        
        return true
    }
}
class MessageCell: UITableViewCell
{
    override func awakeFromNib() {
        self .layoutIfNeeded()
        self.imgUser.layer.masksToBounds = false
        self.imgUser.layer.cornerRadius = 21
        self.imgUser.clipsToBounds = true
        self .layoutIfNeeded()
    }
    @IBOutlet weak var lblUserame : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblMessageText : UILabel!
    @IBOutlet weak var btnInterest: UIButton!
    @IBOutlet weak var btnGroup: UIButton!

}

class InviteCell: UITableViewCell
{
    override func awakeFromNib() {
        self .layoutIfNeeded()
        self.imgUser.layer.masksToBounds = false
        self.imgUser.layer.cornerRadius = 21.0
        self.imgUser.clipsToBounds = true
        self .layoutIfNeeded()
    }
    
    @IBOutlet weak var lblUserame: UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblMessageText : UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
}
