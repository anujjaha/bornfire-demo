//
//  AddInterestToMsgVC.swift
//  Bonfire
//
//  Created by Ios User on 09/05/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class AddInterestToMsgVC: UIViewController , HTagViewDelegate, HTagViewDataSource {

    @IBOutlet var tagViewInterest: HTagView!
    @IBOutlet var buttonBack: UIButton!
    
    @IBOutlet var txtInterestToadd: UITextField!
    
    @IBOutlet var buttonUpArrow: UIButton!
    @IBOutlet var btnHash: UIButton!
    var bfromGroup = Bool()
    @IBOutlet var btnNext: UIButton!
    @IBOutlet weak var lblBottomMsg: UILabel!
    @IBOutlet weak var lblTopMessage: UILabel!
    
    @IBAction func buttonBackTap(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if bfromGroup
        {
            btnNext.isHidden = false
            self.lblTopMessage.text = "Add interest to your group"
            self.lblBottomMsg.text = "There interests will help other find your group"
        }
        else
        {
            btnNext.isHidden = true
        }
    }
    
    @IBAction func upArrowTap(_ sender: Any) {
        self.txtInterestToadd .resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    var tagViewInterest_data   = ["# interest","# interest","# interest","# interest"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtInterestToadd.delegate = self
        self.buttonUpArrow.isHidden = true

        self.txtInterestToadd .setValue(UIColor .black, forKeyPath: "_placeholderLabel.textColor")
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        tagViewInterest.delegate = self
        tagViewInterest.dataSource = self
        tagViewInterest.multiselect = false
        tagViewInterest.marg = 0
        tagViewInterest.btwTags = 10
        tagViewInterest.btwLines = 8
        tagViewInterest.fontSize = 15
        //tagViewInterest.tagMainBackColor = UIColor(red: 204.0/255.0, green: 228.0/255.0, blue: 254.0/255.0, alpha: 1)
        tagViewInterest.tagMainTextColor = UIColor.black
       
        //tagViewInterest.tagSecondBackColor = UIColor(red: 204.0/255.0, green: 228.0/255.0, blue: 254.0/255.0, alpha: 1)
        tagViewInterest.tagSecondTextColor = UIColor.black
    }
    
    @IBAction func btnNextAction(_ sender: UIButton)
    {
        if let viewController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: kIdentifire_GroupTitleVC) as? GroupTitleVC
        {
            self .navigationController?.pushViewController(viewController, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    var tagViewGroups_data = ["Group","Group","Group"]
    
    // MARK: - HTagViewDataSource
    func numberOfTags(_ tagView: HTagView) -> Int {
        switch tagView {
        case tagViewInterest:
            return tagViewInterest_data.count
//        case tagViewGroups:
//            return tagViewGroups_data.count
        default:
            return 0
        }
    }
    
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        switch tagView
        {
        case tagViewInterest:
            return tagViewInterest_data[index]
//        case tagViewGroups:
//            return tagViewGroups_data[index]
        default:
            return "???"
        }
    }
    
    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
        switch tagView
        {
        case tagViewInterest:
            return .select
//        case tagViewGroups:
//            return .select
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
        //tagViewGroups_data.remove(at: index)
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
extension AddInterestToMsgVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate method
        self.buttonUpArrow.isHidden = false
        self.btnHash.setImage(UIImage(named: ""), for: .normal)
        self.btnHash .setTitleColor( UIColor .black , for: .normal)
        self.btnHash .setTitle("#", for:.normal)
        self.btnHash .setTitle("#", for:.highlighted)
        self.txtInterestToadd .placeholder = nil
        
       //IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.btnHash.setImage(UIImage(named: "anyinterest_add_icon"), for: .normal)
       // IQKeyboardManager.sharedManager().enableAutoToolbar = true
        self.btnHash .setTitle("", for:.normal)
        self.buttonUpArrow.isHidden = true
        
        self.txtInterestToadd .placeholder = "Any interests to add?"
        
        if (textField.text?.characters.count)! > 0 {
            let str  = "# " + textField.text! 
            tagViewInterest_data.append(str)
            tagViewInterest .reloadData()
        }
        
    
        
        self.txtInterestToadd.text = nil
        
    }
}
