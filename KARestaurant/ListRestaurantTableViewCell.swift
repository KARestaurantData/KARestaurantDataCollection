//
//  ListRestaurantTableViewCell.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/31/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import Alamofire
import Material

class ListRestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topCardView: ImageCardView!
    
    var restaurant: Restaurants!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func  configureCell(restaurant: Restaurants) {
        self.restaurant = restaurant
        
        topCardView.divider = false
        topCardView.maxImageHeight = 130
        
        Alamofire.request(.GET, (self.restaurant.thumbnail == nil ? Constant.GlobalConstants.URL_BASE + "/resources/images/1444d819-cef0-4baf-a9e6-09109c08a2f7.jpg" : self.restaurant.thumbnail!))
            .responseImage { response in
                //debugPrint(response)
                
                // print(response.request)
                // print(response.response)
                // debugPrint(response.result)
                
                if let image = response.result.value {
                    self.topCardView.image = image
                    // print("image downloaded: \(image)")
                }
        }
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = self.restaurant.name
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regularWithSize(24)
        topCardView.titleLabel = titleLabel
        topCardView.titleLabelInset.top = 80
        
        // Star button.
        let img1: UIImage? = MaterialIcon.cm.star
        let btn1: IconButton = IconButton()
        btn1.pulseColor = MaterialColor.blueGrey.lighten1
        btn1.tintColor = MaterialColor.blueGrey.lighten1
        btn1.setImage(img1, forState: .Normal)
        btn1.setImage(img1, forState: .Highlighted)
        
        // Bell button.
        let img2: UIImage? = MaterialIcon.cm.bell
        let btn2: IconButton = IconButton()
        btn2.pulseColor = MaterialColor.blueGrey.lighten1
        btn2.tintColor = MaterialColor.blueGrey.lighten1
        btn2.setImage(img2, forState: .Normal)
        btn2.setImage(img2, forState: .Highlighted)
        
        // Share button.
        let img3: UIImage? = MaterialIcon.cm.share
        let btn3: IconButton = IconButton()
        btn3.pulseColor = MaterialColor.blueGrey.lighten1
        btn3.tintColor = MaterialColor.blueGrey.lighten1
        btn3.setImage(img3, forState: .Normal)
        btn3.setImage(img3, forState: .Highlighted)
        
        // Add buttons to right side.
        topCardView.rightButtons = [btn1, btn2, btn3]
        
    }
}
