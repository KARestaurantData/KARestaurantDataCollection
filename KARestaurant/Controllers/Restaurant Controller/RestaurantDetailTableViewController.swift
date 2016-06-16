//
//  RestaurantDetailTableViewController.swift
//  KARestaurant
//
//  Created by Kokpheng on 6/7/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import ImageSlideshow
import GoogleMaps

class RestaurantDetailTableViewController: UITableViewController, UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource {
    // MARK: Property
    // ImageSlideShow Property
    @IBOutlet var restaurantSlideshow: ImageSlideshow!
    var transitionDelegate: ZoomAnimatedTransitioningDelegate?
    var restuarantImageArray = [AlamofireSource]();
    
    // RestaurantDetail outlet
    @IBOutlet weak var menuCollectionview: UICollectionView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantPhoneNumberLabel: UILabel!
    @IBOutlet weak var restaurantDeliveryLabel: UILabel!
    @IBOutlet weak var restaurantDetailLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    
    @IBOutlet weak var googleMapView: UIView!
    
    var myheigh : CGFloat = 0
    /*
     This value is either passed by `RestaurantTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new meal.
     */
    var restaurant: Restaurant?
    
     // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView Delegate
        self.menuCollectionview.delegate=self
        self.menuCollectionview.dataSource=self
        
        
        // Config ImageSlideShow and PageControl
        restaurantSlideshow.backgroundColor = UIColor.whiteColor()
        restaurantSlideshow.slideshowInterval = 5.0
        restaurantSlideshow.contentScaleMode = UIViewContentMode.ScaleAspectFill
        restaurantSlideshow.pageControlPosition = PageControlPosition.InsideScrollView
        restaurantSlideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor()
        restaurantSlideshow.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        
        
        // Set data to Control
        navigationItem.title = restaurant?.name
        self.restaurantNameLabel.text = restaurant?.name
        self.restaurantPhoneNumberLabel.text = restaurant?.telephone?.number
        self.restaurantDeliveryLabel.text = restaurant?.isDeliver == "0" ? "No Delivery" : "Delivery"
        
        
        if let latitude = restaurant?.location?.latitude, longtitude = restaurant?.location?.longtitude {
            if latitude != "null" && longtitude != "null" {
                loadMap(Double(latitude)!, longtitude: Double(longtitude)!, title: (restaurant?.name)!, snippet: "Tel: " + (restaurant?.telephone?.number)!)
            }else{
                loadMap(11.5758333, longtitude: 104.889168, title: "No Location", snippet: "Because restaurant image doesn't contain location!")
            }

        }else{
            loadMap(11.5758333, longtitude: 104.889168, title: "No Location", snippet: "Because restaurant image doesn't contain location!")
        }
           
        
        self.restaurantAddressLabel.text = (restaurant?.address)
        self.restaurantDetailLabel.text = (restaurant?.restDescription)
        
        
        // Set image to array of slide show
        for restImage in (restaurant?.images)! {
            restuarantImageArray.append(AlamofireSource(urlString: restImage.url!)!)
        }
        
        // Set image to slide show
        restaurantSlideshow.setImageInputs(restuarantImageArray)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(RestaurantDetailTableViewController.restaurantSlideshowClick))
        restaurantSlideshow.addGestureRecognizer(recognizer)
    }
    
    private func loadMap(latitude: Double, longtitude: Double, title: String, snippet: String) {
        let camera = GMSCameraPosition.cameraWithLatitude(latitude,
                                                          longitude: longtitude, zoom: 15)
        let frame = CGRectMake(0, 0, self.view.bounds.width, self.googleMapView.frame.height)
        let mapView = GMSMapView.mapWithFrame(frame, camera: camera)
        mapView.myLocationEnabled = true
        
        self.googleMapView.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longtitude)
        marker.title = title
        marker.snippet = snippet
        marker.map = mapView
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 100
        }else if indexPath.section == 4 {
            return 160
        }else if indexPath.section == 6 {
            let height = self.heightForText(self.restaurantDetailLabel.text!, font: self.restaurantDetailLabel.font, witdth: self.view.frame.size.width - 40)
            return height < 55 ? 55 : height
        }else{
            return 55
        }
        
    }
    
    func heightForText(text : NSString, font: UIFont, witdth: CGFloat) -> CGFloat {
        let constraint = CGSizeMake(witdth, 20000.0)
        let boundingBox = text.boundingRectWithSize(constraint, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
        
        let size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height))
        
        return size.height
    }
    
    func heightForText(textView: UITextView) -> CGFloat {
        
        textView.font = UIFont.systemFontOfSize(17)
         textView.sizeToFit()
        return textView.frame.size.height
        
    }
    
    func heightForText1(textView: UILabel) -> CGFloat {
        
        textView.font = UIFont.systemFontOfSize(17)
        textView.numberOfLines = 0
        textView.sizeToFit()
        return textView.frame.size.height
        
    }

    func restaurantSlideshowClick() {
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

    //MARK: Collection View
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurant?.menus?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MenuCellIdentifier", forIndexPath: indexPath) as! RestaurantDetailCollectionViewCell
        
        cell.configureMenu((restaurant?.menus![indexPath.row])!)
        
        return cell
    }
}

// MARK: - Table view data source
extension RestaurantDetailTableViewController {
    /// Determines the number of rows in the tableView.
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    /// Returns the number of sections.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

// MARK: - UITableViewDelegate Methods
extension RestaurantDetailTableViewController {

}