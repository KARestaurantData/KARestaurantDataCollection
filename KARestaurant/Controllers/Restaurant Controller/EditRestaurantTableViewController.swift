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
    
    
    // Location Property
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    // Restaurant Location
    var restaurantLocation: CLLocation = CLLocation()
    
    var restaurant: Restaurants?
    
    var imageArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/abaddon_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/alchemist_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/ancient_apparition_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/antimage_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/arc_warden_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/axe_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/bane_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/batrider_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/beastmaster_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/bloodseeker_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/bounty_hunter_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/brewmaster_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/bristleback_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/broodmother_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/centaur_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/chaos_knight_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/chen_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/clinkz_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/crystal_maiden_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/dark_seer_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/dazzle_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/death_prophet_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/disruptor_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/doom_bringer_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/dragon_knight_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/drow_ranger_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/earthshaker_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/earth_spirit_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/elder_titan_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/ember_spirit_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/enchantress_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/enigma_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/faceless_void_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/furion_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/gyrocopter_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/huskar_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/invoker_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/jakiro_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/juggernaut_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/keeper_of_the_light_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/kunkka_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/legion_commander_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/leshrac_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/lich_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/life_stealer_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/lina_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/lion_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/lone_druid_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/luna_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/lycan_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/magnataur_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/medusa_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/meepo_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/mirana_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/morphling_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/naga_siren_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/necrolyte_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/nevermore_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/night_stalker_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/nyx_assassin_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/obsidian_destroyer_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/ogre_magi_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/omniknight_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/oracle_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/phantom_assassin_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/phantom_lancer_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/phoenix_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/puck_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/pudge_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/pugna_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/queenofpain_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/rattletrap_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/razor_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/riki_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/rubick_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/sand_king_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/shadow_demon_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/shadow_shaman_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/shredder_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/silencer_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/skeleton_king_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/skywrath_mage_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/slardar_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/slark_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/sniper_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/spectre_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/spirit_breaker_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/storm_spirit_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/sven_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/techies_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/templar_assassin_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/terrorblade_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/tidehunter_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/tinker_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/tiny_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/treant_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/troll_warlord_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/tusk_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/undying_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/ursa_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/vengefulspirit_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/venomancer_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/viper_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/visage_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/warlock_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/weaver_full.png")
        
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/windrunner_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/winter_wyvern_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/wisp_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/witch_doctor_full.png")
        imageArray.append("http://cdn.dota2.com/apps/dota2/images/heroes/zuus_full.png")
        
        
        self.restaurantImageCollectionView.delegate = self
        self.restaurantImageCollectionView.dataSource = self
        
        self.restaurantMenuImageCollectionView.delegate = self
        self.restaurantMenuImageCollectionView.dataSource = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
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
            return self.imageArray.count ?? 0
        }else{
            return self.imageArray.count ?? 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.isEqual(self.restaurantImageCollectionView){
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! EditRestaurantCollectionViewCell
          
            
            
            cell.restaurantImageView.image = cell.setImageWithUrl(imageArray[indexPath.row])
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
//                    self.restaurantImageArray.append(image!)
//                    
//                    if tag == 1{
//                        self.photoImageView.image = image
//                    }
//                }
//            }
//            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! EditRestaurantCollectionViewCell
            
             cell.setMenuImageWithUrl(imageArray[indexPath.row])
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
//                    self.restaurantMenuImageArray.append(image!)
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
            
            self.restaurantImageArray.removeAtIndex(indexPath.row)
            self.restaurantImageAssets.removeAtIndex(indexPath.row)
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
                print("didSelectAssets")
                self.restaurantImageArray.removeAll()
                self.restaurantImageAssets = assets
                self.reloadRestaurantImageCollectionView()
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
