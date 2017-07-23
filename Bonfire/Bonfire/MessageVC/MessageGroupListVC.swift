//
//  MessageGroupListVC.swift
//  Bonfire
//
//  Created by Hardik on 21/06/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class MessageGroupListVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var msgArr = NSArray()
    var selectedIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnBackTap(_ sender: Any) {
        
        let grpname = self.msgArr[selectedIndex]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateSelectedGroup"), object: grpname)
      _ =  self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden  = true
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.tableview .reloadData()
        
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    static func initViewController() -> MessageGroupListVC {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "MessageGroupListView") as! MessageGroupListVC
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MessageGroupListVC : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = msgArr[indexPath.row] as! String

        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.msgArr.count
    }
    
    
}

