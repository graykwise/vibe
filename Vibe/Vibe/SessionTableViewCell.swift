//
//  SessionTableViewCell.swift
//  Vibe
//
//  Created by Grayson Wise on 6/21/17.
//  Copyright © 2017 Vibe. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var vibeImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
