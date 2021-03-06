//
//  DiscoverVC.swift
//  Bonfire
//
//  Created by Kevin on 29/04/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class DiscoverVC: UIViewController ,UIScrollViewDelegate
{
    @IBOutlet weak var const_foryouCollview_height: NSLayoutConstraint!
    @IBOutlet weak var cosnt_foryouLabel_height: NSLayoutConstraint!
    @IBOutlet weak var clvwyour: UICollectionView!
    @IBOutlet weak var clvwDiscover: UICollectionView!
    @IBOutlet weak var clvwGroups: UICollectionView!
    @IBOutlet weak var scrlvMain: UIScrollView!
    @IBOutlet weak var cosnt_scrlvMain_height: NSLayoutConstraint!

    @IBOutlet weak var vwHeader: UIView!

    var arrDiscovery = Array<Any>()
    var arrForYouGrp = Array<Any>()
    var arrAllFeedData = Array<Any>()

    var previousScrollViewYOffset: CGFloat = 0.0
    var currentOffset = CGFloat()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.clvwyour.dataSource = self
        scrlvMain.delegate = self
        
        scrlvMain.isScrollEnabled = true
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        scrlvMain.addSubview(refreshControl)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 35)
        let img = UIImage(named: "Daybar")
        button.setImage(img, for: .normal)
        button.setImage(img, for: .highlighted)

        button.addTarget(self, action: #selector(DiscoverVC.calwndarBtnTap(_:)), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = -20 // adjust as needed
        
        self.navigationItem.rightBarButtonItems = [barButton,space]
        
        self .GetAllfeed()
    }
    override func viewWillAppear(_ animated: Bool)
    {
//        self .GetAllfeed()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func pullToRefresh(_ refreshControl: UIRefreshControl)
    {
        // Update your conntent here
        self .GetAllfeed()
        refreshControl.endRefreshing()
    }

    
    func GetAllfeed()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary

        let url = kServerURL + kGetAppGroup
        showProgress(inView: self.view)
//        ShowProgresswithImage(inView: nil, image:UIImage(named: "icon_discoverloading"))
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
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
                        
                        if (temp.value(forKey: "error") != nil)
                        {
                            let msg = ((temp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            let data  = temp .value(forKey: "data") as! NSArray
                            if data.count > 0
                            {
                                self.arrAllFeedData = data as! Array<Any>
                                AppDelegate .shared.arrAllGrpData = self.arrAllFeedData as NSArray
                                
                                let namePredicate = NSPredicate(format: "%K = %d", "isDiscovery",1)
                                self.arrDiscovery = self.arrAllFeedData.filter { namePredicate.evaluate(with: $0) };
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
            self.callForYouGrpFeed()
        }
    }
    
    func callForYouGrpFeed()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetForYouFeed
        DispatchQueue.main.async {
            showProgress(inView: self.view)
//            ShowProgresswithImage(inView: nil, image:UIImage(named: "icon_discoverloading"))
        }
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil {
                    print(response.result.value!)
                    
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSArray
                        print("dictemp :> \(dictemp)")
                        let temp  = dictemp.firstObject as! NSDictionary
                        
                        if (temp.value(forKey: "error") != nil)
                        {
                            let errdic = temp.value(forKey: "error") as! NSDictionary
//                            let msg = errdic .value(forKey: "reason") as? String
                            self.const_foryouCollview_height.constant = 0
                            self.cosnt_foryouLabel_height.constant = 0
                            self.cosnt_scrlvMain_height.constant = 601
                        }
                        else
                        {
                            let data  = temp .value(forKey: "data") as! NSArray
                            if data.count > 0
                            {
                                self.arrForYouGrp = data as! Array<Any>
                                self.const_foryouCollview_height.constant = 220
                                self.cosnt_foryouLabel_height.constant = 21
                                self.cosnt_scrlvMain_height.constant = 730
                            }
                            else
                            {
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
            self.callRandomGroups()
        }
    }
    
    func callRandomGroups()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kRandomGroups
        DispatchQueue.main.async {
            showProgress(inView: self.view)
            //            ShowProgresswithImage(inView: nil, image:UIImage(named: "icon_discoverloading"))
        }
        
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
                        
                        if (temp.value(forKey: "error") != nil)
                        {
                            let errdic = temp.value(forKey: "error") as! NSDictionary
                        }
                        else
                        {
                            let data  = temp .value(forKey: "data") as! NSArray
                            if data.count > 0
                            {
                                self.arrDiscovery = data as! Array<Any>
                            }
                            else
                            {
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
            
            self.clvwyour.dataSource = self
            self.clvwGroups.dataSource = self
            self.clvwDiscover.dataSource = self
            
            self.clvwyour.delegate = self
            self.clvwGroups.delegate = self
            self.clvwDiscover.delegate = self
            
            
            self.clvwGroups .reloadData()
            self.clvwyour .reloadData()
            self.clvwDiscover .reloadData()
        }
    }

    @IBAction func calwndarBtnTap(_ sender: Any)
    {
        let datepicker =  DatePickerViewController .initViewController()
        self.navigationController?.navigationBar.isTranslucent  = false
        self.navigationController?.pushViewController(datepicker, animated: true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
       /* if scrollView == scrlvMain
        {
            currentOffset = self.scrlvMain.contentOffset.y
            
            let scrollPos: CGFloat = clvwyour.contentOffset.y
            if scrollPos >= currentOffset
            {
                //Fully hide your toolbar
                UIView.animate(withDuration: 0.25, animations: {() -> Void in
                    
                    self.vwHeader.isHidden = true
//                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                })
            }
            else
            {
                //Slide it up incrementally, etc.
                UIView.beginAnimations("toggleNavBar", context: nil)
                UIView.setAnimationDuration(0.2)
                vwHeader.isHidden = false
                //                self.navigationController?.setNavigationBarHidden(false, animated: true)
                UIView.commitAnimations()
            }
        }*/
    }

}

extension DiscoverVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if  collectionView == self.clvwDiscover
        {
            return self.arrDiscovery.count
        }
        else if(collectionView == self.clvwGroups)
        {
            return self.arrAllFeedData.count
        }
        else
        {
            return self.arrForYouGrp.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "DiscoverCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! DiscoverCell
                
        cell.imageView.layer.cornerRadius = 5
        cell.imageView.clipsToBounds = true
        cell.imageView.backgroundColor = UIColor.clear
        cell.imageView.contentMode = .scaleAspectFill

        if  collectionView == self.clvwDiscover
        {
            let dic = self.arrDiscovery[indexPath.row] as! NSDictionary
            let strurl = dic["groupImage"] as! String
            let url  = URL.init(string: strurl)
            cell.imageView.sd_setImage(with: url, placeholderImage: nil)

        }
        else if(collectionView == self.clvwGroups)
        {
            let dic = self.arrAllFeedData[indexPath.row] as! NSDictionary
            let strurl = dic["groupImage"] as! String
            let url  = URL.init(string: strurl)
            cell.imageView.sd_setImage(with: url, placeholderImage: nil)
        }
        else
        {
            let dic = self.arrForYouGrp[indexPath.row] as! NSDictionary
            let strurl = dic["groupImage"] as! String
            let url  = URL.init(string: strurl)
            cell.imageView.sd_setImage(with: url, placeholderImage: nil)
        }
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods

extension DiscoverVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var dic = NSDictionary()
        appDelegate.bcalltoRefreshChannel = true
        
        if  collectionView == self.clvwDiscover
        {
            dic = self.arrDiscovery[indexPath.row] as! NSDictionary
            print(dic)
            
            if dic.object(forKey: kkeyisLeader) as! Int == 1
            {
                let grpVcOBj = GroupVC.initViewController()
                grpVcOBj.grpDetail = dic
                grpVcOBj.isFromLeadingGrp = false
                self.navigationController?.pushViewController(grpVcOBj, animated: true)
            }
            else if dic.object(forKey: kkeyisPrivate) as! Int == 0
            {
                if dic.object(forKey: kkeyisMember) as! Int == 0 && dic.object(forKey: kkeyisLeader) as! Int == 0
                {
                    let objJoinGroupVC = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "JoingGroupVC") as! JoingGroupVC
                    objJoinGroupVC.dicGroupDetail = dic
                    self.navigationController?.pushViewController(objJoinGroupVC, animated: true)
                }
                else
                {
                    let grpVcOBj = GroupVC.initViewController()
                    grpVcOBj.grpDetail = dic
                    grpVcOBj.isFromLeadingGrp = false
                    self.navigationController?.pushViewController(grpVcOBj, animated: true)
                }
            }
            else
            {
                if dic.object(forKey: kkeyisMember) as! Int == 1 && dic.object(forKey: kkeymemberStatus) as! Int == 1
                {
                    let grpVcOBj = GroupVC.initViewController()
                    grpVcOBj.grpDetail = dic
                    grpVcOBj.isFromLeadingGrp = false
                    self.navigationController?.pushViewController(grpVcOBj, animated: true)
                }
                else  if dic.object(forKey: kkeyisMember) as! Int == 1 && dic.object(forKey: kkeymemberStatus) as! Int == 0
                {
                    App_showAlert(withMessage: "You don't have permission to see Group Activity", inView: self)

                }
                else if dic.object(forKey: kkeyisMember) as! Int == 0
                {
                    let objJoinGroupVC = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "JoingGroupVC") as! JoingGroupVC
                    objJoinGroupVC.dicGroupDetail = dic
                    self.navigationController?.pushViewController(objJoinGroupVC, animated: true)
                }
            }
        }
        else if(collectionView == self.clvwGroups)
        {
            dic = self.arrAllFeedData[indexPath.row] as! NSDictionary
            if dic.object(forKey: kkeyisLeader) as! Int == 1
            {
                let grpVcOBj = GroupVC.initViewController()
                grpVcOBj.grpDetail = dic
                grpVcOBj.isFromLeadingGrp = false
                self.navigationController?.pushViewController(grpVcOBj, animated: true)
            }
           else if dic.object(forKey: kkeyisPrivate) as! Int == 0
            {
                if dic.object(forKey: kkeyisMember) as! Int == 0 && dic.object(forKey: kkeyisLeader) as! Int == 0
                {
                    let objJoinGroupVC = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "JoingGroupVC") as! JoingGroupVC
                    objJoinGroupVC.dicGroupDetail = dic
                    self.navigationController?.pushViewController(objJoinGroupVC, animated: true)
                }
                else
                {
                    let grpVcOBj = GroupVC.initViewController()
                    grpVcOBj.grpDetail = dic
                    grpVcOBj.isFromLeadingGrp = false
                    self.navigationController?.pushViewController(grpVcOBj, animated: true)
                }
            }
            else
            {
                if dic.object(forKey: kkeyisMember) as! Int == 1 && dic.object(forKey: kkeymemberStatus) as! Int == 1
                {
                    let grpVcOBj = GroupVC.initViewController()
                    grpVcOBj.grpDetail = dic
                    grpVcOBj.isFromLeadingGrp = false
                    self.navigationController?.pushViewController(grpVcOBj, animated: true)
                }
                else  if dic.object(forKey: kkeyisMember) as! Int == 1 && dic.object(forKey: kkeymemberStatus) as! Int == 0
                {
                    App_showAlert(withMessage: "You don't have permission to see Group Activity", inView: self)
                    
                }
                else if dic.object(forKey: kkeyisMember) as! Int == 0
                {
                    let objJoinGroupVC = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "JoingGroupVC") as! JoingGroupVC
                    objJoinGroupVC.dicGroupDetail = dic
                    self.navigationController?.pushViewController(objJoinGroupVC, animated: true)
                }
            }

        }
        else
        {
            dic = self.arrForYouGrp[indexPath.row] as! NSDictionary
            if dic.object(forKey: kkeyisLeader) as! Int == 1
            {
                let grpVcOBj = GroupVC.initViewController()
                grpVcOBj.grpDetail = dic
                grpVcOBj.isFromLeadingGrp = false
                self.navigationController?.pushViewController(grpVcOBj, animated: true)
            }
            else if dic.object(forKey: kkeyisPrivate) as! Int == 0
            {
                if dic.object(forKey: kkeyisMember) as! Int == 0 && dic.object(forKey: kkeyisLeader) as! Int == 0
                {
                    let objJoinGroupVC = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "JoingGroupVC") as! JoingGroupVC
                    objJoinGroupVC.dicGroupDetail = dic
                    self.navigationController?.pushViewController(objJoinGroupVC, animated: true)
                }
                else
                {
                    let grpVcOBj = GroupVC.initViewController()
                    grpVcOBj.grpDetail = dic
                    grpVcOBj.isFromLeadingGrp = false
                    self.navigationController?.pushViewController(grpVcOBj, animated: true)
                }
            }
            else
            {
                if dic.object(forKey: kkeyisMember) as! Int == 1 && dic.object(forKey: kkeymemberStatus) as! Int == 1
                {
                    let grpVcOBj = GroupVC.initViewController()
                    grpVcOBj.grpDetail = dic
                    grpVcOBj.isFromLeadingGrp = false
                    self.navigationController?.pushViewController(grpVcOBj, animated: true)
                }
                else  if dic.object(forKey: kkeyisMember) as! Int == 1 && dic.object(forKey: kkeymemberStatus) as! Int == 0
                {
                    App_showAlert(withMessage: "You don't have permission to see Group Activity", inView: self)
                    
                }
                else if dic.object(forKey: kkeyisMember) as! Int == 0
                {
                    let objJoinGroupVC = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "JoingGroupVC") as! JoingGroupVC
                    objJoinGroupVC.dicGroupDetail = dic
                    self.navigationController?.pushViewController(objJoinGroupVC, animated: true)
                }
            }
        }
    }
}
