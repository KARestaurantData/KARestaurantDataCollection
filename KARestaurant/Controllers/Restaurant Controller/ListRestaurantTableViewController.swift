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


class ListRestaurantTableViewController: UITableViewController {

    // MARK: Properties
    // refresh control status
    var isNewRestaurantDataLoading: Bool = false
    var isRefreshControlLoading: Bool = false
    
    let restuarantRefreshControl: UIRefreshControl = UIRefreshControl() // Top RefreshControl
    
    //  object
    var responseRestaurant = [Restaurants]()
    var responsePagination = Pagination()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add refresh control to view
        restuarantRefreshControl.addTarget(self, action: #selector(ListRestaurantTableViewController.uiRefreshControlAction), forControlEvents: .ValueChanged)
        self.tableView.addSubview(restuarantRefreshControl)
        
        // fetch data for first load
        getRestuarant(1, limit: 20)
    }
    
    
    // refresh control action
    func uiRefreshControlAction() {
        print((self.responsePagination?.limit)!)
        
        // reload data
        if !isRefreshControlLoading {
            self.isRefreshControlLoading =  true
            getRestuarant(1, limit: (self.responsePagination?.limit)!)
        }
    }
    
    // fetch data
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
                        getRestuarant((self.responsePagination?.page)! + 1, limit: (self.responsePagination?.limit)!)
                    }
                    
                    //                    if helperInstance.isConnectedToNetwork(){
                    //
                    
                    //                        isNewDataLoading = true
                    //                        getNewData()
                    //                    }
                }
            }
        }
    }
    
    // MARK: - UITableViewDelegate Methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("ShowRestuarantDetail", sender: tableView.cellForRowAtIndexPath(indexPath))
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
}

/// TableViewDataSource methods.
extension ListRestaurantTableViewController {
    /// Determines the number of rows in the tableView.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.responseRestaurant.count)
    }
    
    
    // MARK: - Table view data source
    /// Returns the number of sections.
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let restaurant = self.responseRestaurant[indexPath.row] as Restaurants
        print(restaurant.name)
        print(restaurant.thumbnail)
        // Fetches the appropriate restuarant for the data source layout.
       
        // Table view cells are reused and should be dequeued using a cell identifier.
        if let cell =  tableView.dequeueReusableCellWithIdentifier("RestaurantTableViewCell", forIndexPath: indexPath) as? ListRestaurantTableViewCell {
            
            cell.configure(restaurant)
            
            return cell
        }else{
            return UITableViewCell()
        }
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

}

/// UITableViewDelegate methods.
extension ListRestaurantTableViewController {
    /// Sets the tableView cell height.
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 250
//    }
}

