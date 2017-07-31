//
//  DiscoverVC.swift
//  Bonfire
//
//  Created by Yash on 29/04/17.
//  Copyright © 2017 Niyati. All rights reserved.
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

    func GetAllfeed() {
        
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary

        
        let url = kServerURL + kGetAppGroup
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
                        let data  = temp .value(forKey: "data") as! NSArray
                        
                        if data.count > 0 {
                            self.arrAllFeedData = data as! Array<Any>
                            AppDelegate .shared.arrAllGrpData = self.arrAllFeedData as NSArray
                            
                            

                            
                            let namePredicate = NSPredicate(format: "%K = %d", "isDiscovery",0)
                    
                            self.arrDiscovery = self.arrAllFeedData.filter { namePredicate.evaluate(with: $0) };
                            
                            
                            
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
            self.callForYouGrpFeed()
    
        }
        
    }
    
    
    func callForYouGrpFeed() {
        
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        
        let url = kServerURL + kGetForYouFeed
        DispatchQueue.main.async {
            showProgress(inView: self.view)
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
                    
                    if let json = response.result.value {
                        let dictemp = json as! NSArray
                        print("dictemp :> \(dictemp)")
                        let temp  = dictemp.firstObject as! NSDictionary
                        
                        if (temp.value(forKey: "error") != nil) {
                            let errdic = temp.value(forKey: "error") as! NSDictionary
//                            let msg = errdic .value(forKey: "reason") as? String
                            self.const_foryouCollview_height.constant = 0
                            self.cosnt_foryouLabel_height.constant = 0
                            
                            
                            
                        } else {
                            let data  = temp .value(forKey: "data") as! NSArray
                            
                            if data.count > 0 {
                                
                                self.arrForYouGrp = data as! Array<Any>
                                
                                self.const_foryouCollview_height.constant = 220
                                self.cosnt_foryouLabel_height.constant = 21
                              
                                
                                
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
                            else {
                                
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
            
            
        }
        
    }
    
    
    
    @IBAction func calwndarBtnTap(_ sender: Any) {
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
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if scrollView == scrlvMain {
            currentOffset = self.scrlvMain.contentOffset.y
            
            let scrollPos: CGFloat = clvwyour.contentOffset.y
            if scrollPos >= currentOffset {
                //Fully hide your toolbar
                UIView.animate(withDuration: 0.25, animations: {() -> Void in
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                })
            }
            else {
                //Slide it up incrementally, etc.
               
                UIView.beginAnimations("toggleNavBar", context: nil)
                UIView.setAnimationDuration(0.2)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                UIView.commitAnimations()
            }
        }
    }

}

extension DiscoverVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if  collectionView == self.clvwDiscover {
            return self.arrDiscovery.count
        } else if(collectionView == self.clvwGroups) {
            return self.arrAllFeedData.count
        } else{
            return self.arrForYouGrp.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "DiscoverCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! DiscoverCell
        
        if  collectionView == self.clvwDiscover {

            let dic = self.arrDiscovery[indexPath.row] as! NSDictionary
            let strurl = dic["groupImage"] as! String
            let url  = URL.init(string: strurl)
            cell.imageView.sd_setImage(with: url, placeholderImage: nil)

            
        } else if(collectionView == self.clvwGroups) {
            print("test")
            
            let dic = self.arrAllFeedData[indexPath.row] as! NSDictionary
            let strurl = dic["groupImage"] as! String
            let url  = URL.init(string: strurl)
            cell.imageView.sd_setImage(with: url, placeholderImage: nil)
        } else{
            print("test1")
            
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
        if  collectionView == self.clvwDiscover {
            
             dic = self.arrDiscovery[indexPath.row] as! NSDictionary
    
            
        } else if(collectionView == self.clvwGroups) {
            print("test")
             dic = self.arrAllFeedData[indexPath.row] as! NSDictionary
            
        } else{
            print("test1")
            
            dic = self.arrForYouGrp[indexPath.row] as! NSDictionary
        }
        
        let grpVcOBj = GroupVC.initViewController()
        grpVcOBj.grpDetail = dic
        grpVcOBj.isFromLeadingGrp = false
        self.navigationController?.pushViewController(grpVcOBj, animated: true)
        
    }
}
