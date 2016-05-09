//
//  LoginTableViewController.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/9/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import Device

class LoginTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        /*** Display the device screen size ***/
        switch Device.size() {
        case .Screen3_5Inch,
             .Screen4Inch,
             .Screen4_7Inch,
             .Screen5_5Inch:
            if indexPath.row == 0{
                return self.tableView.bounds.height * 0.4
            }
            else{
                return 160
            }
        case .Screen7_9Inch,
             .Screen9_7Inch,
             .Screen12_9Inch:
            if indexPath.row == 0{
                return self.tableView.bounds.height * 0.4
            }
            else{
                return 250
            }
        default:
            print("Unknown size")
            return 200
        }
    }
    
    func myFunc() {
        /*** Display the device type ***/
        switch Device.type() {
        case .iPod:         print("It's an iPod")
        case .iPhone:       print("It's an iPhone")
        case .iPad:         print("It's an iPad")
        case .Simulator:    print("It's a Simulated device")
        default:            print("Unknown device type")
        }
    }
    
    func myFunc1() {
        /*** Display the device screen size ***/
        switch Device.size() {
        case .Screen3_5Inch:  print("It's a 3.5 inch screen")
        case .Screen4Inch:    print("It's a 4 inch screen")
        case .Screen4_7Inch:  print("It's a 4.7 inch screen")
        case .Screen5_5Inch:  print("It's a 5.5 inch screen")
        case .Screen7_9Inch:  print("It's a 7.9 inch screen")
        case .Screen9_7Inch:  print("It's a 9.7 inch screen")
        case .Screen12_9Inch: print("It's a 12.9 inch screen")
        default:              print("Unknown size")
        }
    }
    


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
