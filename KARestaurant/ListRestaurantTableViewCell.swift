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
import AlamofireImage

class ListRestaurantTableViewCell: MaterialTableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var restaurantDetailLabel: UILabel!
    
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
        
        
        
        self.userImageView.layer.cornerRadius = 10.0
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.borderWidth = 3.0
        self.userImageView.layer.borderColor = UIColor.blackColor().CGColor
        
        
        nameLabel.text = restaurant.name
        restaurantDetailLabel.text = restaurant.restDescription
        
        
        let imageURL = restaurant.thumbnail!
        
        
        Alamofire.request(.GET, imageURL)
            .responseImage { response in
                //debugPrint(response)
                
                // print(response.request)
                // print(response.response)
                // debugPrint(response.result)
                guard let image = response.result.value else { return }
                
                self.userImageView.image = image
                self.restaurantImageView.image = image
               
                // print("image downloaded: \(image)")
        }
        
    }
}



