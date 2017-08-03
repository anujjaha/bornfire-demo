//
//  MessageVC.swift
//  Bonfire
//
//  Created by Kevin on 30/04/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class MessageVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var const_collecview_top: NSLayoutConstraint!
    @IBOutlet weak var const_tbl_top: NSLayoutConstraint!
    @IBOutlet weak var clvwMessage: UICollectionView!
    @IBOutlet weak var tblMessages: UITableView!

    @IBOutlet var buttonUpArrow: UIButton!
    @IBOutlet var buttonPlus: UIButton!
    @IBOutlet var btnHashTag: UIButton!
    
    var arrMessages = NSMutableArray()
    var currentOffset = CGFloat()
    var selectedGrpForMessage = String()
    var arrInterestForMessage = NSArray()
    var arrAllFeedData = NSArray()
    
    
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
        
//        for _ in 1...10 {
//            arrMessages .add("Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ")
//        }
        
        
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
        
        self.setTabbar()
        tblMessages.reloadData()
        
        self.getAllMessagesFeed()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func handleAction(action:UIAlertAction)  {
        
    }
    
    func selectedInterestForMessage(notification:Notification){
        let str =  notification.object
        arrInterestForMessage = NSArray(array: str as! NSArray)
        print(str!)
    }
    
    func selectedGrpForMessage(notification:Notification){
        let str =  notification.object
        selectedGrpForMessage = str as! String
        print(str!)
    }
    
    @IBAction func btnGrpTap(_ sender: Any) {
    }

    @IBAction func btnMesssageTap(_ sender: Any)
    {
        let btn = sender as! UIButton
        
        let dict = self.arrMessages[btn.tag - 100] as! NSDictionary
        
        let interestArr = dict.value(forKey: "interests") as! NSArray
        
        if interestArr.count > 0 {
            let allinterest = interestArr .value(forKey: "name") as! NSArray
            print(allinterest)
            
            
            let leadGrp = UIAlertController(title: "Interests List", message: "", preferredStyle: .actionSheet)
            for i in allinterest {
                
                leadGrp.addAction(UIAlertAction(title: i as? String, style: .default, handler: handleAction))
            }
            
            leadGrp.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: handleAction))
            
            self .present(leadGrp, animated: true) {
                
            }
        }
    }
    
    func setTabbar(){
    
//        self.tabBarController?.tabBar.layer.zPosition = 0
//        self.buttonPlus.isHidden = false
//        self.tabBarController?.tabBar.isUserInteractionEnabled = true
//        self.tabBarController?.tabBar.isHidden = false
        
        
        self.buttonPlus.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isUserInteractionEnabled = true;
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
        if (txtAnythingTosay.text?.characters.count)! > 0 {
            
            if  arrInterestForMessage.count > 0
            {
                //arrMessages .add(textField.text! as String)
                self.callApiToCreateNewChannelFeed()
                self.setTabbar()
            }
            else
            {
                App_showAlert(withMessage: "Please select all details", inView: self)
            }
        }
        else
        {
            //App_showAlert(withMessage: "Please select all details", inView: self)
            setTabbar()
        }
    }
    
     func calendarBtnTap(_ sender: Any)
     {
       let datepicker =  DatePickerViewController .initViewController()
        self.navigationController?.navigationBar.isTranslucent  = false
        self.navigationController?.pushViewController(datepicker, animated: true)
    }
   
    @IBAction func buttonBackArrowTap(_ sender: Any)
    {
        self.txtAnythingTosay .resignFirstResponder()
//        self.txtAnythingTosay.text = nil
        
    }
    
    @IBAction func buttonPlusTap(_ sender: Any)
    {
        self.buttonPlus.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1
        self.tabBarController?.tabBar.isUserInteractionEnabled = false;
        self.tabBarController?.tabBar.isHidden = true
        self.txtAnythingTosay.text = nil
    }
   
    func GetAllfeed() {
        
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        
        let url = kServerURL + kGetAppGroup
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
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
                        
                        hideProgress()
                        
                        if data.count > 0 {
                            self.arrAllFeedData = data 
                            
                            self.clvwMessage.dataSource = self
                            self.clvwMessage.delegate = self
                            self.clvwMessage .reloadData()
                        }
                        else
                        {
                            //                            App_showAlert(withMessage: data[kkeyError]! as! String, inView: self)
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
    
    func callApiToCreateNewChannelFeed()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let strint = self.arrInterestForMessage.componentsJoined(by: ",")
//        let param:[String:Any] = ["is_campus_feed" : "1","description": self.txtAnythingTosay.text!,"interests": arrInterestForMessage as Array]
        let param:[String:Any] = ["is_campus_feed" : "1","description": self.txtAnythingTosay.text!,"interests": strint]

        let url = kServerURL + kCreateNewFeed
        print("parameters Message Post:>\(param)")

        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
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
//                        self.tblMessages .reloadData()
                        self.txtAnythingTosay.text = "Anything to say?"
                        self.getAllMessagesFeed()
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
    func getAllMessagesFeed() {
        
        // get all home feed api calling
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        
        let url = kServerURL + kGetMessagesFeed
        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
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
                        
                        } else {
                            let data  = temp .value(forKey: "data") as! NSArray
                            
                            if data.count > 0 {
                                print(data)
                                self.arrMessages = data .mutableCopy() as! NSMutableArray
                                self.tblMessages .reloadData()
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
            self.GetAllfeed()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
      
        cell.btnInterest.layer.cornerRadius = 10.0
       
        // For Testign Purpose i have  set cell here
//        if indexPath.row == 1 || indexPath.row == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell") as! InviteCell
//            return cell
//        }
        
        cell.btnInterest.tag = indexPath.row + 100
        cell.selectionStyle = .none
//        cell.lblMessageText.text = self.arrMessages[indexPath.row] as? String
        
        let dict = self.arrMessages[indexPath.row] as! NSDictionary
        cell.lblMessageText.text = dict .value(forKey: "description") as! String?
        
        let feeddict = dict  .value(forKey: "feedCreator") as? NSDictionary
        cell.lblUserame.text = feeddict? .value(forKey: "name") as? String
    
        let profileurl = feeddict? .value(forKey: "profile_picture") as? String
        cell.imgUser .sd_setImage(with: URL(string: (profileurl)!), placeholderImage: nil)
        
        let interestArr = dict.value(forKey: "interests") as! NSArray
        if interestArr.count > 0
        {
            let firstdict = interestArr.firstObject as! NSDictionary
            let firstname = firstdict .value(forKey: "name") as? String
            cell.btnInterest .setTitle("#" + firstname!, for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let dict = self.arrMessages[indexPath.row] as! NSDictionary
        if (dict.value(forKey: "description") as! NSString).length < 100
        {
            return 120
        }
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
        return self.arrAllFeedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "DiscoverCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! DiscoverCell
        
        
        let dic = self.arrAllFeedData[indexPath.row] as! NSDictionary
        let strurl = dic["groupImage"] as! String
        let url  = URL.init(string: strurl)
        cell.imageView.sd_setImage(with: url, placeholderImage: nil)
        
        
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods
extension MessageVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dic = self.arrAllFeedData[indexPath.row] as! NSDictionary
        let grpVcOBj = GroupVC.initViewController()
        grpVcOBj.grpDetail = dic
        grpVcOBj.isFromLeadingGrp = false
        self.navigationController?.pushViewController(grpVcOBj, animated: true)
    }
}

extension MessageVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView == tblMessages
        {
            
            if scrollView.panGestureRecognizer .translation(in: scrollView.superview).y < 0
            {
                let scrollPos: CGFloat = clvwMessage.frame.origin.y
                
                if scrollPos > 0
                {
                    
                    print(scrollPos)
                    UIView .animate(withDuration: 0.25, animations: {
                        self.const_collecview_top.constant -= 50
                        self.const_tbl_top.constant -= 50
                    })
                    
                }
                
            } else {
                
                let scrollPos: CGFloat = clvwMessage.frame.origin.y
                if scrollPos < 0
                {
                    self.const_collecview_top.constant += 100
                    self.const_tbl_top.constant += 100
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
}

extension MessageVC : UITextFieldDelegate
{

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.btnHashTag.isHidden = false
        self.buttonUpArrow.isHidden = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        self.txtAnythingTosay.placeholder = "Anything to say?"
        self.btnBackBtn.isHidden = true
        
//        self.const_TxtAnything_leading.constant = 10
        
        
//        self.setTabbar()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
//        self.const_TxtAnything_leading.constant = -20
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
    override func awakeFromNib()
    {
        self .layoutIfNeeded()
        
        self.imgUser.layer.borderWidth = 1
        self.imgUser.layer.masksToBounds = false
        self.imgUser.layer.borderColor = UIColor.lightGray.cgColor
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
        self .layoutSubviews()
        
        self.imgUser.layer.borderWidth = 1
        self.imgUser.layer.masksToBounds = false
        self.imgUser.layer.borderColor = UIColor.lightGray.cgColor
        self.imgUser.layer.cornerRadius = 21
        self.imgUser.clipsToBounds = true
        
        self .layoutSubviews()
        self .layoutIfNeeded()
    }
    
    @IBOutlet weak var lblUserame: UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblMessageText : UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
}
