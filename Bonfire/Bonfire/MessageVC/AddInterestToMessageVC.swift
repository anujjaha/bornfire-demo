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
    
    @IBAction func saveTap(_ sender: Any) {
        if isFromGrp {
            if let viewController = UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: kIdentifire_GroupTitleVC) as? GroupTitleVC
            {
                self .navigationController?.pushViewController(viewController, animated: true)
            }

        } else {
            NotificationCenter .default.post(name: NSNotification.Name(rawValue: "selectedInterest"), object: self.arrInterestSelectedId, userInfo: nil)
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
