//
//  ViewController.swift
//  JBDatePicker
//
//  Created by Joost van Breukelen on 09-10-16.
//  Copyright © 2016 Joost van Breukelen. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController, JBDatePickerViewDelegate {
    
    @IBOutlet weak var tableEvent: UITableView!
    @IBAction func leftArrowTap(_ sender: Any) {
         datePickerView.loadPreviousView()
    }
    
    @IBAction func rightArrowTap(_ sender: Any) {
         datePickerView.loadNextView()
    }
    @IBOutlet weak var lblMonName: UILabel!
    @IBOutlet weak var datePickerView: JBDatePickerView!
    
    var dateToSelect: Date!
    var eventArr = NSArray()
    var arrCurrentdateData = NSMutableArray()
    var dttoday = NSDate()
    
    
    static func initViewController() -> DatePickerViewController
    {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "datepickerview") as! DatePickerViewController
    }

    func rightSideBtntap(){
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Calendar"
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 35)
        let img = UIImage(named: "Daybar")
        button.setImage(img, for: .normal)
        button.setImage(img, for: .highlighted)
        
        button.addTarget(self, action: #selector(DatePickerViewController.rightSideBtntap), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = -20 // adjust as needed
        
        
        self.navigationItem.rightBarButtonItems = [barButton,space]
        self.tableEvent.dataSource  = self
       
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        // Do any additional setup after loading the view, typically from a nib.
        datePickerView.delegate = self
        
        //get presented month
//        self.navigationItem.title = datePickerView.presentedMonthView?.monthDescription
        
        //remove hairline under navigationbar
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "GreenPixel"), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
        
        
        let strdate = appDelegate.convertdatetoString(adte: NSDate())
        dttoday = appDelegate.convertStringtoDate(astrdate: strdate)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
//        UIApplication.shared.statusBarStyle = .lightContent
        showProgress(inView: self.view)

        self.callEventApi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .default
    }
    
    
    // MARK: - JBDatePickerViewDelegate
    
    func didSelectDay(_ dayView: JBDatePickerDayView) {

        print("date selected: \(String(describing: dayView.date))")
        
        self.arrCurrentdateData = NSMutableArray()

        for i in 0..<self.eventArr.count
        {
            let dict = self.eventArr[i] as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.date(from: (dict.value(forKey: "eventStartDate") as? String)!)! as NSDate
            
            if(date.equalToDate(dateToCompare: dayView.date! as NSDate))
            {
                self.arrCurrentdateData.add(dict)
            }
        }

        self.tableEvent.reloadData()

        //self.performSegue(withIdentifier: "unwindFromDatepicker", sender: self)
       // _ = self.navigationController?.popViewController(animated: true)
    }
    
    func didPresentOtherMonth(_ monthView: JBDatePickerMonthView) {
//        self.navigationItem.title = datePickerView.presentedMonthView.monthDescription
       let str =  datePickerView.presentedMonthView.monthDescription
        let index = str?.index((str?.startIndex)!, offsetBy: 3)
        let final = str?.substring(to:index!)
        self.lblMonName.text = final?.uppercased()
        self.lblMonName.textColor = UIColor(colorLiteralRed: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
    }
    
//    func shouldAllowSelectionOfDay(_ date: Date?) -> Bool {
//        
//        guard let date = date else {return true}
//        let comparison = NSCalendar.current.compare(date, to: Date().stripped()!, toGranularity: .day)
//        
//        if comparison == .orderedAscending {
//            return false
//        }
//        return true
// 
//    }

//    var colorForUnavaibleDay: UIColor {
//        return .blue
//    }
    
    var dateToShow: Date {
        
        if let date = dateToSelect {
            return date
        }
        else{
            return Date()
        }
    }
    
    var weekDaysViewHeightRatio: CGFloat {
        return 0.1
    }
    
    
    // MARK: - API call
    func callEventApi() {
        
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let userid = final .value(forKey: "userId")
        
        let url = kServerURL + kEvents
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
                        
                        if (temp.value(forKey: "error") != nil)
                        {
                            let msg = ((temp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
//                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            let data  = temp .value(forKey: "data") as! NSArray
                            if data.count > 0
                            {
                                print("no error")
                                self.eventArr = data
                                print("self.eventArr -> \(self.eventArr)")
                                
                                self.arrCurrentdateData = NSMutableArray()
                                
                                for i in 0..<self.eventArr.count
                                {
                                    let dict = self.eventArr[i] as! NSDictionary
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    let date = formatter.date(from: (dict.value(forKey: "eventStartDate") as? String)!)! as NSDate
                                    
                                    
                                    if(date.equalToDate(dateToCompare: self.dttoday))
                                    {
                                        self.arrCurrentdateData.add(dict)
                                    }
                                }
                                self.tableEvent.reloadData()
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
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    
//        if let startVC = segue.destination as? StartViewController {
//            if let selectedDate = datePickerView.selectedDateView.date {
//                startVC.date = selectedDate
//            }
//        }
//        
//    }
    
}


extension DatePickerViewController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DatePickerCell
        
//        let img = UIImage(named: "event_sltbar")
//        let imgview = UIImageView(image: img)
//        imgview.contentMode = UIViewContentMode.scaleAspectFill
//        cell.backgroundView = imgview
        
        let dict = self.arrCurrentdateData[indexPath.row] as! NSDictionary
        cell.eventTitle.text = dict.value(forKey: "eventName") as? String
        cell.eventTime.text = dict.value(forKey: "eventStartDate") as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter .date(from: cell.eventTime.text!)
    
        let formatternew = DateFormatter()
        formatternew.dateFormat = "hh:mm"
        let time = formatternew .string(from: date!)
        
        cell.eventTime.text = time
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrCurrentdateData.count
    }

}

class DatePickerCell : UITableViewCell
{
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    override func awakeFromNib() {
        
    }
}
