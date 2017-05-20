
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

        UIApplication.shared.isStatusBarHidden = true
        
        for index in 0..<4
        {
            frame.origin.x = self.scrvw.frame.size.width * CGFloat(index)
            frame.size = self.scrvw.frame.size
            
            let myImageView:UIImageView = UIImageView()
            myImageView.frame = self.frame
            myImageView.image =  UIImage(named: "login_bg")!
            self.scrvw.addSubview(myImageView)
            
            let myiconImgView:UIImageView = UIImageView()
            myiconImgView.frame = CGRect(x:(frame.origin.x+(frame.size.width/2))-55 , y:(frame.size.height/2)-120, width:100,height:120)
            myiconImgView.contentMode = .scaleAspectFit
            
            let lblText:UILabel = UILabel(frame: CGRect(x:frame.origin.x + 30 , y:frame.size.height-200, width:frame.size.width-60,height:60))
            switch index
            {
            case 0:
                lblText.text = "Discover New Groups"
                myiconImgView.image =  UIImage(named: "Rocket_tourGuide")!

                break
            case 1:
                lblText.text = "Stay Updated on Campus"
                myiconImgView.image =  UIImage(named: "Bonfire_tourGuide")!
                break
            case 2:
                lblText.text = "Lead and be active in groups"
                myiconImgView.image =  UIImage(named: "Penny Farthing_tourGuide")!
                break
            case 3:
                lblText.text = "Keep of a profile of your groups and interests"
                myiconImgView.image =  UIImage(named: "Monocle_tourGuide")!
                break
            default:
                break
            }
            lblText.numberOfLines = 2
            lblText.textColor = UIColor.white
            lblText.textAlignment = .center
            lblText.font = UIFont(name: "Cabin-Bold", size: 24)
            
            self.scrvw.addSubview(myiconImgView)
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
    
    override func viewWillDisappear(_ animated: Bool)     {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    //MARK: Paging Methods
    func changePage(sender: AnyObject) -> ()
    {
        let x = CGFloat(pgControl.currentPage) * self.scrvw.frame.size.width
        self.scrvw.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
   /* func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    {
        // The case where I used this, the x-coordinate was relevant. You may be concerned with the y-coordinate--I'm not sure
        let pageNumber = Int(scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.frame.size.width))
       
        let percent: CGFloat = (CGFloat(pageNumber)) / self.scrvw.frame.size.width
        if percent > 0.0 && percent < 1.0 {
            // Of course, you can specify your own range of alpha values
            self.scrvw.alpha = percent + 0.1
        }
    }*/

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
//        self.scrvw.alpha = 1.0
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pgControl.currentPage = Int(pageNumber)
    }
    
    @IBAction func gotoTabbar(sender: UIButton)
    {
        UIApplication.shared.isStatusBarHidden = false
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
