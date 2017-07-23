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
    @IBOutlet weak var clvwyour: UICollectionView!
    @IBOutlet weak var clvwDiscover: UICollectionView!
    @IBOutlet weak var clvwGroups: UICollectionView!
    @IBOutlet weak var scrlvMain: UIScrollView!
    
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

        
        let url = kServerURL + kGetAllFeed
        showProgress(inView: self.view)
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
                        let data  = temp .value(forKey: "data") as! NSArray
                        
                        if data.count > 0 {
                        
                            
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

extension DiscoverVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
}
