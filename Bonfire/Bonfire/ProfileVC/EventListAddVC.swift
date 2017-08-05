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
    
    @IBOutlet weak var vwAddEvent: UIView!
    
    @IBOutlet weak var txtTitle : UITextField!
    @IBOutlet weak var tvDescription : UITextView!
    @IBOutlet weak var txtStartDate : UITextField!
    @IBOutlet weak var txtEndDate : UITextField!
    
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
                            let msg = ((temp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
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
        vwAddEvent.isHidden = false

    }

    //MARK: Add Event View
    @IBAction func SaveEventAction(_ sender: Any)
    {
        if (self.txtTitle.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter event title", inView: self)
        }
        else if (self.tvDescription.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter event description", inView: self)
        }
        else if (self.txtStartDate.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter event start date", inView: self)
        }
        else if (self.txtEndDate.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter event end date", inView: self)
        }
        else
        {
            // get all home feed api calling
            let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
            let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
            let url = kServerURL + kAddEvent
            showProgress(inView: self.view)
            let token = final .value(forKey: "userToken")
            let headers = ["Authorization":"Bearer \(token!)"]
            let param = [
                "name" : txtTitle.text!,
                "title" : tvDescription.text!,
                "start_date": txtStartDate.text!,
                "end_date" : txtEndDate.text!,
                "group_id" :  "\(dicGroupDetail.object(forKey: "groupId")!)"
            ]
            
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
                                    let msg = ((temp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                                    App_showAlert(withMessage: msg as! String, inView: self)

                               // App_showAlert(withMessage: temp.value(forKey: "error") as! String, inView: self)
                            }
                            else
                            {
                                let data  = temp .value(forKey: "data") as! NSDictionary
                                if data.count > 0
                                {
                                    App_showAlert(withMessage: "Event is Created Successfully", inView: self)
                                    self.vwAddEvent.isHidden = true
                                    self.txtTitle.text = ""
                                    self.txtStartDate.text = ""
                                    self.txtEndDate.text = ""
                                    self.tvDescription.text = ""
                                    self.getAllGrpEvents()
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
    }
    @IBAction func CancelEventAction(_ sender: Any)
    {
        vwAddEvent.isHidden = true
    }
    @IBAction func DateAndTimeClicked(_ sender: Any)
    {
        var strtitle = String()
        if (sender as AnyObject).tag == 1
        {
            strtitle = "Select Start Date"
        }
        else
        {
            strtitle = "Select End Date"
        }
        
        let datePicker = ActionSheetDatePicker(title: strtitle, datePickerMode: UIDatePickerMode.dateAndTime, selectedDate: NSDate() as Date!, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            if (sender as AnyObject).tag == 1
            {
                self.txtStartDate.text =  "\(value!)"
            }
            else
            {
                self.txtEndDate.text = "\(value!)"
            }
        
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: self.view)
//        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
        //datePicker.minimumDate = NSDate(timeInterval: -secondsInWeek, sinceDate: NSDate())
        //datePicker.maximumDate = NSDate(timeInterval: secondsInWeek, sinceDate: NSDate())
        
        datePicker?.show()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        let dict = self.arrGrpEvent .object(at: indexPath.row) as! NSDictionary

        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let alertView = UIAlertController(title: Application_Name, message: "Are you sure want to delete event?", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Yes", style: .default)
            { (action) in
                
                // get all home feed api calling
                let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
                let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
                let url = kServerURL + kDeleteEvent
                showProgress(inView: self.view)
                let token = final .value(forKey: "userToken")
                let headers = ["Authorization":"Bearer \(token!)"]
                let param = [
                    "event_id" :  "\(dict.value(forKey: "eventId")!)"
                ]
                
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
                                    let msg = ((temp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                                    App_showAlert(withMessage: msg as! String, inView: self)
                                }
                                else
                                {
                                    let data  = temp .value(forKey: "data") as! NSDictionary
                                    if data.count > 0
                                    {
                                        App_showAlert(withMessage: "Event Deleted Successfully", inView: self)
                                        self.getAllGrpEvents()
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
            alertView.addAction(OKAction)
            
            let CancelAction = UIAlertAction(title: "No", style: .default)
            {
                (action) in
            }
            alertView.addAction(CancelAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }

}
