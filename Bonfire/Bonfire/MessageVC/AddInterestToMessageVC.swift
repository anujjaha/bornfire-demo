//
//  AddInterestToMessageVC.swift
//  Bonfire
//
//  Created by Hardik on 23/06/17.
//  Copyright © 2017 Niyati. All rights reserved.
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
    
    var dictGrpDetailsTosend = [String:String]()

    var isfromProfile : Bool = false
    var isSearch : Bool = false
    var isFromGrp : Bool = false
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tabelview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabelview.dataSource  = self
        self.tabelview.delegate = self
        self.searchbar.delegate = self
        // Do any additional setup after loading the view.
        arrInterestWithId  = userDefaults .value(forKey: "allInterest") as! NSArray
        arrInterestAll = arrInterestWithId.value(forKey: "name") as! NSArray
        
//        arrInterestAll = ["interest1", "test", "allow", "interest4","interest5","demo","interest7","new","file","interest10","interest11"]
        
        arrTemp = self.arrInterestAll
        
        if isFromGrp {
            self.btnSave .setTitle("", for: .normal)
            self.btnSave .setImage(UIImage(named:"right_arrow"), for: .normal)
        }else {
            self.btnSave .setTitle("Save", for: .normal)
            self.btnSave .setImage(UIImage(named:""), for: .normal)
        }
        
    }
    @IBAction func backBtnTap(_ sender: Any) {
       _ =  self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func segmentvalueChange(_ sender: Any) {
       
        
        if self.segment.selectedSegmentIndex == 1 {
            
            self.arrInterestAll = self.arrInterestSelected
            
        } else{
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
    
    @IBAction func saveTap(_ sender: Any) {
        
        if isFromGrp {

            self .callCreateGroupAPI()
        
        } else {
            
            if !isfromProfile {
                
                NotificationCenter .default.post(name: NSNotification.Name(rawValue: "selectedInterest"), object: self.arrInterestSelectedId, userInfo: nil)
            }
            
            _ =  self.navigationController?.popViewController(animated: true)
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        self.title = "Select Interests"
    }
    override func viewWillDisappear(_ animated: Bool) {
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
    func callCreateGroupAPI(){
        
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kCreateGroup
        showProgress(inView: self.view)

        
        var imgData = Data()
        imgData = UIImageJPEGRepresentation(grpImage, 0.5)!
        
        
        
        
        let param = [
            "name" : name,
            "is_private": switchstr,
            ]
        
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        //        let imgData = UIImagePNGRepresentation(imageViewCoverPhoto.image!)
        
        
        upload(multipartFormData:{ multipartFormData in
            
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
        })
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
