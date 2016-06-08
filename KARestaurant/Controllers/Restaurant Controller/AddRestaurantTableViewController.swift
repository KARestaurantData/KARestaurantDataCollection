//
//  AddRestaurantTableViewController.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/27/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import PhotosUI
import AssetsLibrary
import Alamofire

import DKImagePickerController
import AVKit

import CoreLocation

class AddRestaurantTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource, CLLocationManagerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var menuSelectedLabel: UILabel!
    @IBOutlet weak var browseButton:UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var assets: [DKAsset]?
    var imageArray = [UIImage]()
    
    struct Demo {
        static let titles = [
            ["Pick All", "Pick photos only", "Pick videos only", "Pick All (only photos or videos)"],
            ["Take a picture"],
            ["Hides camera"],
            ["Allows landscape"],
            ["Single select"]
        ]
        static let types: [DKImagePickerControllerAssetType] = [.AllAssets, .AllPhotos, .AllVideos, .AllAssets]
    }
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate=self
        self.collectionView.dataSource=self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Enable the Save button only if the text field has a valid Restaurant name.
        checkValidRestuarantName()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        print(String(format: "latitude %.4f",
            latestLocation.coordinate.latitude))
        print(String(format: "longitude %.4f",
            latestLocation.coordinate.longitude))
        print( String(format: "horizontalAccuracy %.4f",
            latestLocation.horizontalAccuracy))
        print(String(format: "altitude %.4f",
            latestLocation.altitude))
        print( String(format: "verticalAccuracy %.4f",
            latestLocation.verticalAccuracy))
        
        
        if startLocation == nil {
            startLocation = latestLocation as! CLLocation
        }
        
        let distanceBetween: CLLocationDistance =
            latestLocation.distanceFromLocation(startLocation)
        
        print(String(format: "distanceBetween %.2f", distanceBetween))
    }
    
    func locationManager(manager: CLLocationManager,
                         didFailWithError error: NSError) {
        print( error)
    }
    
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidRestuarantName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidRestuarantName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // MARK: Actions
    @IBAction func showImagePicker(sender: UITapGestureRecognizer) {
        
        
        showImagePickerWithAssetType(Demo.types[0], allowMultipleType: true, sourceType: DKImagePickerControllerSourceType.Both, allowsLandscape: true, singleSelect: false);
        
    }
    
    func reloadTable(){
        self.collectionView.reloadData()
        if self.assets?.count == 0 {
            self.photoImageView.image = UIImage.init(named: "defaultPhoto")
        }else{
            self.photoImageView.image = self.imageArray.first
        }
    }
    
    //MARK: collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let asset = self.assets![indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! CustomCell
        
        let tag = indexPath.row + 1
        
        cell.tag = tag
        
        asset.fetchOriginalImageWithCompleteBlock { (image, info) in
            if cell.tag == tag {
                cell.myImage.image = image
                self.imageArray.append(image!)
                print( self.assets![indexPath.row].originalAsset?.location?.coordinate)
                
                if tag == 1{
                    self.photoImageView.image = image
                }
            }
        }
        return cell
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSErrorPointer, contextInfo:UnsafePointer<Void>)       {
        
        if (didFinishSavingWithError != nil) {
            print("Error saving photo: \(didFinishSavingWithError)")
        } else {
            print("Successfully saved photo, will make request to update asset metadata")
            
            // fetch the most recent image asset:
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
            
            // get the asset we want to modify from results:
            let lastImageAsset = fetchResult.lastObject as! PHAsset
            
            // create CLLocation from lat/long coords:
            // (could fetch from LocationManager if needed)
            let coordinate = CLLocationCoordinate2DMake(150.5, 23.5)
            let nowDate = NSDate()
            // I add some defaults for time/altitude/accuracies:
            let myLocation = CLLocation(coordinate: coordinate, altitude: 0.0, horizontalAccuracy: 1.0, verticalAccuracy: 1.0, timestamp: nowDate)
            
            // make change request:
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                
                // modify existing asset:
                let assetChangeRequest = PHAssetChangeRequest(forAsset: lastImageAsset)
                assetChangeRequest.location = myLocation
                
                }, completionHandler: {
                    (success:Bool, error:NSError?) -> Void in
                    
                    if (success) {
                        print("Succesfully saved metadata to asset")
                        print("location metadata = \(myLocation)")
                    } else {
                        print("Failed to save metadata to asset with error: \(error!)")
                    }
                    
            })
            
            
        }
    }
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    //MARK: delete action
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.imageArray.removeAtIndex(indexPath.row)
        self.assets?.removeAtIndex(indexPath.row)
        self.collectionView.deleteItemsAtIndexPaths([indexPath])
        reloadTable()
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        print("save click")
        uploadImage()
        
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
        
    }
    
    func uploadImage(){
        
        let url = Constant.GlobalConstants.URL_BASE + "/v1/api/admin/restaurants/multiple/register"
        
        let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
        
        
        Alamofire.upload(
            .POST,
            url,
            headers: Constant.GlobalConstants.headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: self.nameTextField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "NAME")
                
                multipartFormData.appendBodyPart(data: "Hello Dest update".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "DESCRIPTION")
                
                multipartFormData.appendBodyPart(data: "Hello ADDD".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "ADDRESS")
                
                multipartFormData.appendBodyPart(data: "0".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "IS_DELIVERY")
                
                multipartFormData.appendBodyPart(data: "1".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "STATUS")
                
                multipartFormData.appendBodyPart(data: "rest cat".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "RESTAURANT_CATEGORY")
                multipartFormData.appendBodyPart(data: "111".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "LATITUDE")
                multipartFormData.appendBodyPart(data: "111".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "LONGITUDE")
                multipartFormData.appendBodyPart(data: "016 600 701".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "TELEPHONE")
                
                print(self.imageArray.count)
                
                for i in 0 ..< self.imageArray.count{
                    let imagePickedData = UIImageJPEGRepresentation(self.imageArray[i], 0.3)!
                    print("add")
                    
                    multipartFormData.appendBodyPart(data: imagePickedData, name: "MENU_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
                    multipartFormData.appendBodyPart(data: imagePickedData, name:"RESTAURANT_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
                    
                }
                
                
                multipartFormData.appendBodyPart(data: keyJSON, name: "format")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response)
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        
    }
    
    
    func showImagePickerWithAssetType(assetType: DKImagePickerControllerAssetType,
                                      allowMultipleType: Bool,
                                      sourceType: DKImagePickerControllerSourceType = .Both,
                                      allowsLandscape: Bool,
                                      singleSelect: Bool) {
        
        let pickerController = DKImagePickerController()
        
        // Custom camera
        //		pickerController.UIDelegate = CustomUIDelegate()
        //		pickerController.modalPresentationStyle = .OverCurrentContext
        
        pickerController.assetType = assetType
        pickerController.allowsLandscape = allowsLandscape
        pickerController.allowMultipleTypes = allowMultipleType
        pickerController.sourceType = sourceType
        pickerController.singleSelect = singleSelect
        
        //		pickerController.showsCancelButton = true
        //		pickerController.showsEmptyAlbums = false
        //		pickerController.defaultAssetGroup = PHAssetCollectionSubtype.SmartAlbumFavorites
        
        // Clear all the selected assets if you used the picker controller as a single instance.
        //		pickerController.defaultSelectedAssets = nil
        
        pickerController.defaultSelectedAssets = self.assets
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            self.imageArray.removeAll()
            self.assets = assets
            self.reloadTable()
        }
        
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            pickerController.modalPresentationStyle = .FormSheet;
        }
        
        self.presentViewController(pickerController, animated: true) {}
    }
    
}
