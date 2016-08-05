//
//  LoginViewController.swift
//  KARestaurant
//
//  Created by Kokpheng on 6/15/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Material
import MMMaterialDesignSpinner
import Alamofire
import ObjectMapper

class LoginViewController: UIViewController {
    @IBOutlet weak var footerSpinner: MMMaterialDesignSpinner!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var fbLoginButton: MaterialButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if (NSUserDefaults.standardUserDefaults().objectForKey("FACEBOOK_ID") != nil){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("RootNavigationViewController")
            self.presentViewController(vc, animated: true, completion: nil)
        }else{
            prepareRefreshControl()
        }
    }
    
    
    private func prepareRefreshControl(){
        self.logoImageView.hidden = false
        self.fbLoginButton.hidden = false
        // Handle clicks on the button
        fbLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set the line width of the spinner
        self.footerSpinner.lineWidth = 3
        
        // Set the tint color of the spinner
        self.footerSpinner.tintColor = MaterialColor.indigo.darken1
    }
    
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, gender, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler { (connection, result, error) in
            if error != nil{
                print(error)
                // Start & stop animations
                self.footerSpinner.stopAnimating()
                return
            }
            
            let facebookID = result["id"] as! String
            
            
            // get restuarant
            let url = Constant.GlobalConstants.URL_BASE + "/v1/api/admin/users"
            Alamofire.request(.POST, url, parameters: ["SSID": facebookID], encoding: .JSON, headers: Constant.GlobalConstants.headers).responseJSON { response in
                // Start & stop animations
                self.footerSpinner.stopAnimating()
                switch response.result {
                case .Success:
                    
                    let responseData = Mapper<UserResponse>().map(response.result.value)
                    
                    if (responseData?.code)! == "7777"{
                        
                        KaAlert.show("KA Restaurant", subTitle: "Something went wrong", showCloseButton: true, circleIconImage: UIImage(named: "meme"), completeion: { _ in })
                        
                    }else{
                        // Set FacebookID to NSUserDefault
                        NSUserDefaults.standardUserDefaults().setObject(responseData?.data?.id, forKey: "FACEBOOK_ID")
                        NSUserDefaults.standardUserDefaults().setObject(result, forKey: "FACEBOOK_USER")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewControllerWithIdentifier("RootNavigationViewController")
                        self.presentViewController(vc, animated: true, completion: nil)
                        
                    }
                case .Failure(let error):
                    KaAlert.show("Connection Error", subTitle: error.localizedDescription, showCloseButton: true, circleIconImage: UIImage(named: "meme"), completeion: { _ in })
                }
            }
        }
    }
    
    func loginButtonClicked() {
        // Start & stop animations
        self.footerSpinner.startAnimating()
        
        let login = FBSDKLoginManager()
        let parameters = ["public_profile"]
        login.logInWithReadPermissions(parameters, fromViewController: self) { (result, error) in
            
            if ((error) != nil) {
                // Start & stop animations
                self.footerSpinner.stopAnimating()
            } else if (result.isCancelled) {
                //print("Cancelled")
            } else {
                //print("Logged in")
                if result.grantedPermissions.contains("public_profile") {
                    if let _ = FBSDKAccessToken.currentAccessToken(){
                        self.fetchProfile()
                    }
                }
            }
            
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("complete login")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("logout")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        
        return true
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
