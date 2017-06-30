//
//  CreateGroupVC.swift
//  Bonfire
//
//  Created by ios  on 14/05/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController {

    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var leaderView: UIView!
    @IBOutlet weak var imageViewCoverPhoto: UIImageView!
    @IBOutlet weak var btnAddCoverPhoto: UIButton!
    var picker:UIImagePickerController?=UIImagePickerController()
    var bnextbuttontap = Bool()

    @IBOutlet weak var clvLeaderList: UICollectionView!
    @IBOutlet weak var txtFindLeader: UITextField!
    
    var search:String=""
    var arrLeaderSearch = [String]()
    var arrLeader = ["member","user","test"]
    var  isSearchLeader : Bool  = false
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        picker?.delegate=self
        // Do any additional setup after loading the view.
        
        self.clvLeaderList.dataSource = self
        self.clvLeaderList.delegate = self
        
        self.clviewLeader.dataSource = self
        self.clviewLeader.delegate = self
        
        self.btnAddCoverPhoto.layer.cornerRadius = 14.0
        self.btnAddCoverPhoto.clipsToBounds = true
        
        self.txtFindLeader.delegate = self
    }

    @IBOutlet weak var clviewLeader: UICollectionView!
    
 
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        if(!bnextbuttontap)
        {
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    static func initViewController() -> CreateGroupVC
    {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "CreateGroupView") as! CreateGroupVC
    }
    
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
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
    
    @IBAction func privateSwitchTap(_ sender: Any) {
    
    }
    
    @IBAction func addCoverPhotoTap(_ sender: Any) {
        self.openActionsheet()
    }
    
    @IBAction func prevBtnTap(_ sender: Any)
    {
        bnextbuttontap = false
        _ = self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func nextBtnTap(_ sender: Any)
    {
        bnextbuttontap = true
//        if let viewController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: kIdentifire_AddInterestToMsgView) as? AddInterestToMsgVC
//        {
//            viewController.bfromGroup = true
//            self .navigationController?.pushViewController(viewController, animated: true)
//        }
        
        let viewController = AddInterestToMessageVC .initViewController()
        viewController.isFromGrp = true
        self .navigationController?.pushViewController(viewController, animated: true)
        

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func btnCloserLeaderView(_ sender: UIButton)
    {
        self.view .endEditing(true)
        self.leaderView.isHidden = true
        self.coverView.isHidden = false
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

extension CreateGroupVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView  == clviewLeader
        {
            if isSearchLeader {
                return self.arrLeaderSearch.count
            }
          return arrLeader.count
        }else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView  == clviewLeader
        {
            let identifier = "leadercell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! LeaderCell
            cell.lblUserName.text = arrLeader[indexPath.row]
            return cell
        }
        else
        {
            let identifier = "cell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! CreateGrpCell
            
            if (indexPath.row == 0)
            {
                cell.imgView.image =  UIImage(named: "circle_leader")!
            }
            else
            {
                cell.imgView.image =  UIImage(named: "plus")!
            }
            return cell
        }
    }
}

// MARK:- UICollectionViewDelegate Methods
extension CreateGroupVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView  == clviewLeader
        {
        }
        else
        {
            if (indexPath.row == 1)
            {
                self.leaderView.isHidden = false
                self.coverView.isHidden = true
                clviewLeader .reloadData()
            }
        }
    }
}

extension CreateGroupVC : UITextFieldDelegate
{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFindLeader {
            self.isSearchLeader = true
        }else {
            self.isSearchLeader = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
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
        
        if textField == txtFindLeader {
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
            
            clviewLeader .reloadData()
            
        }
        return true
    }
}

extension CreateGroupVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageViewCoverPhoto.image = chosenImage
        self.imageViewCoverPhoto.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    }
}

class LeaderCell: UICollectionViewCell
{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
}
