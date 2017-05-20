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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
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

    
    @IBAction func btnPlusTap(_ sender: Any) {
    }
    @IBAction func btnCoverPhotoTap(_ sender: Any) {
    }
    @IBAction func btnEditInterestTap(_ sender: Any) {
    }
    @IBAction func btnNewChannletap(_ sender: Any) {
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

extension SettingVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "settingCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! profileCollectonviewCell
        
        cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2.0;
        cell.imgView.layoutIfNeeded() //This is important line
        //cell.imgView.layer.masksToBounds = true
        cell.imgView.clipsToBounds = true
        
        return cell
    }
    
}

