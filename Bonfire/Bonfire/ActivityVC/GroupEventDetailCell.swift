//
//  GroupEventDetailCell.swift
//  Bonfire
//
//  Created by Sanjay Makvana on 17/05/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class GroupEventDetailCell: UITableViewCell {
    @IBOutlet weak var downiconImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
