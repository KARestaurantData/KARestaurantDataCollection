//
//  EditRestaurantCollectionViewCell
//  KARestaurant
//
//  Created by Kokpheng on 6/7/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import Kingfisher

class EditRestaurantCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantMenuImageView: UIImageView!
    
    var myImage: UIImage!
    
    var restaurantMenuImage: Menu!
    var restaurantImage: RestaurantImage!
    
    func setRestaurantMenuImage(menu: Menu) {
        self.restaurantMenuImageView.kf_setImageWithURL(NSURL(string: menu.url!)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: nil)

    }
    
    func setRestaurantImage(image: RestaurantImage) {
        self.restaurantImageView.kf_setImageWithURL(NSURL(string: image.url!)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func setImageWithUrl(url: AnyObject){
        
        if url is String{
            self.restaurantImageView.kf_setImageWithURL(NSURL(string: "\(url)")!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
               // print(imageURL?.absoluteString)
            }
        }else if url is UIImage {
            self.restaurantImageView.image = url as? UIImage
        }
    }
    
    func setMenuImageWithUrl(url: String){
        self.restaurantMenuImageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func setImage(image: UIImage) {
        self.restaurantImageView.image = UIImage(named: "Honeycrisp-Apple")
    }
}