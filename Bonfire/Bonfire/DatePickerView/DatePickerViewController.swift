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
    
    static func initViewController() -> DatePickerViewController
    {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "datepickerview") as! DatePickerViewController
    }

    func rightSideBtntap(){
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let rightBtn = UIBarButtonItem(image: UIImage(named: "Daybar"), style: .plain, target: self, action: #selector(DatePickerViewController.rightSideBtntap))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    // MARK: - JBDatePickerViewDelegate
    
    func didSelectDay(_ dayView: JBDatePickerDayView) {

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
        
        cell.eventTime.text = "11:30"
        cell.eventTitle.text =  "Event title"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }

}

class DatePickerCell : UITableViewCell
{
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    override func awakeFromNib() {
        
    }
}
