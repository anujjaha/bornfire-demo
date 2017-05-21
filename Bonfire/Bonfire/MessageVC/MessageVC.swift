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
    
    @IBOutlet var btnBackBtn: UIButton!
    @IBOutlet var txtAnythingTosay: UITextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblMessages.estimatedRowHeight = 138.0
        tblMessages.rowHeight = UITableViewAutomaticDimension
        tblMessages.reloadData()
        
        self.txtAnythingTosay.setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        self.txtAnythingTosay.delegate = self
        self.btnBackBtn.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.setTabbar()
        
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
        return 10
    }
   
    
    @IBAction func btnHasTagTap(_ sender: Any) {
          self.tabBarController?.tabBar.layer.zPosition = 0
        if let viewController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: kIdentifire_AddInterestToMsgView) as? AddInterestToMsgVC {
            
            viewController.bfromGroup = false
            self .navigationController?.pushViewController(viewController, animated: true)
            
            }
    }
  
    @IBAction func buttonUpArrowTap(_ sender: Any) {
        self.txtAnythingTosay .resignFirstResponder()
        self.setTabbar()
        
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
        cell.selectionStyle = .none
        
        cell.imgUser.layer.masksToBounds = false
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
        cell.imgUser.clipsToBounds = true

        cell.btnInterest.layer.cornerRadius = 10.0
        cell.btnGroup.layer.cornerRadius = 10.0

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
    @IBOutlet weak var lblUserame : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var lblMessageText : UILabel!
    @IBOutlet weak var btnInterest: UIButton!
    @IBOutlet weak var btnGroup: UIButton!
}
