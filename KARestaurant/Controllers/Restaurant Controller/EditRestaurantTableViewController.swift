//
//  EditRestaurantTableViewController.swift
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
import ObjectMapper
import ImageSlideshow

class EditRestaurantTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource, CLLocationManagerDelegate {
    
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
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var restaurantImageLabel: MaterialLabel!
    @IBOutlet weak var browseRestaurantImageButton: RaisedButton!
    @IBOutlet weak var restaurantMenuImageLabel: MaterialLabel!
    @IBOutlet weak var browseRestaurantMenuImageButton: RaisedButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var restaurantImageCollectionView: UICollectionView!
    @IBOutlet weak var restaurantMenuImageCollectionView: UICollectionView!
    
    var isDelivery: Bool = false
    
    // DKImagePicker Property
    var restaurantImageAssets = [DKAsset]()
    var restaurantMenuImageAssets = [DKAsset]()
    var restaurantImageArray = [UIImage]()
    var restaurantMenuImageArray = [UIImage]()
    
    struct DKImagePickerType {
        static let types: [DKImagePickerControllerAssetType] = [.AllAssets, .AllPhotos, .AllVideos, .AllAssets]
    }
    
    
    // DownPicker Property
    var restaurantTypeDownPicker, districtDownPicker, communeDownPicker: DownPicker!
    
    // create the array of data
    var responseCommune = [Commune]()
    var responseDistrict = [District]()
    var responseCategory = [Category]()
    var communeArray = [String]()
    var districtArray = [String]()
    var categoryArray = [String]()
    
    // Restaurant Location
    var restaurantLocation: CLLocation = CLLocation()
    
    var restaurant: Restaurants?
    
    var arrayOfDicImageWithUrl = [Int : String]()
    
    var urlArray = [String]()
    
    var rootImageArray = [AnyObject]()
    
    var deleteImageArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfDicImageWithUrl[1] = "http://cdn.dota2.com/apps/dota2/images/heroes/abaddon_full.png"
        arrayOfDicImageWithUrl[2] = "http://cdn.dota2.com/apps/dota2/images/heroes/alchemist_full.png"
        arrayOfDicImageWithUrl[3] = "http://cdn.dota2.com/apps/dota2/images/heroes/ancient_apparition_full.png"
        
        
        reloadRootImageArray()
        
        
        self.restaurantImageCollectionView.delegate = self
        self.restaurantImageCollectionView.dataSource = self
        
        self.restaurantMenuImageCollectionView.delegate = self
        self.restaurantMenuImageCollectionView.dataSource = self
        
        
        navigationItem.title = restaurant?.name
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        restaurantDescriptionTextField.delegate = self
        homeTextField.delegate = self
        streetTextField.delegate = self
        phoneTextField.delegate = self
        restaurantTypeTextField.delegate = self
        districtTextField.delegate = self
        communeTextField.delegate = self
        
        // Enable the Save button only if the text field has a valid Restaurant name.
        checkValidRestuarantField()
        
        prepareView()
        prepareLabel()
        prepareTextField()
        prepareDownPicker()
        prepareEmailField()
    }
    
    func reloadRootImageArray() {
        rootImageArray.removeAll()
        
        let unSortedCodeKeys = Array(arrayOfDicImageWithUrl.keys)
        let sortedCodeKeys = unSortedCodeKeys.sort(<)
        
        for key in sortedCodeKeys {
            rootImageArray.append(arrayOfDicImageWithUrl[key]!)
        }
        
        for index in 0...self.restaurantImageArray.count {
            if self.restaurantImageAssets.count !=  0 && index < self.restaurantImageAssets.count {
                rootImageArray.append(restaurantImageArray[index])
                
                if index == self.restaurantImageAssets.count - 1 {
                    self.reloadRestaurantImageCollectionView()
                    
                }
            }
        }
    }
    
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
        deliveryCheckBox.stateChangeAnimation = M13Checkbox.Animation.Fill
    }
    
    /// Prepares the TextField.
    private func prepareTextField() {
        self.nameTextField.text = restaurant?.name
        self.restaurantDescriptionTextField.text = restaurant?.restDescription
        self.homeTextField.text = restaurant?.location?.homeNumber
        self.streetTextField.text = restaurant?.location?.street
        self.phoneTextField.text = restaurant?.telephone?.number
    }
    
    private func prepareCheckBox() {
        self.deliveryCheckBox.setCheckState(NSString(string: (restaurant?.isDeliver)!).boolValue ? M13Checkbox.CheckState.Checked : M13Checkbox.CheckState.Unchecked, animated: true)
    }
    
    private func prepareLabel() {
        deliveryLabel.font = deliveryLabel.font.fontWithSize(16)
        restaurantImageLabel.font = restaurantImageLabel.font.fontWithSize(16)
        restaurantMenuImageLabel.font = restaurantMenuImageLabel.font.fontWithSize(16)
    }
    
    private func prepareDownPicker(){
        // getRestaurantType()
        // getDistrict(12315)
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
    
    private func prepareImage(){
        
    }
    
    @IBAction func downPickerEditingDidEnd(sender: TextField) {
        if sender.isEqual(self.districtTextField){
            getCommune(self.responseDistrict[self.districtDownPicker.selectedIndex].id!)
        }
        checkValidRestuarantField()
    }
    
    // MARK: Fetch Data
    func getRestaurantType(){
        // get restuarant
        let url = Constant.GlobalConstants.URL_BASE + "/v1/api/admin/categories"
        
        Alamofire.request(.GET, url, headers: Constant.GlobalConstants.headers).responseJSON { response in
            
            let responseData = Mapper<CategoryResponse>().map(response.result.value)
            self.responseCategory = (responseData?.data)!
            
            var categoryName = String()
            
            for restaurantType in (responseData?.data)! {
                self.categoryArray.append(restaurantType.name!)
                if restaurantType.id == Int((self.restaurant?.category)!){
                    categoryName = restaurantType.name!
                }
            }
            
            self.restaurantTypeDownPicker = DownPicker(textField: self.restaurantTypeTextField, withData: self.categoryArray)
            self.restaurantTypeDownPicker.setPlaceholder("Please select restaurant type")
            self.restaurantTypeDownPicker.setPlaceholderWhileSelecting("Restaurant Type")
            self.restaurantTypeDownPicker.shouldDisplayCancelButton = false
            self.restaurantTypeDownPicker.getTextField().text = categoryName
        }
    }
    
    func getDistrict(cityId: Int){
        // get restuarant
        let url = Constant.GlobalConstants.URL_BASE + "/v1/api/admin/cities/\(cityId)/districts"
        
        Alamofire.request(.GET, url, headers: Constant.GlobalConstants.headers).responseJSON { response in
            
            let responseData = Mapper<DistrictResponse>().map(response.result.value)
            self.responseDistrict = (responseData?.data)!
            
            var districtName = String()
            
            for district in (responseData?.data)! {
                self.districtArray.append(district.name!)
                if district.id == self.restaurant?.location?.district {
                    
                    districtName = district.name!
                    self.getCommune(district.id!)
                }
            }
            
            self.districtDownPicker =  DownPicker(textField: self.districtTextField, withData: self.districtArray)
            self.districtDownPicker.setPlaceholder("Please select district")
            self.districtDownPicker.setPlaceholderWhileSelecting("District")
            self.districtDownPicker.shouldDisplayCancelButton = false
            self.districtDownPicker.getTextField().text = districtName
        }
    }
    
    
    func getCommune(districtId: Int){
        // get restuarant
        let url = Constant.GlobalConstants.URL_BASE + "/v1/api/admin/districts/\(districtId)/commnunes"
        
        Alamofire.request(.GET, url, headers: Constant.GlobalConstants.headers).responseJSON { response in
            
            let responseData = Mapper<CommuneResponse>().map(response.result.value)
            self.responseCommune = (responseData?.data)!
            
            var communeName = String()
            
            self.communeArray.removeAll()
            for commune in (responseData?.data)! {
                self.communeArray.append(commune.name!)
                if commune.id == self.restaurant?.location?.commune {
                    communeName = commune.name!
                }
            }
            self.communeTextField.text = nil
            
            self.communeDownPicker =  DownPicker(textField: self.communeTextField, withData: self.communeArray)
            self.communeDownPicker.setPlaceholder("Please select commune")
            self.communeDownPicker.setPlaceholderWhileSelecting("Commune")
            self.communeDownPicker.shouldDisplayCancelButton = false
            
            self.communeDownPicker.getTextField().text = communeName
        }
    }
    
    
    
    /// Executed when the 'return' key is pressed.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidRestuarantField()
        navigationItem.title = nameTextField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidRestuarantField() {
        
        // Disable the Save button if the text field is empty.
        if !(nameTextField.text?.isEmpty)!
            && !(restaurantDescriptionTextField.text?.isEmpty)!
            && !(homeTextField.text?.isEmpty)!
            && !(streetTextField.text?.isEmpty)!
            && !(phoneTextField.text?.isEmpty)!
            && restaurantTypeDownPicker.selectedIndex != -1
            && communeDownPicker.selectedIndex != -1
            && districtDownPicker.selectedIndex != -1
            && restaurantImageArray.count != 0
            && restaurantMenuImageArray.count != 0
        {
            saveButton.enabled = true
        }else{
            saveButton.enabled = false
        }
    }
    
    
    @IBAction func deliveryCheckBoxClick(checkbox: M13Checkbox) {
        if checkbox.checkState == M13Checkbox.CheckState.Checked {
            isDelivery = true
            deliveryLabel.textColor = MaterialColor.blue.base
        }else{
            isDelivery = false
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
        showImagePickerWithAssetType(sender, assetType: DKImagePickerType.types[0], allowMultipleType: true, sourceType: DKImagePickerControllerSourceType.Both, allowsLandscape: true, singleSelect: false);
    }
    
    func reloadRestaurantImageCollectionView(){
        self.restaurantImageCollectionView.reloadData()
        
        if self.restaurantImageAssets.count == 0 {
            self.photoImageView.image = UIImage.init(named: "defaultPhoto")
        }else{
            self.photoImageView.image = self.restaurantImageArray.first
            restaurantLocation = CLLocation()
            for image in self.restaurantImageAssets {
                if let location = image.originalAsset?.location {
                    restaurantLocation = location
                    return
                }
            }
        }
        
        checkValidRestuarantField()
    }
    
    func reloadRestaurantMenuImageCollectionView(){
        print(self.restaurantImageArray.count)
        self.restaurantMenuImageCollectionView.reloadData()
        checkValidRestuarantField()
    }
    
    //MARK: collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(self.restaurantImageCollectionView){
            return self.rootImageArray.count ?? 0
        }else{
            return self.rootImageArray.count ?? 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.isEqual(self.restaurantImageCollectionView){
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! EditRestaurantCollectionViewCell
            
            
            
            cell.setImageWithUrl(rootImageArray[indexPath.row])
            return cell
            //            let asset = self.restaurantImageAssets[indexPath.row]
            //
            //            let cell = self.restaurantImageCollectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! EditRestaurantCollectionViewCell
            //
            //            let tag = indexPath.row + 1
            //
            //            cell.tag = tag
            //
            //            asset.fetchOriginalImageWithCompleteBlock { (image, info) in
            //                if cell.tag == tag {
            //                    cell.restaurantImageView.image = image
            //                    self.restauranturlArray(image!)
            //
            //                    if tag == 1{
            //                        self.photoImageView.image = image
            //                    }
            //                }
            //            }
            //            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! EditRestaurantCollectionViewCell
            
            //             cell.setMenuImageWithUrl(imageArray[indexPath.row])
            return cell
            //            let asset = self.restaurantMenuImageAssets[indexPath.row]
            //
            //            let cell = self.restaurantMenuImageCollectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! EditRestaurantCollectionViewCell
            //
            //            let tag = indexPath.row + 1
            //
            //            cell.tag = tag
            //
            //            asset.fetchOriginalImageWithCompleteBlock { (image, info) in
            //                if cell.tag == tag {
            //                    cell.restaurantMenuImageView.image = image
            //                    self.restaurantMenuurlArray(image!)
            //                }
            //            }
            //            return cell
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
        if collectionView.isEqual(self.restaurantImageCollectionView){
            let k = self.rootImageArray.removeAtIndex(indexPath.row)
            
            if k is String{
                let keys = (arrayOfDicImageWithUrl as NSDictionary).allKeysForObject(k) as! [Int]
                arrayOfDicImageWithUrl.removeValueForKey(keys[0])
                deleteImageArray.append(keys[0])
                
            }else if k is UIImage {
                let continueIndex = indexPath.row - (arrayOfDicImageWithUrl.count)
                self.restaurantImageArray.removeAtIndex(continueIndex)
                self.restaurantImageAssets.removeAtIndex(continueIndex)
            }
            
            self.restaurantImageCollectionView.deleteItemsAtIndexPaths([indexPath])
            reloadRestaurantImageCollectionView()
        }else{
            self.restaurantMenuImageArray.removeAtIndex(indexPath.row)
            self.restaurantMenuImageAssets.removeAtIndex(indexPath.row)
            self.restaurantMenuImageCollectionView.deleteItemsAtIndexPaths([indexPath])
            reloadRestaurantMenuImageCollectionView()
        }
        
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        print("save click")
        uploadImage()
        
    }
    
    
    func uploadImage(){
        
        let url = Constant.GlobalConstants.URL_BASE + "/v1/api/admin/restaurants/multiple/register"
        
        let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
        
        let address = "12315|\(self.responseDistrict[self.districtDownPicker.selectedIndex].id!)|\(self.responseCommune[self.communeDownPicker.selectedIndex].id!)|\(self.homeTextField.text!)|\(self.streetTextField.text!)"
        
        Alamofire.upload(
            .POST,
            url,
            headers: Constant.GlobalConstants.headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: self.nameTextField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "NAME")
                
                multipartFormData.appendBodyPart(data: self.restaurantDescriptionTextField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "DESCRIPTION")
                
                multipartFormData.appendBodyPart(data: address.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "ADDRESS")
                
                multipartFormData.appendBodyPart(data: "\(Int(self.isDelivery))".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "IS_DELIVERY")
                
                multipartFormData.appendBodyPart(data: "1".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "STATUS")
                
                multipartFormData.appendBodyPart(data: "\(self.responseCategory[self.restaurantTypeDownPicker.selectedIndex].id!)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "RESTAURANT_CATEGORY")
                
                multipartFormData.appendBodyPart(data: "\(self.restaurantLocation.coordinate.latitude)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "LATITUDE")
                
                multipartFormData.appendBodyPart(data: "\(self.restaurantLocation.coordinate.longitude)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "LONGITUDE")
                
                multipartFormData.appendBodyPart(data: self.phoneTextField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "TELEPHONE")
                
                for i in 0 ..< self.restaurantImageArray.count{
                    let imagePickedData = UIImageJPEGRepresentation(self.restaurantImageArray[i], 0.3)!
                    multipartFormData.appendBodyPart(data: imagePickedData, name: "RESTAURANT_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
                    
                }
                
                for i in 0 ..< self.restaurantMenuImageArray.count {
                    let imagePickedData = UIImageJPEGRepresentation(self.restaurantMenuImageArray[i], 0.3)!
                    multipartFormData.appendBodyPart(data: imagePickedData, name:"MENU_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
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
    
    func showImagePickerWithAssetType(sender: RaisedButton,
                                      assetType: DKImagePickerControllerAssetType,
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
        
        
        if sender.isEqual(self.browseRestaurantImageButton){
            pickerController.defaultSelectedAssets = self.restaurantImageAssets
            
            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                self.restaurantImageAssets.removeAll()
                self.restaurantImageArray.removeAll()
                self.restaurantImageAssets = assets
                
                for index in 0...self.restaurantImageAssets.count {
                    
                    if self.restaurantImageAssets.count !=  0 && index < self.restaurantImageAssets.count {
                        
                        let asset = self.restaurantImageAssets[index]
                        
                        asset.fetchOriginalImageWithCompleteBlock { (image, info) in
                            self.restaurantImageArray.append(image!)
                            
                            if index == self.restaurantImageAssets.count - 1 {
                                self.reloadRootImageArray()
                            }
                        }
                    }
                }
            }
        }else if sender.isEqual(self.browseRestaurantMenuImageButton){
            
            pickerController.defaultSelectedAssets = self.restaurantMenuImageAssets
            
            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                print("didSelectAssets")
                
                self.restaurantMenuImageArray.removeAll()
                self.restaurantMenuImageAssets = assets
                self.reloadRestaurantMenuImageCollectionView()
                
            }
        }
        
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            pickerController.modalPresentationStyle = .FormSheet;
        }
        
        self.presentViewController(pickerController, animated: true) {}
    }
    
}
