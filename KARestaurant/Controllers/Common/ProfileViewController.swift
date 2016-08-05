//
//  ProfileViewController.swift
//  KARestaurant
//
//  Created by Kokpheng on 8/5/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = NSUserDefaults.standardUserDefaults().objectForKey("FACEBOOK_USER")!
        print(user)
        self.nameLabel.text = "\(user["first_name"]!!) \(user["last_name"]!!)"
        self.genderLabel.text = "\(user["gender"]!!)".capitalizedString
        
        if let val = user["email"] {
            if let x = val {
                print(x)
                 self.emailLabel.text = "\(x)"
            } else {
                self.emailLabel.text = ""
            }
        } else {
           self.emailLabel.text = ""
        }
        
        
        let url = user["picture"]!!["data"]!!["url"]!!
        self.profileImageView.layer.cornerRadius = self.profileImageView.layer.frame.size.height / 2
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.kf_setImageWithURL(NSURL(string: url as! String)!, placeholderImage: UIImage(named: "defaultPhoto"), optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
            //
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
