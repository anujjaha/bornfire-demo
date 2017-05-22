//
//  ActivityVC.swift
//  Bonfire
//
//  Created by Yash on 30/04/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ActivityVC: UIViewController {

    @IBOutlet weak var btnStartNewGroup: UIButton!
    @IBOutlet weak var clvwLeading: UICollectionView!
    @IBOutlet weak var clvwDiscover: UICollectionView!

    @IBAction func btnStartNewGrpTap(_ sender: UIButton)
    {
        let createGrpObj = CreateGroupVC.initViewController()
        self.navigationController?.pushViewController(createGrpObj, animated: true)
        
//        let createGrpObj = SettingVC.initViewController()
//        self.navigationController?.pushViewController(createGrpObj, animated: true)
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnStartNewGroup.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension ActivityVC : UICollectionViewDataSource
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
extension ActivityVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let grpVcOBj = GroupVC.initViewController()
        
        if collectionView == self.clvwLeading
        {
            grpVcOBj.isFromLeadingGrp = true
        }
        else
        {
            grpVcOBj.isFromLeadingGrp = false
        }
        self.navigationController?.pushViewController(grpVcOBj, animated: true)
    }
}
