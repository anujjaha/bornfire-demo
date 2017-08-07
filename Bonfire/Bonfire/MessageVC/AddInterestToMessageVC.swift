//
//  AddInterestToMessageVC.swift
//  Bonfire
//
//  Created by Hardik on 23/06/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class AddInterestToMessageVC: UIViewController {

    var arrInterestAll = NSArray()
    var arrInterestSelected = NSMutableArray()
    var arrInterestSelectedId = NSMutableArray()
    var arrInterestSearching = NSArray()
    var arrTemp = NSArray()
    var arrInterestWithId = NSArray()
    
    
    var name = String()
    var switchstr = String()
    var grpImage = UIImage()
    var strGroupDescription = String()
    
    var dictGrpDetailsTosend = [String:String]()

    var isfromProfile : Bool = false
    var isSearch : Bool = false
    var isFromGrp : Bool = false
    var isfromChannel : Bool = false
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tabelview: UITableView!
    
    //MARK: API Calling
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
                if response.result.value != nil
                {
                    print(response.result.value!)
                    
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSArray
                        print("dictemp :> \(dictemp)")
                        let temp  = dictemp[0] as! NSDictionary
                        let data  = temp .value(forKey: "data") as! NSArray
                        //
                        if data.count > 0 {
                            
                            if let err  =  (data[0] as! NSDictionary).value(forKey: kkeyError)
                            {
                                App_showAlert(withMessage: err as! String, inView: self)
                            }
                            else
                            {
                                print("no error")
                                userDefaults .set(data, forKey: "allInterest")
                                userDefaults .synchronize()
                                
                                self.arrInterestWithId  = userDefaults .value(forKey: "allInterest") as! NSArray
                                self.arrInterestAll = self.arrInterestWithId.value(forKey: "name") as! NSArray
                                
                                self.tabelview .reloadData()
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tabelview.dataSource  = self
        self.tabelview.delegate = self
        self.searchbar.delegate = self
        // Do any additional setup after loading the view.
        if (UserDefaults.standard.object(forKey: "allInterest") as? NSArray) != nil
        {
            arrInterestWithId  = userDefaults .value(forKey: "allInterest") as! NSArray
            arrInterestAll = arrInterestWithId.value(forKey: "name") as! NSArray
        }
        else
        {
            // fetch interest here
            self .callInterestAPI()
        }
        
        arrTemp = self.arrInterestAll
        
        if isFromGrp
        {
//            self.btnSave .setTitle("", for: .normal)
//            self.btnSave .setImage(UIImage(named:"right_arrow"), for: .normal)
            self.btnSave .setTitle("Save", for: .normal)
            self.btnSave .setImage(UIImage(named:""), for: .normal)
        }
        else if isfromChannel
        {
            self.btnSave .setTitle("Save", for: .normal)
            self.btnSave .setImage(UIImage(named:""), for: .normal)
        }
        else
        {
            self.btnSave .setTitle("Save", for: .normal)
            self.btnSave .setImage(UIImage(named:""), for: .normal)
        }
    }
    @IBAction func backBtnTap(_ sender: Any) {
       _ =  self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func segmentvalueChange(_ sender: Any)
    {
        if self.segment.selectedSegmentIndex == 1
        {
            self.arrInterestAll = self.arrInterestSelected
        }
        else
        {
            self.arrInterestAll = arrTemp
        }
        self.tabelview .reloadData()
    }
    
    func addMemberToGrp() {
        
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        let userid = final .value(forKey: "userId")
        
        let url = kServerURL + kAddGrpMember
        
        showProgress(inView: self.view)
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .post, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                            //App_showAlert(withMessage: data[kkeyError]! as! String, inView: self)
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
    
    @IBAction func saveTap(_ sender: Any)
    {
        if isFromGrp
        {
            showProgress(inView: self.view)
            self .callCreateGroupAPI()
        }
        else if isfromChannel
        {
            self.btnSave .setTitle("Save", for: .normal)
            self.btnSave .setImage(UIImage(named:""), for: .normal)
            
            NotificationCenter .default.post(name: NSNotification.Name(rawValue: "selectedInterestforChannel"), object: self.arrInterestSelectedId, userInfo: nil)
            _ =  self.navigationController?.popViewController(animated: true)
        }
        else
        {
            if !isfromProfile
            {
                NotificationCenter .default.post(name: NSNotification.Name(rawValue: "selectedInterest"), object: self.arrInterestSelectedId, userInfo: nil)
                _ =  self.navigationController?.popViewController(animated: true)
             }
            else
            {
                /*
                    Add bulk Int
                    POST :  http://bonfire.dev/api/user-interest/add-bulk-interest
                 interest_id
                 */
                
                let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
                let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
                
                let url = kServerURL + kUserInterestUpdate
                showProgress(inView: self.view)
                let token = final .value(forKey: "userToken")
                let headers = ["Authorization":"Bearer \(token!)"]
                
                let strint = self.arrInterestSelectedId.componentsJoined(by: ",")
                let param = [
                    "interest_id": strint
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
                                print("dictProfile :> \(dictemp)")
                                let temp  = dictemp.firstObject as! NSDictionary
                                let data  = temp .value(forKey: "data") as! NSDictionary
                                
                                if data.count > 0
                                {
                                    if let err  =  data.value(forKey: kkeyError)
                                    {
                                        App_showAlert(withMessage: err as! String, inView: self)
                                    }
                                    else
                                    {
                                        let alertView = UIAlertController(title: Application_Name, message: "Interests Updated Successfully", preferredStyle: .alert)
                                        let OKAction = UIAlertAction(title: "OK", style: .default)
                                        { (action) in
                                            _ =  self.navigationController?.popViewController(animated: true)
                                        }
                                        alertView.addAction(OKAction)
                                        
                                        self.present(alertView, animated: true, completion: nil)
                                    }
                                }
                                else
                                {
                                    App_showAlert(withMessage: data[kkeyError]! as! String, inView: self)
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
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
        self.title = "Select Interests"
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
    }
    static func initViewController() -> AddInterestToMessageVC
    {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "AddInterestToMessageView") as! AddInterestToMessageVC
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func callCreateGroupAPI()
    {
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kCreateGroup

        var imgData = Data()
        imgData = UIImageJPEGRepresentation(grpImage, 0.5)!
        
        let strint = self.arrInterestSelectedId.componentsJoined(by: ",")
        
        let param = [
            "name" : name,
            "is_private": switchstr,
            "description": strGroupDescription,
            "interests": strint
        ]
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        
        upload(multipartFormData:
            { (multipartFormData) in
                
                multipartFormData.append(imgData, withName: "image", fileName: "test.jpg", mimeType: "image/jpeg")
                
                for (key, value) in param
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
        }, to: url, method: .post, headers: headers, encodingCompletion:
            {
                (result) in
                
                switch result
                {
                case .success(let upload, _, _):
                    upload.responseJSON
                        {
                            response in
                            hideProgress()

                            print(response.request) // original URL request
                            print(response.response) // URL response
                            print(response.data) // server data
                            print(response.result) // result of response serialization
                            
                            if let json = response.result.value
                            {
                                print("json :> \(json)")
                                let dictemp = json as! NSArray
                                print("dictemp Group Detail :> \(dictemp)")
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
                                        if let err  =  data.value(forKey: kkeyError)
                                        {
                                            App_showAlert(withMessage: err as! String, inView: self)
                                        }
                                        else
                                        {
                                            let optionMenu = UIAlertController(title: "Bonfire", message: "Group is Created Successfully", preferredStyle: .alert)
                                            
                                            let libraryAction = UIAlertAction(title: "OK", style: .default, handler:
                                            {
                                                (alert: UIAlertAction!) -> Void in
                                                
                                                let createGrpObj = SettingVC.initViewController()
                                                createGrpObj.grpDetail = NSMutableDictionary(dictionary: data)
                                                createGrpObj.bfromCreateGroup = true
                                                self.navigationController?.pushViewController(createGrpObj, animated: true)

                                                /*
                                                if let viewController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: kIdentifire_GroupTitleVC) as? GroupTitleVC
                                                {
                                                    self .navigationController?.pushViewController(viewController, animated: true)
                                                }*/
                                            })
                                            optionMenu.addAction(libraryAction)
                                            self.present(optionMenu, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                    }
                    
                case .failure(let encodingError):
                    hideProgress()
                    print(encodingError)
                }
                
        })

        
       /* upload(multipartFormData:{ multipartFormData in
         
            for (key, value) in param {
         
                multipartFormData.append((value.data(using: String.Encoding.utf8)!), withName: key)
            }
            
            
            let strint = self.arrInterestSelectedId.componentsJoined(by: ",")
            
            multipartFormData.append((strint.data(using: String.Encoding.utf8)!), withName: "interests")
            
            
            multipartFormData.append(imgData, withName: "image", fileName: "test.jpg", mimeType: "image/jpeg")
            
            
        },
               usingThreshold:UInt64.init(),
               to:url,
               method:.post,
               headers:headers,
               
               encodingCompletion: { encodingResult in
                
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    
                    upload.responseString(completionHandler: { (response) in
                        hideProgress()
                        debugPrint(response)
                        //                        let jsondata = response.result.value?.toJSON()
                        //                        let arr = jsondata as! Array<Any>
                        //                        let dict = arr.first as? Dictionary<String, AnyObject>
                        //                        (dict!["message"]!)
                        
                        
                        let optionMenu = UIAlertController(title: "Bonfire", message: "Group is Created Successfully", preferredStyle: .alert)
                        
                        // 2
                        let libraryAction = UIAlertAction(title: "OK", style: .default, handler: {
                            (alert: UIAlertAction!) -> Void in
                            
                            if let viewController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: kIdentifire_GroupTitleVC) as? GroupTitleVC
                            {
                                self .navigationController?.pushViewController(viewController, animated: true)
                            }
                            
                        })
                        
                        optionMenu.addAction(libraryAction)
                        self.present(optionMenu, animated: true, completion: nil)
                        
                    })
                case .failure(let encodingError):
                    hideProgress()
                    print(encodingError)
                }
        })*/
    }

}


extension AddInterestToMessageVC :UISearchBarDelegate {
    
    @available(iOS 2.0, *)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)  {
        
        if searchText == "" {
            isSearch = false
            
        } else {
            isSearch = true
            let predicate = NSPredicate(format:"SELF contains[c] %@", searchText)
            arrInterestSearching = self.arrInterestAll .filtered(using: predicate) as NSArray
        }
        
     
        self.tabelview .reloadData()
    }
    
    @available(iOS 3.0, *)
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool // called before text changes 
    {
        return true
    }
    
    @available(iOS 2.0, *)
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
    }
    
}

extension AddInterestToMessageVC :UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        if  isSearch {
            cell.textLabel?.text = arrInterestSearching[indexPath.row] as? String
           
            if arrInterestSearching.count > 0 && arrInterestSelected.count > 0 && arrInterestSelected.count > indexPath.row {
//                if self.arrInterestSearching .contains(self.arrInterestSelected[indexPath.row] as! String) {
//                    cell.accessoryType = .checkmark
//                } else {
//                    cell.accessoryType = .none
//                }
            } else {
                    cell.accessoryType = .none
            }
            
        } else {
            if self.segment.selectedSegmentIndex == 1 {
                cell.accessoryType = .none
            } else{
                if self.arrInterestSelected.count > 0  {
                    if self.arrInterestSelected .contains(self.arrInterestAll[indexPath.row] as! String){
                        cell.accessoryType = .checkmark
                    }else{
                        cell.accessoryType = .none
                    }
                }
            }
            
            
            cell.textLabel?.text = arrInterestAll[indexPath.row] as? String
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if self.segment.selectedSegmentIndex == 0 {
            if !self.arrInterestSelected .contains(self.arrInterestAll[indexPath.row] as! String) {
                self.arrInterestSelected.add(self.arrInterestAll[indexPath.row] as! String)
                
                let dict = self.arrInterestWithId .object(at: indexPath.row) as! NSDictionary
        
                self.arrInterestSelectedId .add(dict .value(forKey: "interestId"))
                
                
                tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
                
            } else{
                self.arrInterestSelected .remove(self.arrInterestAll[indexPath.row] as! String)
                
                
                let dict = self.arrInterestWithId .object(at: indexPath.row) as! NSDictionary
                
                self.arrInterestSelectedId .remove(dict .value(forKey: "interestId"))
                
                tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        if self.segment.selectedSegmentIndex == 0 {
            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  isSearch {
            return arrInterestSearching.count
        }
        return arrInterestAll.count
    }
    
}
