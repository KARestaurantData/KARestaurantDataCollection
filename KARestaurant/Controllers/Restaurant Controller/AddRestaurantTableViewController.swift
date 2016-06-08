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

import Material
import M13Checkbox
import DownPicker

class AddRestaurantTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource, CLLocationManagerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var restaurantDescriptionTextField: TextField!
    @IBOutlet weak var deliveryLabel: MaterialLabel!
    @IBOutlet weak var deliveryCheckBox: M13Checkbox!
    @IBOutlet weak var homeTextField: TextField!
    @IBOutlet weak var streetTextField: TextField!
    @IBOutlet weak var restaurantTypeTextField: TextField!
    @IBOutlet weak var districtTextField: TextField!
    @IBOutlet weak var communeTextField: TextField!
    @IBOutlet weak var restaurantImageLabel: MaterialLabel!
    @IBOutlet weak var browseRestaurantImageButton: RaisedButton!
    @IBOutlet weak var restaurantMenuImageLabel: MaterialLabel!
    @IBOutlet weak var browseRestaurantMenuImageButton: RaisedButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var restaurantImageCollectionView: UICollectionView!
    
    
     @IBOutlet weak var restaurantMenuImageCollectionView: UICollectionView!
    var restaurantImageAssets: [DKAsset]?
    var restaurantMenuImageAssets: [DKAsset]?
    var restaurantImageArray = [UIImage]()
    var restaurantMenuImageArray = [UIImage]()
    
    struct DKImagePickerType {
        static let types: [DKImagePickerControllerAssetType] = [.AllAssets, .AllPhotos, .AllVideos, .AllAssets]
    }
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    var restaurantTypeDownPicker, districtDownPicker, communeDownPicker: DownPicker!
    // create the array of data
    var bandArray = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantImageCollectionView.delegate=self
        self.restaurantImageCollectionView.dataSource=self
        
        self.restaurantMenuImageCollectionView.delegate=self
        self.restaurantMenuImageCollectionView.dataSource=self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        restaurantDescriptionTextField.delegate = self
        
        // Enable the Save button only if the text field has a valid Restaurant name.
        checkValidRestuarantName()
        
        prepareView()
        prepareLabel()
        prepareTextField()
        prepareDownPicker()
        prepareEmailField()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: AnyObject = locations[locations.count - 1]
        
//        print(String(format: "latitude %.4f",
//            latestLocation.coordinate.latitude))
//        print(String(format: "longitude %.4f",
//            latestLocation.coordinate.longitude))
//        print( String(format: "horizontalAccuracy %.4f",
//            latestLocation.horizontalAccuracy))
//        print(String(format: "altitude %.4f",
//            latestLocation.altitude))
//        print( String(format: "verticalAccuracy %.4f",
//            latestLocation.verticalAccuracy))
//        
        
        if startLocation == nil {
            startLocation = latestLocation as! CLLocation
        }
        
        let distanceBetween: CLLocationDistance =
            latestLocation.distanceFromLocation(startLocation)
        
        //print(String(format: "distanceBetween %.2f", distanceBetween))
    }
    
    func locationManager(manager: CLLocationManager,
                         didFailWithError error: NSError) {
        print( error)
    }
    
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
        deliveryCheckBox.stateChangeAnimation = M13Checkbox.Animation.Fill
    }
    
    /// Prepares the TextField.
    private func prepareTextField() {
    }
    
    private func prepareLabel() {
        deliveryLabel.font = deliveryLabel.font.fontWithSize(16)
        restaurantImageLabel.font = restaurantImageLabel.font.fontWithSize(16)
        restaurantMenuImageLabel.font = restaurantMenuImageLabel.font.fontWithSize(16)
    }
    
    private func prepareDownPicker(){
        // add some sample data
        bandArray.append("Offsprings")
        bandArray.append("Radiohead")
        bandArray.append("Muse")
        bandArray.append("R.E.M")
        bandArray.append("The Killers")
        
        
        restaurantTypeDownPicker = DownPicker(textField: restaurantTypeTextField, withData: bandArray)
        restaurantTypeDownPicker.setPlaceholder("Please select restaurant type")
        restaurantTypeDownPicker.setPlaceholderWhileSelecting("Restaurant Type")
        
        
        districtDownPicker =  DownPicker(textField: districtTextField, withData: bandArray)
        districtDownPicker.setPlaceholder("Please select district")
        districtDownPicker.setPlaceholderWhileSelecting("District")
        
        communeDownPicker =  DownPicker(textField: communeTextField, withData: bandArray)
        communeDownPicker.setPlaceholder("Please select commune")
        communeDownPicker.setPlaceholderWhileSelecting("Commune")
        
    }
    
    /// Prepares the email TextField.
    private func prepareEmailField() {
//        emailField.placeholder = "Email"
//        emailField.delegate = self
//        
//        /*
//         Used to display the error message, which is displayed when
//         the user presses the 'return' key.
//         */
//        emailField.detail = "Email is incorrect."
    }
    
    /// Executed when the 'return' key is pressed.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidRestuarantName()
        navigationItem.title = nameTextField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidRestuarantName() {
        
        // Disable the Save button if the text field is empty.
        if !(nameTextField.text?.isEmpty)! && !(restaurantDescriptionTextField.text?.isEmpty)! {
            saveButton.enabled = true
        }else{
            saveButton.enabled = false
        }
        
    }
    

    @IBAction func deliveryCheckBoxClick(checkbox: M13Checkbox) {
        print(checkbox.checkState)
        
        if checkbox.checkState == M13Checkbox.CheckState.Checked {
            deliveryLabel.textColor = MaterialColor.blue.base
        }else{
            deliveryLabel.textColor = MaterialColor.grey.base
        }
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
    @IBAction func showImagePicker(sender: RaisedButton) {
        if sender == self.browseRestaurantImageButton{
            
             showRestaurantImagePickerWithAssetType(DKImagePickerType.types[0], allowMultipleType: true, sourceType: DKImagePickerControllerSourceType.Both, allowsLandscape: true, singleSelect: false);
        }else{
            
            showRestaurantMenuImagePickerWithAssetType(DKImagePickerType.types[0], allowMultipleType: true, sourceType: DKImagePickerControllerSourceType.Both, allowsLandscape: true, singleSelect: false);
        }
        
       
        
    }
    
    func reloadRestaurantImageCollectionView(){
        self.restaurantImageCollectionView.reloadData()
        if self.restaurantImageAssets?.count == 0 {
            self.photoImageView.image = UIImage.init(named: "defaultPhoto")
        }else{
            self.photoImageView.image = self.restaurantImageArray.first
        }
    }
    
    func reloadRestaurantMenuImageCollectionView(){
        self.restaurantMenuImageCollectionView.reloadData()
    }
    
    //MARK: collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(self.restaurantImageCollectionView){
            return self.restaurantImageAssets?.count ?? 0
        }else{
            return self.restaurantMenuImageAssets?.count ?? 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.isEqual(self.restaurantImageCollectionView){
            let asset = self.restaurantImageAssets![indexPath.row]
            
            let cell = self.restaurantImageCollectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! CustomCell
            
            let tag = indexPath.row + 1
            
            cell.tag = tag
            
            asset.fetchOriginalImageWithCompleteBlock { (image, info) in
                if cell.tag == tag {
                    cell.myImage.image = image
                    self.restaurantImageArray.append(image!)
                    print( self.restaurantImageAssets![indexPath.row].originalAsset?.location?.coordinate)
                    
                    if tag == 1{
                        self.photoImageView.image = image
                    }
                }
            }
            return cell
        }else{
            let asset = self.restaurantMenuImageAssets![indexPath.row]
            
            let cell = self.restaurantMenuImageCollectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! CustomCell
            
            let tag = indexPath.row + 1
            
            cell.tag = tag
            
            asset.fetchOriginalImageWithCompleteBlock { (image, info) in
                if cell.tag == tag {
                    cell.myImage.image = image
                    self.restaurantMenuImageArray.append(image!)
                    print( self.restaurantMenuImageAssets![indexPath.row].originalAsset?.location?.coordinate)
                }
            }
            return cell
        }
       
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
    
  
    //MARK: delete action
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.restaurantImageArray.removeAtIndex(indexPath.row)
        self.restaurantImageAssets?.removeAtIndex(indexPath.row)
        self.restaurantImageCollectionView.deleteItemsAtIndexPaths([indexPath])
        reloadRestaurantImageCollectionView()
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
                
                print(self.restaurantImageArray.count)
                
                for i in 0 ..< self.restaurantImageArray.count{
                    let imagePickedData = UIImageJPEGRepresentation(self.restaurantImageArray[i], 0.3)!
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
    
    
    func showRestaurantImagePickerWithAssetType(assetType: DKImagePickerControllerAssetType,
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
        
        pickerController.defaultSelectedAssets = self.restaurantImageAssets
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            self.restaurantImageArray.removeAll()
            self.restaurantImageAssets = assets
            self.reloadRestaurantImageCollectionView()
        }
        
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            pickerController.modalPresentationStyle = .FormSheet;
        }
        
        self.presentViewController(pickerController, animated: true) {}
    }
    
    func showRestaurantMenuImagePickerWithAssetType(assetType: DKImagePickerControllerAssetType,
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
        
        pickerController.defaultSelectedAssets = self.restaurantMenuImageAssets
        
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            self.restaurantMenuImageArray.removeAll()
            self.restaurantMenuImageAssets = assets
            self.reloadRestaurantMenuImageCollectionView()
        }
        
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            pickerController.modalPresentationStyle = .FormSheet;
        }
        
        self.presentViewController(pickerController, animated: true) {}
    }

}
