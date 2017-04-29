
//
//  TourGuideVC.swift
//  Bonfire
//
//  Created by Yash on 29/04/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class TourGuideVC: UIViewController,UIScrollViewDelegate
{
    var scrvw = UIScrollView()
    @IBOutlet weak var pgControl : UIPageControl!
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.scrvw = UIScrollView(frame: CGRect(x:0, y:0, width:MainScreen.width,height: MainScreen.height))
        pgControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        self.pgControl.numberOfPages = 4
        self.pgControl.currentPage = 0
        self.scrvw.isPagingEnabled = true
        self.scrvw.delegate = self
        self.scrvw.showsHorizontalScrollIndicator = false
        self.scrvw.showsVerticalScrollIndicator = false
        self.view.addSubview(self.scrvw)
        self.view.bringSubview(toFront: self.pgControl)

        for index in 0..<4
        {
            frame.origin.x = self.scrvw.frame.size.width * CGFloat(index)
            frame.size = self.scrvw.frame.size
            
            let myImageView:UIImageView = UIImageView()
            myImageView.image =  UIImage(named: "login_bg")!
            myImageView.frame = self.frame
            self.scrvw.addSubview(myImageView)
            
            let lblText:UILabel = UILabel(frame: CGRect(x:frame.origin.x + 30 , y:frame.size.height-180, width:frame.size.width-60,height:60))
            switch index
            {
            case 0:
                lblText.text = "Discover New Groups"
                break
            case 1:
                lblText.text = "Stay Updated on Campus"
                break
            case 2:
                lblText.text = "Lead and be active in groups"
                break
            case 3:
                lblText.text = "Keep of a profile of your groups and interests"
                break
            default:
                break
            }
            lblText.numberOfLines = 2
            lblText.textColor = UIColor.white
            lblText.textAlignment = .center
            lblText.font = UIFont(name: "Cabin-Bold", size: 24)
            self.scrvw.addSubview(lblText)
            
            if(index == 3)
            {
                let btngotoTabbar:UIButton = UIButton(frame: CGRect(x:(frame.origin.x + (frame.size.width/2)-20), y:frame.size.height-120, width:40,height: 40))
                btngotoTabbar.backgroundColor = UIColor.clear
                btngotoTabbar.setImage(UIImage(named: "white_right_arrow"), for: .normal)
                btngotoTabbar.addTarget(self, action: #selector(self.gotoTabbar(sender:)), for: .touchUpInside)
                self.scrvw.addSubview(btngotoTabbar)
            }
        }

        self.scrvw.contentSize = CGSize(width:self.scrvw.frame.size.width * 4,height: self.scrvw.frame.size.height)
    }
    
    //MARK: Paging Methods
    func changePage(sender: AnyObject) -> ()
    {
        let x = CGFloat(pgControl.currentPage) * self.scrvw.frame.size.width
        self.scrvw.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pgControl.currentPage = Int(pageNumber)
    }
    
    @IBAction func gotoTabbar(sender: UIButton)
    {
        UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
        UserDefaults.standard.synchronize()
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
        self.navigationController?.pushViewController(tabbar, animated: true)
    }


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
