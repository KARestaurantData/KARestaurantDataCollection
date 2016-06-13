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
    
    var myheigh : CGFloat = 0
    /*
     This value is either passed by `RestaurantTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new meal.
     */
    var restaurant: Restaurants?
    
     // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView Delegate
        self.menuCollectionview.delegate=self
        self.menuCollectionview.dataSource=self
        
        
        // Config ImageSlideShow and PageControl
        restaurantSlideshow.backgroundColor = UIColor.whiteColor()
        restaurantSlideshow.slideshowInterval = 5.0
        restaurantSlideshow.contentScaleMode = UIViewContentMode.ScaleToFill
        restaurantSlideshow.pageControlPosition = PageControlPosition.InsideScrollView
        restaurantSlideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor()
        restaurantSlideshow.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        
        
        // Set data to Control
        navigationItem.title = restaurant?.name
        self.restaurantNameLabel.text = restaurant?.name
        self.restaurantPhoneNumberLabel.text = restaurant?.telephone?.number
        self.restaurantDeliveryLabel.text = restaurant?.isDeliver == "0" ? "No Delivery" : "Delivery"
        self.restaurantAddressLabel.text = (restaurant?.address)! + "កញ្ញា មាស សុខសោភា បាន​លើក​ឡើង​ថា៖ “រយៈពេល​ប្រមាណ​ជា​៥ឆ្នាំ​​​ហើយ​ដែល​ខ្ញុំ​បាន​ចូល​ Town ហើយ​ជាង​១០​ឆ្នាំ​ហើយ​ដែរ ដែល​ខ្ញុំ​បាន​ចូល​សិល្បៈ​ បទ​ទី​១​នៅ​ Town ​ដែល​ធ្វើ​ឲ្យ​ខ្ញុំ​ផ្ទុះ​ខ្លាំង​នោះ​គឺ​បទ “I am Sorry” គឺ​ផ្ទុះ​ខ្លាំង​ទាំង​​ចម្រៀង​ និង MV”។ កញ្ញា បន្ត​ថា​បន្ទាប់​ពី​បទ​”I am Sorry” ហើយ​គឺ​បទ “លើ​លោក​នេះ​ខ្ញុំ​ស្រលាញ់​ម៉ាក់​ខ្ញុំ​ជាង​គេ” ក៏​ផ្ទុះ​ដែរ។ បទ “I am Sorry” បាន​ចេញ​​លក់​លើ​ទី​ផ្សារ​កំឡុង​ឆ្នាំ "
        self.restaurantDetailLabel.text = (restaurant?.restDescription)! + "កញ្ញា មាស សុខសោភា បាន​លើក​ឡើង​ថា៖ “រយៈពេល​ប្រមាណ​ជា​៥ឆ្នាំ​​​ហើយ​ដែល​ខ្ញុំ​បាន​ចូល​ Town ហើយ​ជាង​១០​ឆ្នាំ​ហើយ​ដែរ ដែល​ខ្ញុំ​បាន​ចូល​សិល្បៈ​ បទ​ទី​១​នៅ​ Town ​ដែល​ធ្វើ​ឲ្យ​ខ្ញុំ​ផ្ទុះ​ខ្លាំង​នោះ​គឺ​បទ “I am Sorry” គឺ​ផ្ទុះ​ខ្លាំង​ទាំង​​ចម្រៀង​ និង MV”។ កញ្ញា បន្ត​ថា​បន្ទាប់​ពី​បទ​”I am Sorry” ហើយ​គឺ​បទ “លើ​លោក​នេះ​ខ្ញុំ​ស្រលាញ់​ម៉ាក់​ខ្ញុំ​ជាង​គេ” ក៏​ផ្ទុះ​ដែរ។ បទ “I am Sorry” បាន​ចេញ​​លក់​លើ​ទី​ផ្សារ​កំឡុង​ឆ្នាំ ២០១០ ចំណែក​ឯ​បទ “លើ​លោក​នេះ​ខ្ញុំ​ស្រលាញ់​ម៉ាក់​ខ្ញុំ​ជាង​គេ” ចេញ​​លក់​លើ​ទី​ផ្សារ​កំឡុង​ឆ្នាំ ២០១៤។ \n សម្រាប់​អាល់ប៊ុម ដែល​នឹង​ចេញ​លក់​នៅ​ថ្ងៃ​នេះ​ជា Original Soloអាល់ប៊ុម​ ឬ អាល់ប៊ុម​ទោល​ទី១ ស្នា​ដៃ​បទ​ភ្លេង​ថ្មី​សុទ្ធ​មិន​ចម្លង ហើយ​ក៏​ជា​អាល់ប៊ុម​ទោល​​លើក​ដំបូង​របស់​​​កញ្ញា​ផង​ដែរ៕កញ្ញា មាស សុខសោភា បាន​លើក​ឡើង​ថា៖ “រយៈពេល​ប្រមាណ​ជា​៥ឆ្នាំ​​​ហើយ​ដែល​ខ្ញុំ​បាន​ចូល​ Town ហើយ​ជាង​១០​ឆ្នាំ​ហើយ​ដែរ ដែល​ខ្ញុំ​បាន​ចូល​សិល្បៈ​ បទ​ទី​១​នៅ​ Town ​ដែល​ធ្វើ​ឲ្យ​ខ្ញុំ​ផ្ទុះ​ខ្លាំង​នោះ​គឺ​បទ “I am Sorry” គឺ​ផ្ទុះ​ខ្លាំង​ទាំង​​ចម្រៀង​ និង MV”។ កញ្ញា បន្ត​ថា​បន្ទាប់​ពី​បទ​”I am Sorry” ហើយ​គឺ​បទ “លើ​លោក​នេះ​ខ្ញុំ​ស្រលាញ់​ម៉ាក់​ខ្ញុំ​ជាង​គេ” ក៏​ផ្ទុះ​ដែរ។ បទ “I am Sorry” បាន​ចេញ​​លក់​លើ​ទី​ផ្សារ​កំឡុង​ឆ្នាំ ២០១០ ចំណែក​ឯ​បទ “លើ​លោក​នេះ​ខ្ញុំ​ស្រលាញ់​ម៉ាក់​ខ្ញុំ​ជាង​គេ” ចេញ​​លក់​លើ​ទី​ផ្សារ​កំឡុង​ឆ្នាំ ២០១៤។ \n សម្រាប់​អាល់ប៊ុម ដែល​នឹង​ចេញ​លក់​នៅ​ថ្ងៃ​នេះ​ជា Original Soloអាល់ប៊ុម​ ឬ អាល់ប៊ុម​ទោល​ទី១ ស្នា​ដៃ​បទ​ភ្លេង​ថ្មី​សុទ្ធ​មិន​ចម្លង ហើយ​ក៏​ជា​អាល់ប៊ុម​ទោល​​លើក​ដំបូង​របស់​​​កញ្ញា​ផង​ដែរ៕ \n\n"
        
        
        // Set image to array of slide show
        for restImage in (restaurant?.images)! {
            restuarantImageArray.append(AlamofireSource(urlString: restImage.url!)!)
        }
        
        // Set image to slide show
        restaurantSlideshow.setImageInputs(restuarantImageArray)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(RestaurantDetailTableViewController.restaurantSlideshowClick))
        restaurantSlideshow.addGestureRecognizer(recognizer)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 100
        }else if indexPath.section == 4 {
            return self.heightForText(self.restaurantAddressLabel.text!, font: self.restaurantAddressLabel.font, witdth: self.view.frame.size.width - 40)
            
        }else if indexPath.section == 5 {
            return self.heightForText(self.restaurantDetailLabel.text!, font: self.restaurantDetailLabel.font, witdth: self.view.frame.size.width - 40)
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
        return 6
    }
    /// Returns the number of sections.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

// MARK: - UITableViewDelegate Methods
extension RestaurantDetailTableViewController {

}