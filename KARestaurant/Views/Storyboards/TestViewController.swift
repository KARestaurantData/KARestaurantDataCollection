//
//  TestViewController.swift
//  KARestaurant
//
//  Created by Kokpheng on 6/7/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import ImageSlideshow

class TestViewController: UIViewController {

    @IBOutlet var slideshow: ImageSlideshow!
    var transitionDelegate: ZoomAnimatedTransitioningDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideshow.backgroundColor = UIColor.whiteColor()
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.UnderScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor();
        slideshow.pageControl.pageIndicatorTintColor = UIColor.blackColor();
        
        //        Local image example
        //
        //        slideshow.setImageInputs([ImageSource(imageString: "img1")!, ImageSource(imageString: "img2")!, ImageSource(imageString: "img3")!, ImageSource(imageString: "img4")!])
        
        
        //        AFURLSource example
        //
        //        slideshow.setImageInputs([AFURLSource(urlString: "https://thumbs.dreamstime.com/z/flysch-rocks-barrika-beach-sunset-58426273.jpg")!, AFURLSource(urlString: "https://thumbs.dreamstime.com/z/man-surfboard-beautiful-foggy-beach-boy-running-golden-sunrise-daytona-florida-58532550.jpg")!, AFURLSource(urlString: "https://thumbs.dreamstime.com/z/woman-putting-mask-her-face-black-cloak-sitting-ground-58291716.jpg")!])
        
        
        //        AlamofireSource example
        //
        slideshow.setImageInputs([AlamofireSource(urlString: "https://thumbs.dreamstime.com/z/flysch-rocks-barrika-beach-sunset-58426273.jpg")!, AlamofireSource(urlString: "https://thumbs.dreamstime.com/z/man-surfboard-beautiful-foggy-beach-boy-running-golden-sunrise-daytona-florida-58532550.jpg")!, AlamofireSource(urlString: "https://thumbs.dreamstime.com/z/woman-putting-mask-her-face-black-cloak-sitting-ground-58291716.jpg")!])
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TestViewController.click))
        slideshow.addGestureRecognizer(recognizer)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func click() {
        let ctr = FullScreenSlideshowViewController()
        // called when full-screen VC dismissed and used to set the page to our original slideshow
        ctr.pageSelected = {(page: Int) in
            self.slideshow.setScrollViewPage(page, animated: false)
        }
        
        // set the initial page
        ctr.initialPage = slideshow.scrollViewPage
        // set the inputs
        ctr.inputs = slideshow.images
        self.transitionDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: slideshow)
        ctr.transitioningDelegate = self.transitionDelegate
        self.presentViewController(ctr, animated: true, completion: nil)
    }


}
