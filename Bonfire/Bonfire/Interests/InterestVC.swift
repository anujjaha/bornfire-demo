//
//  InterestVC.swift
//  Bonfire
//
//  Created by Yash on 29/04/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class InterestVC: UIViewController
{
   var interestData = NSArray()
    
    @IBOutlet weak var const_bottomView_Height: NSLayoutConstraint!
    @IBOutlet weak var clvwInterest: UICollectionView!
    var isFromSetting : Bool = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.callInterestAPI()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromSetting {
            self.const_bottomView_Height.constant = 0
        }
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.isTranslucent = false
        let imag = UIImage(named: "event_sltbar")
        self.navigationController?.navigationBar.setBackgroundImage(imag, for: .default)
        
        self.title = "Tap on your interests"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PrevBtnTap(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func forwardBtnTap(_ sender: Any) {
        
    }

    func callAddInterestAPIWith(interestId: Int) {
        
        let url = kServerURL + kAddInterest
        showProgress(inView: self.view)
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let usertoken = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(usertoken!)"]
        let param = ["interest_id":"\(interestId)"]
        
        request(url, method: .post, parameters:param, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                        let temp  = dictemp[0] as! NSDictionary
                        let data  = temp .value(forKey: "data") as! NSDictionary
                        //
                        if data.count>0 {
                            
                            if let err  =  data.value(forKey: kkeyError) {
                                App_showAlert(withMessage: err as! String, inView: self)
                            }else {
                                print("no error")
                                
                                if self.isFromSetting {
                                  _ = self.navigationController?.popViewController(animated: true)
                                }else {
                                    let storyTab = UIStoryboard(name: "Main", bundle: nil)
                                    let objTourGuideVC = storyTab.instantiateViewController(withIdentifier: "TourGuideVC") as! TourGuideVC
                                    self.navigationController?.pushViewController(objTourGuideVC, animated: true)
                                }
                            }
                            
                        }
                        else
                        {
                            App_showAlert(withMessage: (data[0] as! NSDictionary).value(forKey: kkeyError) as! String, inView: self)
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
        
        /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
         debugPrint(response)
         }*/
        
    }
    
    func callInterestAPI() {
        
        let url = kServerURL + kInterest
        showProgress(inView: self.view)
                let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
                let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let usertoken = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(usertoken)"]
        
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
                        let temp  = dictemp[0] as! NSDictionary
                        let data  = temp .value(forKey: "data") as! NSArray
//
                        if data.count > 0 {
                            
                            if let err  =  (data[0] as! NSDictionary).value(forKey: kkeyError) {
                                App_showAlert(withMessage: err as! String, inView: self)
                            }else {
                                print("no error")
                                self.interestData = data
                                userDefaults .set(data, forKey: "allInterest")
                                userDefaults .synchronize()
                                self.clvwInterest.dataSource = self;
                                self.clvwInterest.delegate = self;
                                self.clvwInterest .reloadData()
                            }
                            
                        }
                        else
                        {
                            App_showAlert(withMessage: (data[0] as! NSDictionary).value(forKey: kkeyError) as! String, inView: self)
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
        
        /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
         debugPrint(response)
         }*/
        
    }
    static func initViewController() -> InterestVC {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "InterestView") as! InterestVC
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
extension InterestVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.interestData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    
        // call interest update api here
        let interestdata =  self.interestData[indexPath.row] as! NSDictionary
        let intId = interestdata .value(forKey: "interestId")
        
       callAddInterestAPIWith(interestId: intId as! Int)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! InterestCell
        
    
        if let url = (self.interestData[indexPath.row] as! NSDictionary) .value(forKey: "image") {
            cell.imgview.sd_setImage(with:URL(string: url as! String), placeholderImage:nil)
           
        }else {
            cell.imgview.image = UIImage(named: "")
        }
        cell.lblInterestName.text  = (self.interestData[indexPath.row] as! NSDictionary) .value(forKey: "name") as! String?
        
        return cell
    }
    
}
