//
//  GroupCell.swift
//  Bonfire
//
//  Created by ios user on 13/05/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnLink: UIButton!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var Const_LinkBtn_height: NSLayoutConstraint!
    @IBOutlet weak var imgofLink : UIImageView!
    @IBOutlet weak var Const_imgofLink_height: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.layer.cornerRadius = 20
        
        self.imgView.clipsToBounds = true
        // Initialization code
    }
    @IBOutlet weak var lblName: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
