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
    
    @IBOutlet weak var clvLeaderList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker?.delegate=self
        // Do any additional setup after loading the view.
        
        self.clvLeaderList.dataSource = self
        self.clvLeaderList.delegate = self
        
        self.clviewLeader.dataSource = self
        self.clviewLeader.delegate = self
        
    }

    @IBOutlet weak var clviewLeader: UICollectionView!
    
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btnAddCoverPhoto.layer.cornerRadius = self.btnAddCoverPhoto.frame.height/2
        self.btnAddCoverPhoto.clipsToBounds = true
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    static func initViewController() -> CreateGroupVC {
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
    
    @IBAction func prevBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func nextBtnTap(_ sender: Any) {
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openActionsheet() {
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView  == clviewLeader {
            let identifier = "leadercell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! CreateGrpCell
            
            cell.leaderImgView.layer.cornerRadius = cell.leaderImgView.frame.width/2
            
            cell.leaderImgView.clipsToBounds = true
            
            return cell
        } else {
            let identifier = "cell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! CreateGrpCell
            
            cell.imgView.layer.cornerRadius = cell.imgView.frame.width/2
            cell.imgView.clipsToBounds = true
            
            return cell
        }
       
    }
}

// MARK:- UICollectionViewDelegate Methods

extension CreateGroupVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//       self.leaderView.isHidden  = !self.leaderView.isHidden
//        self.coverView.isHidden  = !self.coverView.isHidden;
    }
    
}


extension CreateGroupVC : UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar .resignFirstResponder()
    }
    
}

extension CreateGroupVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
         let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageViewCoverPhoto.image = chosenImage
        self.imageViewCoverPhoto.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    }
}
