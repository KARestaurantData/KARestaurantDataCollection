//
//  ListRestaurantTableViewController.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/31/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import Photos
import Material
import Alamofire
import ObjectMapper
import AlamofireImage
import MMMaterialDesignSpinner
import SCLAlertView
import CoreLocation

class ListRestaurantTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: Properties
    // refresh control status
    var isNewRestaurantDataLoading: Bool = false
    var isRefreshControlLoading: Bool = false
    let restuarantRefreshControl: UIRefreshControl = UIRefreshControl() // Top RefreshControl
    
    @IBOutlet weak var takePhotoButton: UIButton!
    //  object
    var responseRestaurant = [Restaurant]()
    var responsePagination = Pagination()
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerSpinner: MMMaterialDesignSpinner!
    @IBOutlet weak var footerImageView: UIImageView!
    
    // Initialize the progress view
    var centerSpinner : MMMaterialDesignSpinner = MMMaterialDesignSpinner(frame: CGRectMake(0, 0, 75,75))
    
    var locManager = CLLocationManager()
    
    var imagePicker = UIImagePickerController()
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareRefreshControl()
        
        // fetch data for first load
        getRestuarant(1, limit: 20)
    }
    
    
    
    private func prepareRefreshControl(){
        navigationController!.navigationBar.barTintColor = MaterialColor.pink.accent1
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: MaterialColor.white]
        navigationController!.navigationBar.tintColor = MaterialColor.white
       
        self.centerSpinner.center = self.view.center
        self.footerSpinner.center.x = self.footerView.center.x
        
        // Set the line width of the spinner
        self.centerSpinner.lineWidth = 5
        self.footerSpinner.lineWidth = 3
        
        // Set the tint color of the spinner
        self.centerSpinner.tintColor = MaterialColor.pink.accent1
        self.footerSpinner.tintColor = MaterialColor.pink.accent1
        
        // Add it as a subview
        self.view.addSubview(centerSpinner)
        self.footerView.addSubview(footerSpinner)
        
        // Start & stop animations
        self.centerSpinner.startAnimating()
        
        
        // add refresh control to view
        restuarantRefreshControl.tintColor = MaterialColor.pink.accent1
        restuarantRefreshControl.addTarget(self, action: #selector(ListRestaurantTableViewController.uiRefreshControlAction), forControlEvents: .ValueChanged)
        self.tableView.addSubview(restuarantRefreshControl)
        
        self.view.userInteractionEnabled = false
    }
    
    // MARK: Refresh Control Action
    func uiRefreshControlAction() {
        print((self.responsePagination?.limit)!)
        
        // reload data
        if !isRefreshControlLoading {
            self.isRefreshControlLoading =  true
            self.footerImageView.hidden = true
            getRestuarant(1, limit: (self.responsePagination?.limit)!)
        }
    }
    
    // MARK: Fetch Data
    func getRestuarant(page: Int, limit: Int){
        
        // get restuarant
        let url = Constant.GlobalConstants.URL_BASE + "/v1/api/admin/restaurants/?page=\(page)&limit=\(limit)"
        
        Alamofire.request(.GET, url, headers: Constant.GlobalConstants.headers).responseJSON { response in
            
            
            let responseData = Mapper<ResponseRestaurant>().map(response.result.value)
            
            if let responsePagination = responseData!.pagination {
                self.responsePagination = responsePagination
                
            }
            // remove data when pull to refresh
            if self.isRefreshControlLoading {
                self.responseRestaurant.removeAll()
            }
            
            self.responseRestaurant += responseData!.data!
            
            print("limit: \(self.responsePagination!.limit!) item count:\(self.responseRestaurant.count)/\(self.responsePagination!.totalCount!) current page: \(self.responsePagination!.page!) page: \(self.responsePagination!.totalPages!)")
            
            self.isNewRestaurantDataLoading = false
            self.isRefreshControlLoading = false
            self.view.userInteractionEnabled = true
            self.centerSpinner.stopAnimating()
            self.footerSpinner.stopAnimating()
            self.restuarantRefreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Read More Data
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        if scrollView == self.tableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewRestaurantDataLoading{
                    isNewRestaurantDataLoading = true
                    if self.responsePagination?.page < self.responsePagination?.totalPages {
                        
                        if !footerSpinner.isAnimating{
                            self.footerSpinner.startAnimating()
                        }
                        
                        getRestuarant((self.responsePagination?.page)! + 1, limit: (self.responsePagination?.limit)!)
                    }else{
                       self.footerImageView.hidden = false
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowRestuarantDetail" {
            let restaurantDetailViewController = segue.destinationViewController as! RestaurantDetailTableViewController
            
            // Get the cell that generated this segue.
            if let selectedRestaurantCell = sender as? ListRestaurantTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedRestaurantCell)!
                let selectedRestaurant = self.responseRestaurant[indexPath.row]
                
                restaurantDetailViewController.restaurant = selectedRestaurant
            }
        }else if segue.identifier == "EditRestuarantDetail" {
            let editRestaurantViewController = segue.destinationViewController as! EditRestaurantTableViewController
            print("edit click")
            // Get the cell that generated this segue.
            if let selectedRestaurantCell = sender as? ListRestaurantTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedRestaurantCell)!
                let selectedRestaurant = self.responseRestaurant[indexPath.row]
                
                editRestaurantViewController.restaurant = selectedRestaurant
            }
            
            
            
            // editRestaurantViewController.restaurant = sender as? Restaurants
            
        }
    }
    
    //
    
    
    
    //    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    //        if let sourceViewController = sender.sourceViewController as? AddViewController, meal = sourceViewController.restaurant {
    //            if let selectedIndexPath = tableView.indexPathForSelectedRow {
    //                // Update an existing meal.
    //                self.responseRestaurant[selectedIndexPath.row] = meal
    //                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
    //            } else {
    //                // Add a new meal.
    //                let newIndexPath = NSIndexPath(forRow: self.responseRestaurant.count, inSection: 0)
    //                self.responseRestaurant.append(meal)
    //                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
    //            }
    //        }
    //    }
}

// MARK: - Table view data source
extension ListRestaurantTableViewController {
    /// Determines the number of rows in the tableView.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.responseRestaurant.count)
    }
    
    /// Returns the number of sections.
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurant = self.responseRestaurant[indexPath.row] as Restaurant
        // Fetches the appropriate restuarant for the data source layout.
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        if let cell =  tableView.dequeueReusableCellWithIdentifier("RestaurantTableViewCell", forIndexPath: indexPath) as? ListRestaurantTableViewCell {
            
            cell.configure(restaurant)
            let gesture = CustomeTapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            gesture.indexPath = indexPath
            cell.editButton.addGestureRecognizer(gesture)
            

            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func handleTap(sender: CustomeTapGestureRecognizer) {
       
        let appearance = SCLAlertView.SCLAppearance(
            //showCloseButton: false
            
            //showCircularIcon: false
        
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("Edit") {
            self.performSegueWithIdentifier("EditRestuarantDetail", sender: self.tableView.cellForRowAtIndexPath(sender.indexPath!))
           // self.performSegueWithIdentifier("EditRestuarantDetail", sender: sender.restaurant)
        }
        
        
        alert.showTitle(
            "KA Restaurant", // Title of view
            subTitle: "Update or Delete", // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "Close", // Optional button value, default: ""
            style: .Success, // Styles - see below.
            colorStyle: 0xFF80AB,
            colorTextButton: 0xFFFFFF,
            circleIconImage: UIImage(named: "meal1")
        )
        
    }
    
    
    /* Delete */
    // Override to support conditional editing of the table view.
    //    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        // Return false if you do not want the specified item to be editable.
    //        return false
    //    }
    //
    //
    //    // Override to support editing the table view.
    //    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //        if editingStyle == .Delete {
    //            // Delete the row from the data source
    //            self.responseRestaurant.removeAtIndex(indexPath.row)
    //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    //        } else if editingStyle == .Insert {
    //            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //        }
    //    }
    
    @IBAction func takePhotoAction(sender: UIButton) {
        locManager.requestWhenInUseAuthorization();
        locManager.startUpdatingLocation();
        
        
        if !CLLocationManager.locationServicesEnabled() {
            print("LOCATION SERVICES DISABLED");
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
                
                //showCircularIcon: false
                
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("Close") {
            }
            
            
            alert.showTitle(
                "KA Restaurant", // Title of view
                subTitle: "Please enable your location service before you can take the photo!", // String of view
                duration: 0.0, // Duration to show before closing automatically, default: 0.0
                completeText: "", // Optional button value, default: ""
                style: .Success, // Styles - see below.
                colorStyle: 0xFF80AB,
                colorTextButton: 0xFFFFFF,
                circleIconImage: UIImage(named: "meal1")
            )
            return
        }
        
        imagePicker.delegate = self;
        imagePicker.sourceType = .Camera;
        presentViewController(imagePicker, animated: true, completion: nil);

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: { () in
            if picker.sourceType == .Camera {
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage;
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil);
            }
        });
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSErrorPointer, contextInfo: UnsafePointer<Void>) {
        if didFinishSavingWithError != nil {
            print("Error saving photo: \(didFinishSavingWithError)");
        }
        else {
            print("Successfully saved photo, will make request to update asset metadata");
            // fetch the most recent image asset
            let fetchOptions = PHFetchOptions();
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)];
            let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions);
            
            // get the asset we want to modify from results
            let lastImageAsset = fetchResult.lastObject as! PHAsset;
            //self.photoImageView.image = getAssetThumbnail(lastImageAsset);
            
            // get location
            var myLocation = CLLocation();
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways) {
                myLocation = locManager.location!;
            }
            
            // make change request
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                // modify existing asset
                let assetChangeRequest = PHAssetChangeRequest(forAsset: lastImageAsset);
                assetChangeRequest.location = CLLocation.init(latitude: myLocation.coordinate.latitude, longitude:  myLocation.coordinate.longitude);
                },
                                                               completionHandler: {
                                                                (success:Bool, error:NSError?) -> Void in
                                                                if success {
                                                                    print("Successfully saved metadata to asset");
                                                                    print("Location metadata = \(myLocation)");
                                                                    return;
                                                                }
                                                                else {
                                                                    print("Failed to save metadata to asset with error: \(error!)");
                                                                    return;
                                                                }
            });
        }
    }
}

// MARK: - UITableViewDelegate Methods
extension ListRestaurantTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("ShowRestuarantDetail", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
}

class CustomeTapGestureRecognizer: UITapGestureRecognizer {
    var indexPath: NSIndexPath?
}


