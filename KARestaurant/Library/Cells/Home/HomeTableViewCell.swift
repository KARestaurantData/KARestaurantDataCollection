//
//  HomeTableViewCell.swift
//  KARestaurant
//
//  Created by Kokpheng on 7/8/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var argumentTitleLabel: UILabel!
    @IBOutlet weak var argumentDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
   
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
