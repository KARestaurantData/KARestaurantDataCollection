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
   var request: ImageRequest?
    
    
    func configure(restaurant: Restaurants) {
        self.restaurant = restaurant
        reset()
        loadImage()
    }
    
    func reset() {
        userImageView.image = nil
        restaurantImageView.image = nil
        request?.cancel()
        nameLabel.hidden = true
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
        let urlString = restaurant.thumbnail!
        request = PhotosDataManager.sharedManager.getNetworkImage(urlString) { image in
            self.populateCell(image)
        }
    }
    
    func populateCell(image: UIImage) {
        //loadingIndicator.stopAnimating()
        
        self.userImageView.layer.cornerRadius = 10.0
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.borderWidth = 3.0
        self.userImageView.layer.borderColor = UIColor.blackColor().CGColor
        
        
        userImageView.image = image
        restaurantImageView.image = image
        nameLabel.text = restaurant.name
        restaurantDetailLabel.text = restaurant.restDescription
        nameLabel.hidden = false
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



