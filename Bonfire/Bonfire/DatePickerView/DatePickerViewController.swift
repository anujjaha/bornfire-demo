//
//  ViewController.swift
//  JBDatePicker
//
//  Created by Joost van Breukelen on 09-10-16.
//  Copyright © 2016 Joost van Breukelen. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate
{
    @IBOutlet weak var tableEvent: UITableView!
    @IBOutlet weak var calendarFS: FSCalendar!
    let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
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
    override func viewDidLoad()
    {
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
        
        //get presented month
//        self.navigationItem.title = datePickerView.presentedMonthView?.monthDescription
        
        //remove hairline under navigationbar
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "GreenPixel"), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage(named: "TransparentPixel")
        
        let strdate = appDelegate.convertdatetoString(adte: NSDate())
        dttoday = appDelegate.convertStringtoDate(astrdate: strdate)
        
        //FSCalendar
        self.calendarFS.dataSource = self
        self.calendarFS.delegate = self

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
//        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.isHidden = false
        showProgress(inView: self.view)
        self.callEventApi()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
//        UIApplication.shared.statusBarStyle = .default
    }
    
    //MARK: FSCalendar Delegates
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        print("calendar did select date \(self.formatter.string(from: date))")

        if monthPosition == .previous || monthPosition == .next
        {
            calendar.setCurrentPage(date, animated: true)
        }
        
        self.arrCurrentdateData = NSMutableArray()
        for i in 0..<self.eventArr.count
        {
            let dict = self.eventArr[i] as! NSDictionary
            let newformatter = DateFormatter()
            newformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStart = newformatter.date(from: (dict.value(forKey: "eventStartDate") as? String)!)!
            let datsting = formatter.string(from: dateStart)
            
            if datsting == self.formatter.string(from: date)
            {
                self.arrCurrentdateData.add(dict)
            }
        }
        self.tableEvent.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int
    {
        for i in 0..<self.eventArr.count
        {
            let dict = self.eventArr[i] as! NSDictionary
            let newformatter = DateFormatter()
            newformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStart = newformatter.date(from: (dict.value(forKey: "eventStartDate") as? String)!)!
            let datsting = formatter.string(from: dateStart)
            
            if datsting == self.formatter.string(from: date)
            {
                return 1
            }
        }
       return 0

    /*    let day: Int! = self.gregorian.component(.day, from: date)
        print("\(day % 5 == 0 ? day/5 : 0)")
        return day % 5 == 0 ? 1 : 0;*/
    }

    // MARK: - API call
    func callEventApi()
    {
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
            
            self.calendarFS.reloadData()

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
