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
    
    @IBOutlet weak var switchPrivate: UISwitch!
    @IBOutlet weak var txtGrpName: UITextField!
    
    var search:String=""
    var arrLeaderSearch = [String]()
    var arrLeaderSelected = [String]()
    var arrLeader = ["member","user","test","member","user","test","member","user","test","member","user","test"]
    var  isSearchLeader : Bool  = false
    var arrAllCampusUser = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        picker?.delegate=self
        // Do any additional setup after loading the view.
   
        
        self.btnAddCoverPhoto.layer.cornerRadius = 14.0
        self.btnAddCoverPhoto.clipsToBounds = true
        
        self.txtFindLeader.delegate = self
        let allusr =  AppDelegate .shared .allCampusUser()
    
        self.arrAllCampusUser =  allusr .value(forKey: "name") as! NSArray
        
        self.clvLeaderList.dataSource = self
        self.clvLeaderList.delegate = self
        
        self.clviewLeader.dataSource = self
        self.clviewLeader.delegate = self
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
        
        //self .callCreateGroupAPI()

    }
    
    func callCreateGroupAPI(){
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kCreateGroup
        showProgress(inView: self.view)
        let grpname = self.txtGrpName.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        var switchstr = String()
        if self.switchPrivate.isOn {
            switchstr = "1"
        } else {
            switchstr = "0"
        }
        
        let parameters = [
            "name" : grpname,
            "is_private": switchstr]
        

        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
    
//        let imgData = UIImagePNGRepresentation(imageViewCoverPhoto.image!)
        let imgData = UIImageJPEGRepresentation(imageViewCoverPhoto.image!, 0.5)
        
        upload(multipartFormData:{ multipartFormData in
            
            for (key, value) in parameters {
                multipartFormData.append((value?.data(using: String.Encoding.utf8)!)!, withName: key)
            }
            
            multipartFormData.append(imgData!, withName: "image", fileName: "test.jpg", mimeType: "image/jpeg")
            
            
        },
              usingThreshold:UInt64.init(),
              to:url,
              method:.post,
              headers:headers,
              
              encodingCompletion: { encodingResult in
                
                switch encodingResult {
                    
                case .success(let upload, _, _):
//                    upload.responseJSON(completionHandler: { (response) in
//                        hideProgress()
//                        debugPrint(response)
//                    })
                    upload.responseString(completionHandler: { (response) in
                        hideProgress()
                        debugPrint(response)
                        let jsondata = response.result.value?.toJSON()
//                        let arr = jsondata as! Array<Any>
//                        let dict = arr.first as? Dictionary<String, AnyObject>
//                        (dict!["message"]!)

                        
                        let optionMenu = UIAlertController(title: "Bonfire", message: "Group is Created Successfully", preferredStyle: .alert)
                        
                        // 2
                        let libraryAction = UIAlertAction(title: "OK", style: .default, handler: {
                            (alert: UIAlertAction!) -> Void in
                            let viewController = AddInterestToMessageVC .initViewController()
                            viewController.isFromGrp = true
                            self .navigationController?.pushViewController(viewController, animated: true)

                        })
                        
                        optionMenu.addAction(libraryAction)
                        self.present(optionMenu, animated: true, completion: nil)
                    
                    })
                case .failure(let encodingError):
                    hideProgress()
                    print(encodingError)
                }
        })
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
//          return arrLeader.count
            return 10
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
            if isSearchLeader {
                if self.arrLeaderSelected .contains(arrLeaderSearch[indexPath.row]) {
                    cell.imgView.image = UIImage(named: "memberselect")
                } else {
                    cell.imgView.image = UIImage(named: "circle_leader")
                }
                cell.lblUserName.text = arrLeaderSearch[indexPath.row]
            }else{
                
                if self.arrLeaderSelected .contains(arrLeader[indexPath.row]) {
                    cell.imgView.image = UIImage(named: "memberselect")
                } else {
                    cell.imgView.image = UIImage(named: "circle_leader")
                }
                
                cell.lblUserName.text = arrLeader[indexPath.row]
            }
            
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

extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = UIImagePNGRepresentation(self)! as NSData
        let data2: NSData = UIImagePNGRepresentation(image)! as NSData
        return data1.isEqual(data2)
    }
    
}

// MARK:- UICollectionViewDelegate Methods
extension CreateGroupVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView  == clviewLeader
        {
//            memberselect
            let cell = collectionView .cellForItem(at: indexPath) as! LeaderCell
            
            
            if (cell.imgView.image?.isEqualToImage(image: UIImage(named: "memberselect")!))! {
                cell.imgView.image = UIImage(named: "circle_leader")
                
                if isSearchLeader {
                    self.arrLeaderSelected .append(arrLeaderSearch[indexPath.row])
                } else{
                    self.arrLeaderSelected .append(arrLeader[indexPath.row])
                }
                
                
                
            }else{
                if !self.arrLeaderSelected .contains(arrLeader[indexPath.row]) {
                    
                    if isSearchLeader {
                        self.arrLeaderSelected .append(arrLeaderSearch[indexPath.row])
                    } else{
                        self.arrLeaderSelected .append(arrLeader[indexPath.row])
                    }
                    
                } else {
                    if let indexsel = self.arrLeader .index(of: arrLeader[indexPath.row]) {
                        self.arrLeaderSelected .remove(at: indexsel)
                    }
                }
                

                cell.imgView.image = UIImage(named: "memberselect")
            }
        }
        else
        {
            if (indexPath.row == 1)
            {
                self.leaderView.isHidden = false
                self.coverView.isHidden = true
                self.isSearchLeader = false
                self.txtFindLeader.text = nil
                arrLeaderSearch .removeAll()
                arrLeaderSelected .removeAll()
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
                isSearchLeader = true
                self.arrLeaderSearch.removeAll()
                self.arrLeaderSearch = arr as! [String]
            }
            else
            {
                isSearchLeader = false
//                self.arrLeaderSearch = self.arrLeader
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
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
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

extension String {
    func toJSON()-> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
