//
//  RestaurantDetailCollectionViewCell.swift
//  KARestaurant
//
//  Created by Kokpheng on 6/7/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import Kingfisher
import ImageSlideshow
import Material

protocol menuImageDelegate {
    func presentViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}
class RestaurantDetailCollectionViewCell: UICollectionViewCell {
    var delegate : menuImageDelegate? = nil
    
    @IBOutlet weak var menuImageSlideshow: ImageSlideshow!
    var transitionDelegate: ZoomAnimatedTransitioningDelegate?
    
    var restaurantMenu: Menu!
    
    
    func configureMenu(menu: Menu) {
        self.restaurantMenu = menu
        reset()
        loadImageToCellImageSlideshow()
    }
    
    func reset() {
        //menuImageView.image = nil
    }
    
    func loadImageToCellImageSlideshow(){
        menuImageSlideshow.setImageInputs([ImageSource(image: UIImage(named: "loadingImage")!)])
        // Config ImageSlideShow and PageControl
        menuImageSlideshow.backgroundColor = MaterialColor.cyan.darken1
        menuImageSlideshow.contentScaleMode = UIViewContentMode.ScaleAspectFill
        menuImageSlideshow.pageControlPosition = PageControlPosition.InsideScrollView
        menuImageSlideshow.pageControl.currentPageIndicatorTintColor = UIColor.clearColor()
        menuImageSlideshow.pageControl.pageIndicatorTintColor = UIColor.clearColor()
        
        //  loadingIndicator.startAnimating()
        if let urlString = restaurantMenu.url {
            KingfisherManager.sharedManager.retrieveImageWithURL(NSURL(string: urlString)!, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                // Set image to slide show
                self.menuImageSlideshow.setImageInputs([ImageSource(image: image! as Image)])
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.restaurantMenuSlideshowClick))
                self.menuImageSlideshow.addGestureRecognizer(recognizer)
            })
            
            
        }else{
            menuImageSlideshow.setImageInputs([ImageSource(image: UIImage(named: "null")!)])
        }
        
        
    }
    
    func restaurantMenuSlideshowClick() {
        let ctr = FullScreenSlideshowViewController()
        // called when full-screen VC dismissed and used to set the page to our original slideshow
        ctr.pageSelected = {(page: Int) in
            self.menuImageSlideshow.setScrollViewPage(page, animated: false)
        }
        
        // set the initial page
        ctr.initialPage = menuImageSlideshow.scrollViewPage
        // set the inputs
        ctr.inputs = menuImageSlideshow.images
        self.transitionDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: menuImageSlideshow)
        ctr.transitioningDelegate = self.transitionDelegate
        
        if (delegate != nil){
            delegate?.presentViewController(ctr, animated: true, completion: nil)
        }
    }
    
    //    func downloadImage() {
    //        //  loadingIndicator.startAnimating()
    //        if let  urlString = restaurantMenu.url {
    //            self.menuImageView.kf_setImageWithURL(NSURL(string: urlString)!, placeholderImage: UIImage(named: "defaultPhoto"), optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
    //            }
    //        }else{
    //            self.menuImageView.image = UIImage(named: "null")
    //        }
    //    }
}


