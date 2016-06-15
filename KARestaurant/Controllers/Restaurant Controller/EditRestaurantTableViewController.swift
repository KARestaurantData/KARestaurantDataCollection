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
import Kingfisher
import SCLAlertView
import MMMaterialDesignSpinner

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
    var restaurantUIImageArray = [UIImage]()
    var restaurantMenuUIImageArray = [UIImage]()
    
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
   // var restaurantLocation: CLLocation = CLLocation()
    
    var restaurant: Restaurant?
    
    var rootRestaurantImageArray = [AnyObject]()
    var restaurantImageFromServerDictionary = [Int : String]()
    var deleteRestaurantImageArray = [Int]()
    
    
    var rootRestaurantMenuImageArray = [AnyObject]()
    var restaurantMenuImageFromServerDictionary = [Int : String]()
    var deleteRestaurantMenuImageArray = [Int]()
    
    // Initialize the progress view
    var centerSpinner : MMMaterialDesignSpinner = MMMaterialDesignSpinner(frame: CGRectMake(0, 0, 75,75))
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        prepareRestaurantThumnail()
         prepareRefreshControl()
        
        for image in (restaurant?.images)!{
            restaurantImageFromServerDictionary[image.id!] = image.url
        }
        for image in (restaurant?.menus)!{
            restaurantMenuImageFromServerDictionary[image.id!] = image.url
        }
        
        reloadImageToRestaurantImageCollectionView()
        reloadImageToRestaurantMenuImageCollectionView()
        

        
    }
    
    func reloadImageToRestaurantImageCollectionView(){
        self.rootRestaurantImageArray.removeAll()
        
        let unSortedCodeKeys = Array(restaurantImageFromServerDictionary.keys)
        let sortedCodeKeys = unSortedCodeKeys.sort(<)
        
        for key in sortedCodeKeys {
            rootRestaurantImageArray.append(restaurantImageFromServerDictionary[key]!)
        }
        
        for index in 0...self.restaurantUIImageArray.count {
            if self.restaurantImageAssets.count !=  0 && index < self.restaurantImageAssets.count {
                rootRestaurantImageArray.append(restaurantUIImageArray[index])
                
                if index == self.restaurantImageAssets.count - 1 {
                    self.reloadRestaurantImageCollectionView()
                    
                }
            }
        }
    }
    
    func reloadImageToRestaurantMenuImageCollectionView(){
        self.rootRestaurantMenuImageArray.removeAll()

        let unSortedCodeKeys = Array(restaurantMenuImageFromServerDictionary.keys)
        let sortedCodeKeys = unSortedCodeKeys.sort(<)
        
        for key in sortedCodeKeys {
            rootRestaurantMenuImageArray.append(restaurantMenuImageFromServerDictionary[key]!)
        }
        
        for index in 0...self.restaurantMenuUIImageArray.count {
            if self.restaurantMenuImageAssets.count !=  0 && index < self.restaurantMenuImageAssets.count {
                rootRestaurantMenuImageArray.append(restaurantMenuUIImageArray[index])
                
                if index == self.restaurantMenuImageAssets.count - 1 {
                    self.reloadRestaurantMenuImageCollectionView()
                    
                }
            }
        }
    }
    
    private func prepareRefreshControl(){
        
        self.centerSpinner.center = self.view.center
        
        // Set the line width of the spinner
        self.centerSpinner.lineWidth = 5
        
        // Set the tint color of the spinner
        self.centerSpinner.tintColor = MaterialColor.cyan.darken1
        
        // Add it as a subview
        self.view.addSubview(centerSpinner)
        
        
    }
    
    private func centerSpinnerStartLoading(){
        // Start & stop animations
        self.centerSpinner.startAnimating()
        // add refresh control to view
        self.view.userInteractionEnabled = false
    }
    
    private func centerSpinnerStopLoading(){
        // Start & stop animations
        self.centerSpinner.stopAnimating()
        // add refresh control to view
        self.view.userInteractionEnabled = true
    }
    
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
        deliveryCheckBox.stateChangeAnimation = M13Checkbox.Animation.Fill
    }
    
    /// General preparation statements.
    private func prepareRestaurantThumnail() {
          self.photoImageView.kf_setImageWithURL(NSURL(string: (self.restaurant?.thumbnail)!)!, placeholderImage: UIImage(named: "defaultPhoto"), optionsInfo: nil, progressBlock: nil , completionHandler: nil)
    }
    
    /// Prepares the TextField.
    private func prepareTextField() {
        self.nameTextField.text = restaurant?.name
        self.restaurantDescriptionTextField.text = restaurant?.restDescription
        self.homeTextField.text = restaurant?.location?.homeNumber
        self.streetTextField.text = restaurant?.location?.street
        self.phoneTextField.text = restaurant?.telephone?.number
        
        if restaurant?.isDeliver == "1" {
            isDelivery = true
            deliveryCheckBox.setCheckState(M13Checkbox.CheckState.Checked, animated: true)
            deliveryLabel.textColor = MaterialColor.blue.base
        }else{
            isDelivery = false
            deliveryCheckBox.setCheckState(M13Checkbox.CheckState.Unchecked, animated: true)
            deliveryLabel.textColor = MaterialColor.grey.base
        }
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
         getRestaurantType()
         getDistrict(12315)
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
            && rootRestaurantImageArray.count != 0
            && rootRestaurantMenuImageArray.count != 0
        {
            saveButton.enabled = true
            print("true")
        }else{
            saveButton.enabled = false
            print("false")
        }
    }
    
    
    @IBAction func deliveryCheckBoxClick(checkbox: M13Checkbox) {
          checkValidRestuarantField()
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
        showImagePickerWithAssetType(sender, assetType: DKImagePickerType.types[0], allowMultipleType: true, sourceType: DKImagePickerControllerSourceType.Photo, allowsLandscape: true, singleSelect: false);
    }
    
    func reloadRestaurantImageCollectionView(){
        self.restaurantImageCollectionView.reloadData()
        checkValidRestuarantField()
    }
    
    func reloadRestaurantMenuImageCollectionView(){
        self.restaurantMenuImageCollectionView.reloadData()
        checkValidRestuarantField()
    }
    
    //MARK: collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(self.restaurantImageCollectionView){
            return self.rootRestaurantImageArray.count ?? 0
        }else{
            return self.rootRestaurantMenuImageArray.count ?? 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.isEqual(self.restaurantImageCollectionView){
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! EditRestaurantCollectionViewCell
            
            cell.setRestaurantImage(rootRestaurantImageArray[indexPath.row])
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! EditRestaurantCollectionViewCell
            
            cell.setRestaurantMenuImage(rootRestaurantMenuImageArray[indexPath.row])
            return cell
        }
        
    }
  
    
    //MARK: delete action
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.isEqual(self.restaurantImageCollectionView){
            let image = self.rootRestaurantImageArray.removeAtIndex(indexPath.row)
            
            if image is String{
                let keys = (restaurantImageFromServerDictionary as NSDictionary).allKeysForObject(image) as! [Int]
                restaurantImageFromServerDictionary.removeValueForKey(keys[0])
                deleteRestaurantImageArray.append(keys[0])
                print("delete ImageArray: \(deleteRestaurantImageArray)")
                
            }else if image is UIImage {
                let continueIndex = indexPath.row - (restaurantImageFromServerDictionary.count)
                self.restaurantUIImageArray.removeAtIndex(continueIndex)
                self.restaurantImageAssets.removeAtIndex(continueIndex)
            }
            
            self.restaurantImageCollectionView.deleteItemsAtIndexPaths([indexPath])
            reloadRestaurantImageCollectionView()
        }else{
            let image = self.rootRestaurantMenuImageArray.removeAtIndex(indexPath.row)
            
            if image is String{
                let keys = (restaurantMenuImageFromServerDictionary as NSDictionary).allKeysForObject(image) as! [Int]
                restaurantMenuImageFromServerDictionary.removeValueForKey(keys[0])
                deleteRestaurantMenuImageArray.append(keys[0])
                print("delete MenuImageArray: \(deleteRestaurantMenuImageArray)")
                
            }else if image is UIImage {
                let continueIndex = indexPath.row - (restaurantMenuImageFromServerDictionary.count)
                self.restaurantMenuUIImageArray.removeAtIndex(continueIndex)
                self.restaurantMenuImageAssets.removeAtIndex(continueIndex)
            }
            
            self.restaurantMenuImageCollectionView.deleteItemsAtIndexPaths([indexPath])
            reloadRestaurantMenuImageCollectionView()
        }
        
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        print("save click")
        self.tableView.setContentOffset(CGPointZero, animated:true)
        centerSpinnerStartLoading()
        uploadImage()
        
    }
    
    
    func uploadImage(){
        
        let url = Constant.GlobalConstants.URL_BASE + "/v1/api/admin/restaurants/\(restaurant!.id!)"
        
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
//                
//                multipartFormData.appendBodyPart(data: "\(self.restaurantLocation.coordinate.latitude)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "LATITUDE")
//                
//                multipartFormData.appendBodyPart(data: "\(self.restaurantLocation.coordinate.longitude)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "LONGITUDE")
                
                multipartFormData.appendBodyPart(data: self.phoneTextField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "TELEPHONE")
                
                for i in 0 ..< self.restaurantUIImageArray.count{
                    let imagePickedData = UIImageJPEGRepresentation(self.restaurantUIImageArray[i], 0.3)!
                    multipartFormData.appendBodyPart(data: imagePickedData, name: "RESTAURANT_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
                    
                }
                
                
                for i in 0 ..< self.deleteRestaurantImageArray.count{
                    let id = self.deleteRestaurantImageArray[i]
                    
                    multipartFormData.appendBodyPart(data: "\(id)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "RESTAURANT_IMAGES_DELETED")
                }
                
                
                for i in 0 ..< self.restaurantMenuUIImageArray.count {
                    let imagePickedData = UIImageJPEGRepresentation(self.restaurantMenuUIImageArray[i], 0.3)!
                    multipartFormData.appendBodyPart(data: imagePickedData, name:"MENU_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
                }
                
                
                for i in 0 ..< self.deleteRestaurantMenuImageArray.count{
                    let id = self.deleteRestaurantMenuImageArray[i]
                    
                    multipartFormData.appendBodyPart(data: "\(id)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "MENU_IMAGES_DELETED")
                }
                
                multipartFormData.appendBodyPart(data: keyJSON, name: "format")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response.debugDescription)
                        switch response.result {
                        case .Success:
                            print(response)
                            self.centerSpinnerStopLoading()
                            self.cancel(UIBarButtonItem())
                        case .Failure(let error):
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                                
                                //showCircularIcon: false
                                
                            )
                            
                            let alert = SCLAlertView(appearance: appearance)
                            alert.addButton("Close") {
                                // fetch data for first load
                                self.centerSpinnerStopLoading()
                                self.saveButton.enabled = true
                            }
                            
                            alert.showTitle(
                                "Connection Error", // Title of view
                                subTitle: error.localizedDescription, // String of view
                                duration: 0.0, // Duration to show before closing automatically, default: 0.0
                                completeText: "", // Optional button value, default: ""
                                style: .Success, // Styles - see below.
                                colorStyle: 0x00ACC1,
                                colorTextButton: 0xFFFFFF,
                                circleIconImage: UIImage(named: "meme")
                            )
                        }

                        
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
                self.restaurantUIImageArray.removeAll()
                self.restaurantImageAssets = assets
                
                if self.restaurantImageAssets.count == 0 {
                    return
                }
                
                
                for index in 0...self.restaurantImageAssets.count {
                    
                    if self.restaurantImageAssets.count !=  0 && index < self.restaurantImageAssets.count {
                        
                        let asset = self.restaurantImageAssets[index]
                        
                        asset.fetchOriginalImageWithCompleteBlock { (image, info) in
                            self.restaurantUIImageArray.append(image!)
                            
                            if index == self.restaurantImageAssets.count - 1 {
                                self.reloadImageToRestaurantImageCollectionView()
                            }
                        }
                    }
                }
            }
        }else if sender.isEqual(self.browseRestaurantMenuImageButton){
           pickerController.defaultSelectedAssets = self.restaurantMenuImageAssets
            
            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                self.restaurantMenuImageAssets.removeAll()
                self.restaurantMenuUIImageArray.removeAll()
                self.restaurantMenuImageAssets = assets
                
                if self.restaurantMenuImageAssets.count == 0 {
                    return
                }
                
                
                for index in 0...self.restaurantMenuImageAssets.count {
                    
                    if self.restaurantMenuImageAssets.count !=  0 && index < self.restaurantMenuImageAssets.count {
                        
                        let asset = self.restaurantMenuImageAssets[index]
                        
                        asset.fetchOriginalImageWithCompleteBlock { (image, info) in
                            self.restaurantMenuUIImageArray.append(image!)
                            
                            if index == self.restaurantMenuImageAssets.count - 1 {
                                self.reloadImageToRestaurantMenuImageCollectionView()
                            }
                        }
                    }
                }
            }
        }
        
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            pickerController.modalPresentationStyle = .FormSheet;
        }
        
        self.presentViewController(pickerController, animated: true) {}
    }
    
}
