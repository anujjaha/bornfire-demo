//
//  DiscoverVC.swift
//  Bonfire
//
//  Created by Yash on 29/04/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class DiscoverVC: UIViewController ,UIScrollViewDelegate
{
    @IBOutlet weak var clvwyour: UICollectionView!
    @IBOutlet weak var clvwDiscover: UICollectionView!
    @IBOutlet weak var clvwGroups: UICollectionView!
    @IBOutlet weak var scrlvMain: UIScrollView!
    
    var previousScrollViewYOffset: CGFloat = 0.0
    var currentOffset = CGFloat()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.clvwyour.dataSource = self
        scrlvMain.delegate = self
        
    }

    @IBAction func calwndarBtnTap(_ sender: Any) {
        let datepicker =  DatePickerViewController .initViewController()
        self.navigationController?.navigationBar.isTranslucent  = false
        self.navigationController?.pushViewController(datepicker, animated: true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if scrollView == scrlvMain {
            currentOffset = self.scrlvMain.contentOffset.y
            
            let scrollPos: CGFloat = clvwyour.contentOffset.y
            if scrollPos >= currentOffset {
                //Fully hide your toolbar
                UIView.animate(withDuration: 0.25, animations: {() -> Void in
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                })
            }
            else {
                //Slide it up incrementally, etc.
               
                UIView.beginAnimations("toggleNavBar", context: nil)
                UIView.setAnimationDuration(0.2)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                UIView.commitAnimations()
            }
        }
    }
    
    
    
    

}

extension DiscoverVC : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let identifier = "DiscoverCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! DiscoverCell
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods

extension DiscoverVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
}
