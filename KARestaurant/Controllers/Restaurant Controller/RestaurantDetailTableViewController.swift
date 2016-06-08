//
//  RestaurantDetailTableViewController.swift
//  KARestaurant
//
//  Created by Kokpheng on 6/7/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import ImageSlideshow

class RestaurantDetailTableViewController: UITableViewController, UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var restaurantSlideshow: ImageSlideshow!
    var transitionDelegate: ZoomAnimatedTransitioningDelegate?
    
    @IBOutlet weak var menuCollectionview: UICollectionView!
    @IBOutlet weak var restaurantDetailLabel: UILabel!
    /*
     This value is either passed by `RestaurantTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new meal.
     */
    var restaurant: Restaurants?
    
    var restuarantImageArray = [AlamofireSource]();
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.menuCollectionview.delegate=self
        self.menuCollectionview.dataSource=self
        
        restaurantSlideshow.backgroundColor = UIColor.whiteColor()
        restaurantSlideshow.slideshowInterval = 5.0
        restaurantSlideshow.pageControlPosition = PageControlPosition.UnderScrollView
        restaurantSlideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor();
        restaurantSlideshow.pageControl.pageIndicatorTintColor = UIColor.blackColor();
        
        self.restaurantDetailLabel.text = restaurant?.restDescription
        for restImage in (restaurant?.images)! {
            restuarantImageArray.append(AlamofireSource(urlString: restImage.url!)!)
        }
        
        restaurantSlideshow.setImageInputs(restuarantImageArray)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(RestaurantDetailTableViewController.click))
        restaurantSlideshow.addGestureRecognizer(recognizer)
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func click() {
        let ctr = FullScreenSlideshowViewController()
        // called when full-screen VC dismissed and used to set the page to our original slideshow
        ctr.pageSelected = {(page: Int) in
            self.restaurantSlideshow.setScrollViewPage(page, animated: false)
        }
        
        // set the initial page
        ctr.initialPage = restaurantSlideshow.scrollViewPage
        // set the inputs
        ctr.inputs = restaurantSlideshow.images
        self.transitionDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: restaurantSlideshow)
        ctr.transitioningDelegate = self.transitionDelegate
        self.presentViewController(ctr, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    //MARK: collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurant?.menus?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuCellIdentifier", forIndexPath: indexPath) as! RestaurantDetailCollectionViewCell
        
        cell.configureMenu((restaurant?.menus![indexPath.row])!)
        
        return cell
    }
}
