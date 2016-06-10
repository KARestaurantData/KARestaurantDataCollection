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
    
    func setRestaurantImage(object: AnyObject){
        
        if object is String{
            self.restaurantImageView.kf_setImageWithURL(NSURL(string: "\(object)")!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
               // print(imageURL?.absoluteString)
            }
        }else if object is UIImage {
            self.restaurantImageView.image = object as? UIImage
        }
    }
    
    func setRestaurantMenuImage(object: AnyObject){
        
        if object is String{
            self.restaurantMenuImageView.kf_setImageWithURL(NSURL(string: "\(object)")!, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
                // print(imageURL?.absoluteString)
            }
        }else if object is UIImage {
            self.restaurantMenuImageView.image = object as? UIImage
        }
    }
}