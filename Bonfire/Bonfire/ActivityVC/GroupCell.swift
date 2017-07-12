//
//  GroupCell.swift
//  Bonfire
//
//  Created by ios user on 13/05/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var btnLink: UIButton!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var Const_LinkBtn_height: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView.layer.cornerRadius = self.imgView.frame.height/2
        
        self.imgView.clipsToBounds = true
        // Initialization code
    }
    @IBOutlet weak var lblName: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
