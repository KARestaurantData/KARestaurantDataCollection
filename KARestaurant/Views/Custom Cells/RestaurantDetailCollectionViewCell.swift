//
//  RestaurantDetailCollectionViewCell.swift
//  KARestaurant
//
//  Created by Kokpheng on 6/7/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit

class RestaurantDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    
    var restaurantMenu: Menu!
    
    
    func configureMenu(menu: Menu) {
        self.restaurantMenu = menu
        reset()
        downloadImage()
    }
    
    func reset() {
        menuImageView.image = nil
    }
    
   
    
    func downloadImage() {
        //  loadingIndicator.startAnimating()
        if let  urlString = restaurantMenu.url {
            self.menuImageView.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: UIImage(named: "defaultPhoto"), optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
            }
        }else{
            self.menuImageView.image = UIImage(named: "null")
        }
    }
}


