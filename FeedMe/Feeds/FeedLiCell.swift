//
//  FeedLiCell.swift
//  FeedMe
//
//  Created by Alice on 4/14/19.
//  Copyright © 2019 Alice Q Wong. All rights reserved.
//

import UIKit

class FeedLiCell: UITableViewCell {
    
    @IBOutlet var url : UILabel!
    @IBOutlet var title : UILabel!
    @IBOutlet var lastUpdate : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
