//
//  EditRestaurantCollectionViewCell
//  KARestaurant
//
//  Created by Kokpheng on 6/7/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit

class EditRestaurantCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantMenuImageView: UIImageView!
    
    var restaurantMenu: Menu!
    var request: ImageRequest?
    
    
    func configureMenu(menu: Menu) {
        self.restaurantMenu = menu
        //reset()
        loadImage()
    }
    
    func reset() {
        restaurantImageView.image = nil
        restaurantMenuImageView.image = nil
        request?.cancel()
    }
    
    func loadImage() {
        let urlString = restaurantMenu.url!
        if let image = PhotosDataManager.sharedManager.cachedImage(urlString) {
            populateCell(image)
            return
        }
        downloadImage()
    }
    
    func downloadImage() {
        //  loadingIndicator.startAnimating()
        restaurantImageView.image = UIImage(named: "defaultPhoto")
        restaurantMenuImageView.image = UIImage(named: "defaultPhoto")
        let urlString = restaurantMenu.url!
        request = PhotosDataManager.sharedManager.getNetworkImage(urlString) { image in
            self.populateCell(image)
        }
    }
    
    func populateCell(image: UIImage) {
        restaurantImageView.image = image
        restaurantMenuImageView.image = image
    }
}