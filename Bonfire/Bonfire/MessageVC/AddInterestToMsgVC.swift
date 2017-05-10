//
//  AddInterestToMsgVC.swift
//  Bonfire
//
//  Created by Sanjay Makvana on 09/05/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class AddInterestToMsgVC: UIViewController , HTagViewDelegate, HTagViewDataSource {

    @IBOutlet var tagViewInterest: HTagView!
    @IBOutlet var buttonBack: UIButton!
    
    @IBAction func addInterest(_ sender: Any) {
        
    }
    
    @IBAction func buttonBackTap(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        tagViewInterest.delegate = self
        tagViewInterest.dataSource = self
        tagViewInterest.multiselect = false
        tagViewInterest.marg = 0
        tagViewInterest.btwTags = 10
        tagViewInterest.btwLines = 8
        tagViewInterest.fontSize = 15
        //tagViewInterest.tagMainBackColor = UIColor(red: 204.0/255.0, green: 228.0/255.0, blue: 254.0/255.0, alpha: 1)
        tagViewInterest.tagMainTextColor = UIColor.black
       
        //tagViewInterest.tagSecondBackColor = UIColor(red: 204.0/255.0, green: 228.0/255.0, blue: 254.0/255.0, alpha: 1)
        tagViewInterest.tagSecondTextColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let tagViewInterest_data = ["# interest","# interest","# interest","# interest"]
//    var tagViewGroups_data = ["Group","Group","Group"]
    
    // MARK: - HTagViewDataSource
    func numberOfTags(_ tagView: HTagView) -> Int {
        switch tagView {
        case tagViewInterest:
            return tagViewInterest_data.count
//        case tagViewGroups:
//            return tagViewGroups_data.count
        default:
            return 0
        }
    }
    
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        switch tagView
        {
        case tagViewInterest:
            return tagViewInterest_data[index]
//        case tagViewGroups:
//            return tagViewGroups_data[index]
        default:
            return "???"
        }
    }
    
    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
        switch tagView
        {
        case tagViewInterest:
            return .select
//        case tagViewGroups:
//            return .select
        default:
            return .select
        }
    }
    
    // MARK: - HTagViewDelegate
    func tagView(_ tagView: HTagView, tagSelectionDidChange selectedIndices: [Int])
    {
        print("tag with indices \(selectedIndices) are selected")
    }
    
    func tagView(_ tagView: HTagView, didCancelTagAtIndex index: Int)
    {
        print("tag with index: '\(index)' has to be removed from tagView")
        //tagViewGroups_data.remove(at: index)
        tagView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
