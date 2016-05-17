//
//  LoginAndSignUpTableVC.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/17/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import Device

class LoginAndSignUpTableVC: UITableViewController {
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginAndSignUpTableVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Hide NavigationBar
        self.navigationController!.navigationBar.hidden = true
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        /*** Display the device screen size ***/
        switch Device.size() {
        case .Screen3_5Inch,
             .Screen4Inch,
             .Screen4_7Inch,
             .Screen5_5Inch:
            if indexPath.row == 0 {
                return self.tableView.bounds.height * 0.4
            }
            else{
                switch Device.size() {
                case .Screen3_5Inch:
                    return self.tableView.bounds.height * 0.8
                case .Screen4Inch:
                    return self.tableView.bounds.height * 0.7
                case .Screen4_7Inch:
                    return self.tableView.bounds.height * 0.6
                case .Screen5_5Inch:
                    return self.tableView.bounds.height * 0.5
                default:
                    print("Unknown size")
                    return 240
                }
            }
        case .Screen7_9Inch,
             .Screen9_7Inch,
             .Screen12_9Inch:
            if indexPath.row == 0 {
                return self.tableView.bounds.height * 0.4
            }
            else{
                return self.tableView.bounds.height * 0.6
            }
        default:
            print("Unknown size")
            return 240
        }
    }

    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}
