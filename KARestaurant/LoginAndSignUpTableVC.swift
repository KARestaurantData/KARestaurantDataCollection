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
        uploadImage()
        // validator.validate(self)
    }
    
    func login(){
        let parameters = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        
        let url = Constant.GlobalConstants.URL_BASE_KA + Constant.GlobalConstants.URL_USER_KA
        
        Alamofire.request(.POST, url, parameters: parameters,  encoding: .JSON, headers: Constant.GlobalConstants.headers_ka).responseJSON { response in
            let userRespone = Mapper<UserResponse>().map(response.result.value)
            print(userRespone?.message)
            
            let user = userRespone?.user
            print(user?.email)
        }
    }
    
    func uploadImage(){
        var imageName = [String]()
        
        let pic1 = UIImageJPEGRepresentation(UIImage.init(named: "pic1")!, 1.0)!
        let pic2 = UIImageJPEGRepresentation(UIImage.init(named: "pic2")!, 1.0)!
        let pic3 = UIImageJPEGRepresentation(UIImage.init(named: "pic3")!, 1.0)!
        
        let url = Constant.GlobalConstants.URL_BASE + "/v1/api/admin/restaurants/340"
       
        let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
        
        
        Alamofire.upload(
            .POST,
            url,
            headers: Constant.GlobalConstants.headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: "Kokpheng update".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "NAME")
                multipartFormData.appendBodyPart(data: "Hello Dest update".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "DESCRIPTION")
                multipartFormData.appendBodyPart(data: "Hello ADDD".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "ADDRESS")

                multipartFormData.appendBodyPart(data: "0".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "IS_DELIVERY")

                multipartFormData.appendBodyPart(data: "1".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "STATUS")
                multipartFormData.appendBodyPart(data: "rest cat".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "RESTAURANT_CATEGORY")
                multipartFormData.appendBodyPart(data: "111".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "LATITUDE")
                multipartFormData.appendBodyPart(data: "111".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "LONGITUDE")
                multipartFormData.appendBodyPart(data: "016 600 701".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "TELEPHONE")
                
//                
//                for photo in self.photoArray {
//                    var (imagePicked, imageExtension) = photo
//                    var imagePickedData = NSData()
//                    
//                    switch imageExtension {
//                    case "png": imagePickedData = UIImagePNGRepresentation(imagePicked)!
//                    case "jpg": imagePickedData = UIImageJPEGRepresentation(imagePicked, 1)!
//                    default: imagePickedData = UIImageJPEGRepresentation(imagePicked, 1)!
//                    }
//                    imagePickedData = UIImageJPEGRepresentation(imagePicked, 1)!
//                    multipartFormData.appendBodyPart(data: "image_iOS_device".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "article[article_images_attributes[\(index)][title]]")
//                    multipartFormData.appendBodyPart(data: imagePickedData, name: "article[article_images_attributes[\(index)][image]]", fileName: "image_\(index).\(imageExtension)", mimeType: "image/\(imageExtension)")
//                    index++
//                }
                


                multipartFormData.appendBodyPart(data: pic1, name:"MENU_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
                multipartFormData.appendBodyPart(data: pic2, name:"MENU_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
                multipartFormData.appendBodyPart(data: pic2, name:"RESTAURANT_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
                multipartFormData.appendBodyPart(data: pic3, name:"RESTAURANT_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
                multipartFormData.appendBodyPart(data: keyJSON, name: "format")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response.result.value)
//                        let responeData = Mapper<ImageUploadResponse>().map(response.result.value)
//                        
//                        for image in (responeData?.image)!{
//                            imageName.append(image.imageName!)
//                        }
                        
//                        let parameters = [
//                            "NAME": "kokpheng",
//                            "DESCRIPTION": "kokpheng",
//                            "ADDRESS": "kokpheng",
//                            "IS_DELIVERY": "1",
//                            "STATUS": "1",
//                            "MENU_IMAGES": imageName,
//                            "RESTAURANT_IMAGES": imageName,
//                            "RESTAURANT_CATEGORY": "hrd",
//                            "LATITUDE": "222",
//                            "LONGITUDE": "222",
//                            "TELEPHONE": "222"
//                        ]
//
//                        Alamofire.request(.POST, Constant.GlobalConstants.URL_BASE +  "/v1/api/admin/restaurants", parameters: parameters as? [String : AnyObject],  encoding: .JSON, headers: Constant.GlobalConstants.headers).responseJSON { response in
//                            
//                            print(response.result.value)
//                            
//                        }
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        
    }
    
    @IBAction func signUpAction(sender: AnyObject){
        
    }
    
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
