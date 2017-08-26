//
//  AppDelegate.swift
//  Bonfire
//
//  Created by Kevin on 16/04/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate
{
    var window: UIWindow?
    var arrLoginData = NSDictionary()
    var arrInterestData = NSArray()
    var arrAllGrpData = NSArray()
    var bisUserProfile = Bool()
    var strDeviceToken = NSString()
    var bcalltoRefreshChannel = Bool()
    var bisUserLogout = Bool()
    var bUserCreatedGroup = Bool()
    
    static let shared = UIApplication.shared.delegate as! AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        strDeviceToken = "424442253525"

        //Push Notification Setting Code
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                
                // Enable or disable features based on authorization.
                if granted == true
                {
                    print("Allow")
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else
                {
                    print("Don't Allow")
                }
            }
        }
        else
        {
            // Fallback on earlier versions
//            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//            application.registerForRemoteNotifications()
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()

        }

        
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        //IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldHidePreviousNext = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        self.callGetAllCampusAPI()
        
        
        if (userDefaults.bool(forKey: kkeyisUserLogin))
        {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController")
            let nav = UINavigationController(rootViewController: homeViewController)
            
            appdelegate.window!.rootViewController = nav
        }
        else
        {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.isNavigationBarHidden = true
            appdelegate.window!.rootViewController = nav
        }
        
        
        UIApplication.shared.statusBarStyle = .default

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //MARK: Date Method
    func convertdatetoString(adte: NSDate) -> String
    {
        let date = adte
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:date as Date)
        print(dateString)
        return dateString
    }
    
    func convertStringtoDate(astrdate : String) -> NSDate
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        let date = dateFormatter.date(from: astrdate) //according to date format your date string
        return date! as NSDate
    }
    
    //MARK: Push Notification Service
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        print(deviceToken)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        strDeviceToken = deviceTokenString as NSString
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error fail -> \(error)")

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        print("Push Notification Info:>%@", userInfo)
        var apsInfo: [AnyHashable: Any]? = (userInfo["aps"] as? [AnyHashable: Any])
        let alert: NSDictionary? = (apsInfo?["alert"] as? NSDictionary)
        let state:UIApplicationState = application.applicationState
        if (state == UIApplicationState.active) // active --- forground
        {
            if alert != nil
            {
                let strmessage = alert!["body"] as! String
                App_showAlert(withMessage: strmessage, inView: (self.window?.rootViewController)!)
            }
        }        
    }

    //MARK: Function Calling
    func callGetAllCampusAPI() {

        
        let url = kServerURL + kCampus
        showProgress(inView: window?.rootViewController?.view)
        

        request(url, method: .get, parameters:nil).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            
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
                        
                        hideProgress()
                        if data.count > 0 {
                            let final = data[0] as! NSDictionary
                            if final.value(forKey: kkeyError) != nil {
                                //App_showAlert(withMessage: err as! String, inView: self)
                            }else {
                                print("no error")
                                UserDefaults.standard.set(data, forKey: "campusData")
                                
                            }
                        }
                        else
                        {
                          //  App_showAlert(withMessage: data[kkeyError]! as! String, inView: self)
                        }
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
        
        /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
         debugPrint(response)
         }*/
        
    }



    func allCampusUser() -> NSArray {
        
        if let dic = UserDefaults.standard.value(forKey: kkeyAllCampusUser) {
            let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSArray
            return final
        }
        return NSArray()
        
    }
    

    func getAllcampusUser() {
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        let url = kServerURL + kGetAllCampusUser
    
            
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
                                let data = NSKeyedArchiver.archivedData(withRootObject:data)
                                UserDefaults.standard.set(data, forKey: kkeyAllCampusUser)
                                
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
                    break
                }
            }
            
        }
        
}

extension NSDate
{
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isGreaterorEqualtoDate(dateToCompare: NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending || self.compare(dateToCompare as Date) == ComparisonResult.orderedSame
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }

    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate
    {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}


