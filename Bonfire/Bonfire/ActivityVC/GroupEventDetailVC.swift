//
//  GroupEventDetailVC.swift
//  Bonfire
//
//  Created by Sanjay Makvana on 13/05/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class GroupEventDetailVC: UIViewController {

    @IBOutlet weak var profileCollectonview: UICollectionView!
    @IBOutlet weak var channelTblView: UITableView!
    @IBOutlet weak var tableEventDesc: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableEventDesc .dataSource = self
        self.tableEventDesc .reloadData()
        tableEventDesc.separatorColor = UIColor .clear
        tableEventDesc.separatorStyle = UITableViewCellSeparatorStyle.none
        tableEventDesc.separatorInset = UIEdgeInsets.zero
        
        self.channelTblView .dataSource = self
        self.channelTblView .delegate = self
        self.channelTblView .reloadData()
        
        self.profileCollectonview.delegate = self
        self.profileCollectonview.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    @IBAction func channelTap(_ sender: Any) {
            }
    
    @IBAction func backTap(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: false)
        
    }
    @IBAction func buttonLeaveGrp(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    override  func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
    }
    static func initViewController() -> GroupEventDetailVC {
        return UIStoryboard(name: "Main2", bundle: nil).instantiateViewController(withIdentifier: "GroupEventDetailView") as! GroupEventDetailVC
    }

}

extension GroupEventDetailVC : UITableViewDataSource , UITableViewDelegate{
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.channelTblView {
            var isShowHeader = false
            if indexPath.row == 0 {
                isShowHeader = true
                
            }else{
                isShowHeader = false
            }
            
            let dict = [ "isShowHeader" : isShowHeader]
            let notificationName = Notification.Name("updateTopHeader")
            NotificationCenter.default.post(name: notificationName, object: dict)
            _ = self.navigationController?.popViewController(animated: false)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.channelTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GroupEventDetailCell
            cell.channelName.text = "Channel"
            
            if indexPath.row == 0{
                cell.downiconImage.isHidden = false
                cell.channelBadgeNo.isHidden = true
            } else {
                if indexPath.row == 1 {
                    cell.channelBadgeNo .setTitle("11", for: .normal)
                    cell.channelBadgeNo.backgroundColor = UIColor .init(colorLiteralRed: 255.0/255.0, green: 0.0/255.0, blue: 103.0/255.0, alpha: 1.0)
                    
                } else {
                    cell.channelBadgeNo .setTitle("", for: .normal)
                    cell.channelBadgeNo.backgroundColor = UIColor .clear
                }
                
                
                cell.channelBadgeNo.layer.cornerRadius = cell.channelBadgeNo.frame.height/2;
                cell.channelBadgeNo.isHidden = false
                cell.downiconImage.isHidden = true
            }
            
            cell.backgroundColor = UIColor .clear
            cell.channelBadgeNo .setTitleColor(UIColor.white, for: .normal)
            cell.selectionStyle = .none
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupEventDetailCell")
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    
}
extension GroupEventDetailVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "profileCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! profileCollectonviewCell
        
        cell.imgView.layer.cornerRadius = 11.0;
        cell.imgView.layoutIfNeeded() //This is important line
        //cell.imgView.layer.masksToBounds = true
        cell.imgView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let flowLayout = (collectionViewLayout as! UICollectionViewFlowLayout)
        let cellSpacing = flowLayout.minimumInteritemSpacing
        let cellWidth = flowLayout.itemSize.width
        let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
        
        let collectionViewWidth = collectionView.bounds.size.width
        
        let totalCellWidth = cellCount * cellWidth
        let totalCellSpacing = cellSpacing * (cellCount - 1)
        
        let totalCellsWidth = totalCellWidth + totalCellSpacing
        
        let edgeInsets = (collectionViewWidth - totalCellsWidth) / 2.0
        
        return edgeInsets > 0 ? UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets) : UIEdgeInsetsMake(0, cellSpacing, 0, cellSpacing)
    }
}

