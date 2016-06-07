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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var restaurantDetailLabel: UILabel!
    
    var restaurant: Restaurants!
    var request: ImageRequest?
    
    
    func configure(restaurant: Restaurants) {
        self.restaurant = restaurant
        reset()
        loadImage()
    }
    
    func reset() {
        restaurantImageView.image = nil
        request?.cancel()
        titleLabel.hidden = true
        deliveryLabel.hidden = true
        restaurantDetailLabel.hidden = true
    }
    
    func loadImage() {
        let urlString = restaurant.thumbnail!
        if let image = PhotosDataManager.sharedManager.cachedImage(urlString) {
            populateCell(image)
            return
        }
        downloadImage()
    }
    
    func downloadImage() {
        //  loadingIndicator.startAnimating()
        restaurantImageView.image = UIImage(named: "defaultPhoto")
        let urlString = restaurant.thumbnail!
        request = PhotosDataManager.sharedManager.getNetworkImage(urlString) { image in
            self.populateCell(image)
        }
    }
    
    func populateCell(image: UIImage) {
        //loadingIndicator.stopAnimating()
        //
        //        self.userImageView.layer.cornerRadius = 10.0
        //        self.userImageView.clipsToBounds = true
        //        self.userImageView.layer.borderWidth = 3.0
        //        self.userImageView.layer.borderColor = UIColor.blackColor().CGColor
        //
        
        restaurantImageView.image = image
        titleLabel.text = restaurant.name
        restaurantDetailLabel.text = restaurant.restDescription
        deliveryLabel.text = NSString.init(string: restaurant.isDeliver!).boolValue ? "Delivery" : "No Delivery"
        titleLabel.hidden = false
        deliveryLabel.hidden = false
        restaurantDetailLabel.hidden = false
    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //    }
    //
    //    override func awakeFromNib() {
    //        super.awakeFromNib()
    //        // Initialization code
    //    }
    //
    //    override func setSelected(selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //        
    //        // Configure the view for the selected state
    //    }
    
}



