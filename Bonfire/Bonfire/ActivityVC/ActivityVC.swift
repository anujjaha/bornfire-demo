//
//  ActivityVC.swift
//  Bonfire
//
//  Created by Kevin on 30/04/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class ActivityVC: UIViewController {

    @IBOutlet weak var btnStartNewGroup: UIButton!
    @IBOutlet weak var clvwLeading: UICollectionView!
    @IBOutlet weak var clvwDiscover: UICollectionView!
    @IBOutlet weak var lblNoGroups : UILabel!
    @IBOutlet weak var scrvw : UIScrollView!
    @IBOutlet weak var const_clvwLeading_height: NSLayoutConstraint!
    @IBOutlet weak var const_lblLeading_height: NSLayoutConstraint!

    var arrLeaderingGrp = NSArray()
    var arrYourGrp = NSArray()
    
    @IBAction func calendarBtnTap(_ sender: Any)
    {
        let datepicker =  DatePickerViewController .initViewController()
        self.navigationController?.navigationBar.isTranslucent  = false
        self.navigationController?.pushViewController(datepicker, animated: true)
    }
    @IBAction func btnStartNewGrpTap(_ sender: UIButton)
    {
        let createGrpObj = CreateGroupVC.initViewController()
        self.navigationController?.pushViewController(createGrpObj, animated: true)
   
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnStartNewGroup.layer.cornerRadius = 10.0
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 35)
        let img = UIImage(named: "Daybar")
        button.setImage(img, for: .normal)
        button.setImage(img, for: .highlighted)

        
        button.addTarget(self, action: #selector(ActivityVC.calendarBtnTap(_:)), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = -20 // adjust as needed
        
        
        self.navigationItem.rightBarButtonItems = [barButton,space]
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        if appDelegate.bUserCreatedGroup == true
        {
            self.GetAllfeed()
            appDelegate.bUserCreatedGroup = false
        }
        else
        {
            let namePredicate = NSPredicate(format: "%K = %d", "isLeader",1)
            self.arrLeaderingGrp = AppDelegate .shared.arrAllGrpData.filter { namePredicate.evaluate(with: $0) } as NSArray
            
            let namePredicate1 = NSPredicate(format: "%K = %d", "isMember",1)
            self.arrYourGrp = AppDelegate.shared.arrAllGrpData.filter { namePredicate1.evaluate(with: $0) } as NSArray
            
            if self.arrLeaderingGrp.count > 0 || self.arrYourGrp.count > 0
            {
                scrvw.isHidden = false
                lblNoGroups.isHidden = true
                if self.arrLeaderingGrp.count == 0
                {
                    const_lblLeading_height.constant = 0
                    const_clvwLeading_height.constant = 0
                }
            }
            else
            {
                scrvw.isHidden = true
                lblNoGroups.isHidden = false
            }
        }
        
    }
    func GetAllfeed()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetAppGroup
//        showProgress(inView: self.view)
        ShowProgresswithImage(inView: nil, image:UIImage(named: "icon_activityloading"))
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                        let dictemp = json as! NSArray
                        print("dictemp :> \(dictemp)")
                        let temp  = dictemp.firstObject as! NSDictionary
                        let data  = temp .value(forKey: "data") as! NSArray
                        
                        if data.count > 0
                        {
                            AppDelegate.shared.arrAllGrpData = data as! Array<Any> as NSArray
                            
                            let namePredicate = NSPredicate(format: "%K = %d", "isLeader",1)
                            self.arrLeaderingGrp = AppDelegate .shared.arrAllGrpData.filter { namePredicate.evaluate(with: $0) } as NSArray
                            
                            let namePredicate1 = NSPredicate(format: "%K = %d", "isMember",1)
                            self.arrYourGrp = AppDelegate.shared.arrAllGrpData.filter { namePredicate1.evaluate(with: $0) } as NSArray
                            
                            if self.arrLeaderingGrp.count > 0 || self.arrYourGrp.count > 0
                            {
                                self.scrvw.isHidden = false
                                self.lblNoGroups.isHidden = true
                                if self.arrLeaderingGrp.count == 0
                                {
                                    self.const_lblLeading_height.constant = 0
                                    self.const_clvwLeading_height.constant = 0
                                }
                            }
                            else
                            {
                                self.scrvw.isHidden = true
                                self.lblNoGroups.isHidden = false
                            }

                            self.clvwLeading.reloadData()
                            self.clvwDiscover.reloadData()
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
    
    override func didReceiveMemoryWarning()
    {
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
        if collectionView == self.clvwLeading {
            return self.arrLeaderingGrp.count
        }else{
            return self.arrYourGrp.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let identifier = "DiscoverCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! DiscoverCell
        
        if collectionView == self.clvwLeading {
            let dic = self.arrLeaderingGrp .object(at: indexPath.row) as! NSDictionary
            
            cell.imageView .sd_setImage(with: URL.init(string:dic .value(forKey: "groupImage") as! String), placeholderImage: nil)
            
        }else {
            let dic = self.arrYourGrp .object(at: indexPath.row) as! NSDictionary
            cell.imageView .sd_setImage(with: URL.init(string:dic .value(forKey: "groupImage") as! String), placeholderImage: nil)
            
        }
        
        cell.imageView.layer.cornerRadius = 5
        cell.imageView.clipsToBounds = true
        cell.imageView.backgroundColor = UIColor.clear
        cell.imageView.contentMode = .scaleAspectFill

        return cell
        
    }
}

// MARK:- UICollectionViewDelegate Methods
extension ActivityVC : UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
      /*  if collectionView != self.clvwLeading
        {
            if UIScreen.main.bounds.size.height<=568
            {
                return CGSize(width: 140, height: 140)
            }
            return CGSize(width: 170, height: 220)
        }*/
        return CGSize(width: 170, height: 220)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let grpVcOBj = GroupVC.initViewController()
        var dic = NSDictionary()
        appDelegate.bcalltoRefreshChannel = true

        if collectionView == self.clvwLeading
        {
            dic = self.arrLeaderingGrp[indexPath.row] as! NSDictionary
            grpVcOBj.isFromLeadingGrp = true
            grpVcOBj.grpDetail = dic
            self.navigationController?.pushViewController(grpVcOBj, animated: true)
        }
        else
        {
            dic = self.arrYourGrp[indexPath.row] as! NSDictionary

            if dic.object(forKey: kkeyisPrivate) as! Int == 1
            {
                if dic.object(forKey: kkeymemberStatus) as! Int == 1
                {
                    grpVcOBj.isFromLeadingGrp = false
                    grpVcOBj.grpDetail = dic
                    self.navigationController?.pushViewController(grpVcOBj, animated: true)
                }
                else
                {
                    App_showAlert(withMessage: "You don't have permission to see Group Activity", inView: self)
                }
            }
            else
            {
                grpVcOBj.isFromLeadingGrp = false
                grpVcOBj.grpDetail = dic
                self.navigationController?.pushViewController(grpVcOBj, animated: true)
            }
        }
        
    }
}
