//
//  MemberCell.swift
//  Bonfire
//
//  Created by ghoshit on 22/05/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class MemberCell: UICollectionViewCell {
    @IBOutlet weak var imgViewLeader: UIImageView!
    
    @IBOutlet weak var labelMemberName: UILabel!
    @IBOutlet weak var imgViewMember: UIImageView!
    @IBOutlet weak var labelLeaderName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
}
