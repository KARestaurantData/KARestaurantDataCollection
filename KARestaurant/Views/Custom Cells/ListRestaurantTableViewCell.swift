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
import SCLAlertView

class ListRestaurantTableViewCell: MaterialTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var restaurantDetailLabel: UILabel!
    
    @IBOutlet weak var editButton: MaterialPulseView!
    
    var restaurant: Restaurants!
    var request: ImageRequest?
    
    
    func configure(restaurant: Restaurants) {
        self.restaurant = restaurant
        reset()
        loadImage()
    }
    
    func reset() {
        request?.cancel()
        restaurantImageView.image = nil
        titleLabel.hidden = true
        deliveryLabel.hidden = true
        restaurantDetailLabel.hidden = true
        editButton.hidden = true
    }
    
    func loadImage() {
        if let  urlString = restaurant.thumbnail {
            if let image = PhotosDataManager.sharedManager.cachedImage(urlString) {
                populateCell(image)
                return
            }
        }else{
            populateCell(UIImage(named: "null")!)
        }
        
        downloadImage()
    }
    
    func downloadImage() {
        restaurantImageView.image = UIImage(named: "defaultPhoto")
        if let urlString = restaurant.thumbnail{
            request = PhotosDataManager.sharedManager.getNetworkImage(urlString) { image in
                self.populateCell(image)
            }
        }else{
            populateCell(UIImage(named: "null")!)
        }
        
    }
    
    func populateCell(image: UIImage) {
        
        restaurantImageView.image = image
        titleLabel.text = restaurant.name
        restaurantDetailLabel.text = restaurant.restDescription
        deliveryLabel.text = NSString.init(string: restaurant.isDeliver!).boolValue ? "Delivery" : "No Delivery"
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ListRestaurantTableViewCell.handleTap(_:)))
        
        self.editButton.addGestureRecognizer(gesture)
        
        editButton.image = UIImage(named: "defaultPhoto")
        
        
        editButton.depth = .Depth2
        
        titleLabel.hidden = false
        deliveryLabel.hidden = false
        restaurantDetailLabel.hidden = false
        editButton.hidden = false
    }

    func handleTap(sender: UITapGestureRecognizer) {
        let alert = SCLAlertView()
        alert.addButton("Edit", target:self, selector:#selector(self.firstButton))
        alert.addButton("Second Button") {
            print("Second button tapped")
        }
        alert.showSuccess("", subTitle: "kp")
        
    }
    
    func firstButton(){
        print(restaurant.name)
        

    }
    
}



