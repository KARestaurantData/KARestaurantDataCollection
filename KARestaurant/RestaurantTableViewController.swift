//
//  RestaurantTableViewController.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/25/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import Alamofire
import ObjectMapper
import AlamofireImage

class RestaurantTableViewController: UITableViewController {
    // MARK: Properties
    var responseRestaurant = [Restaurants]()
    let vc = BSImagePickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        getRestuarant()
        
    }
    
    
    func getRestuarant(){
        // get restuarant
        let url = Constant.GlobalConstants.URL_BASE + "/v1/api/admin/restaurants"
       
        Alamofire.request(.GET, url, headers: Constant.GlobalConstants.headers).responseJSON { response in
             let responseData = Mapper<ResponseRestaurant>().map(response.result.value)
            
            self.responseRestaurant = responseData!.data!
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.responseRestaurant.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RestaurantTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RestaurantTableViewCell
        
        let restuarant = self.responseRestaurant[indexPath.row] as Restaurants
        
        // Fetches the appropriate restuarant for the data source layout.
        cell.nameLabel.text = restuarant.name
        cell.descriptionLabel.text = restuarant.restDescription
        cell.deliveryLabel.text = restuarant.isDeliver == "1" ? "Delivery" : "No Delivery"
        
        Alamofire.request(.GET, restuarant.thumbnail!)
            .responseImage { response in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    cell.photoImageView.image = image
                   // print("image downloaded: \(image)")
                }
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.responseRestaurant.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let mealDetailViewController = segue.destinationViewController as! AddViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? RestaurantTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = self.responseRestaurant[indexPath.row]
                mealDetailViewController.restaurant = selectedMeal
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
        }
    }
    
    //
    
    
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddViewController, meal = sourceViewController.restaurant {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                self.responseRestaurant[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: self.responseRestaurant.count, inSection: 0)
                self.responseRestaurant.append(meal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
    //MARK: BSImagePicker

}
