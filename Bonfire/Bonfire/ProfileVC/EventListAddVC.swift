//
//  EventListAddVC.swift
//  Bonfire
//
//  Created by Yash on 04/08/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class EventListAddVC: UIViewController
{
    var arrGrpEvent = NSMutableArray()
    var dicGroupDetail = NSDictionary()
    @IBOutlet weak var tableEventDesc: UITableView!

    /*
    @IBOutlet weak var txtDate = UITextField()
    @IBOutlet weak var txtTitle = UITextField()
    @IBOutlet weak var tvDescription = UITextView()
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getAllGrpEvents()
    }
    
    func getAllGrpEvents()
    {
        // get all home feed api calling
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let url = kServerURL + kGetGrpEvents
        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let param = ["group_id" :  "\(dicGroupDetail.object(forKey: "groupId")!)"]
        
        request(url, method: .post, parameters:param, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                        }
                        else
                        {
                            let data  = temp .value(forKey: "data") as! NSArray
                            
                            if data.count > 0
                            {
                                print(data)
                                self.arrGrpEvent = NSMutableArray(array: data)
                                self.tableEventDesc .reloadData()
                            }
                            else
                            {
                                //                            App_showAlert(withMessage: data[kkeyError]! as! String, inView: self)
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


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backBtnTap(_ sender: Any)
    {
        _ =  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTap(_ sender: Any)
    {
        
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
extension EventListAddVC : UITableViewDataSource , UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupEventDetailCell") as! grpEventCell
        let dict = self.arrGrpEvent .object(at: indexPath.row) as! NSDictionary
        cell.lblDescription.text = dict .value(forKey: "eventName") as! String?
        cell.lblMonName.text = dict .value(forKey: "eventMonth") as! String?
        cell.lblDayName.text = dict .value(forKey: "eventDate") as! String?
        cell.lblEventTitle.text = dict .value(forKey: "eventTitle") as! String?
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrGrpEvent.count
    }
}
