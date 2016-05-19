//
//  LoginAndSignUpTableVC.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/17/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import Device
import Alamofire
import ObjectMapper
import SwiftValidator

class LoginAndSignUpTableVC: UITableViewController, ValidationDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // ViewController.swift
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginAndSignUpTableVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Validation
        validateConfig()
        validator.registerField(emailTextField, errorLabel: nil, rules: [RequiredRule(),  EmailRule(message: "Invalid email")])
        validator.registerField(passwordTextField, errorLabel: nil, rules: [RequiredRule(), MinLengthRule(length: 6)])
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
    
    // MARK: ValidationDelegate Methods
    func validationSuccessful() {
        let parameters = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        let headers = [
            "Authorization": "Basic S0FBUEkhQCMkOiFAIyRLQUFQSQ==",
            "Accept": "application/json; charset=utf-8"
        ]
        
        let url = "http://api2.khmeracademy.org/api/authentication/mobilelogin"
        
        Alamofire.request(.POST, url, parameters: parameters,  encoding: .JSON, headers: headers).responseJSON { response in
            let userRespone = Mapper<UserResponse>().map(response.result.value)
            print(userRespone?.message)
            
            let user = userRespone?.user
            print(user?.email)
        }
        
        print("Validation Success!")
        let alert = UIAlertController(title: "Success", message: "You are validated!", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        // turn the fields to red
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            print("Validation FAILED: \(error.errorMessage)")
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
        }
    }
    
    func validateConfig() {
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            validationRule.textField.layer.borderColor = UIColor.greenColor().CGColor
            validationRule.textField.layer.borderWidth = 0.5
            
            }, error:{ (validationError) -> Void in
                print("error")
                print("Validation FAILED2: \(validationError.errorMessage)")
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                validationError.textField.layer.borderColor = UIColor.redColor().CGColor
                validationError.textField.layer.borderWidth = 1.0
        })
    }
    
    
    // MARK: Action
    @IBAction func loginAction(sender: AnyObject) {
       // validator.validate(self)
        let headers = [
            "Authorization": "Basic cmVzdGF1cmFudEFETUlOOnJlc3RhdXJhbnRQQFNTV09SRA==",
            "Accept": "application/json; charset=utf-8"
        ]
        
        let url = "http://localhost:8080/RESTAURANT_API/v1/api/admin/restaurants"
        
        Alamofire.request(.GET, url, headers: headers).responseJSON { response in
            let userRespone = Mapper<ResponseData>().map(response.result.value)
            
            let data = userRespone?.data![0]
            print(data?.createdBy?.id)

            
        }
        
    }
    
    @IBAction func signUpAction(sender: AnyObject){
        
    }
    
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
