//
//  AddRestaurantTableViewController.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/27/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import PhotosUI
import BSImagePicker
import AssetsLibrary
import Alamofire

import DKImagePickerController
import AVKit

class AddRestaurantTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate=self
        self.collectionView.dataSource=self
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Enable the Save button only if the text field has a valid Restaurant name.
        checkValidRestuarantName()
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
    
    //MARK: PHasset
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    // MARK: Actions
    @IBAction func showImagePicker(sender: UITapGestureRecognizer) {
        showImagePickerWithAssetType(Demo.types[0], allowMultipleType: true, sourceType: DKImagePickerControllerSourceType.Both, allowsLandscape: true, singleSelect: false);
//        let vc = BSImagePickerViewController()
//        vc.maxNumberOfSelections = 6
//        
//        bs_presentImagePickerController(vc, animated: true,
//                                        select: { (asset: PHAsset) -> Void in
//                                            print("Selected image:\(asset)")
//                                            self.photoImageView.image = self.getAssetThumbnail(asset)
//                                            self.imageArray.append(self.getAssetThumbnail(asset))
//                                            print(self.imageArray.count)
//                                            
//                                            
//                                            self.collectionView.reloadData()
//                                            
//            }, deselect: { (asset: PHAsset) -> Void in
//                print("Deselected: \(asset)")
//            }, cancel: { (assets: [PHAsset]) -> Void in
//                print("Cancel: \(assets)")
//            }, finish: { (assets: [PHAsset]) -> Void in
//                self.collectionView.reloadData()
//                print("Finish: \(assets)")
//            }, completion:nil)
    }
    
    func reloadTable(){
        self.collectionView.reloadData()
    }
    
    //MARK: collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
         let asset = self.assets![indexPath.row]
        
//        if asset.isVideo {
//            cell = collectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! CustomCell
//
//            imageView = cell?.contentView.viewWithTag(1) as? UIImageView
//        } else {
//            cell = collectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! CustomCell
//
//            imageView = cell?.contentView.viewWithTag(1) as? UIImageView
//        }
        
       let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! CustomCell
    
        
        let tag = indexPath.row + 1

        cell.tag = tag
        asset.fetchOriginalImageWithCompleteBlock { (image, info) in
            if cell.tag == tag {
                cell.myImage.image = image
                 self.imageArray.append(image!)
            }
        }
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    //    override func tableView(tableView: UITableView,
    //                            numberOfRowsInSection section: Int) -> Int {
    //        return imgarray.count
    //    }
    //
    //    override func tableView(tableView: UITableView,
    //                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //
    //        let cell = tableView.dequeueReusableCellWithIdentifier("cell",
    //                                                               forIndexPath: indexPath)
    //
    //        return cell
    //    }
    //    override func tableView(tableView: UITableView,
    //                            willDisplayCell cell: UITableViewCell,
    //                                            forRowAtIndexPath indexPath: NSIndexPath) {
    //
    //        guard let tableViewCell = cell as? CustomTableViewCell else { return }
    //
    //        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    //    }
    
    
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
        self.collectionView.deleteItemsAtIndexPaths([indexPath])
        self.collectionView.reloadData()
        
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
                    let imagePickedData = UIImageJPEGRepresentation(self.imageArray[i], 1.0)!
                    print("add")
                    
                    multipartFormData.appendBodyPart(data: imagePickedData, name: "MENU_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
                    multipartFormData.appendBodyPart(data: imagePickedData, name:"RESTAURANT_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
                    
                }
//                
//                for photo in self.imageArray {
//                    let imagePickedData = UIImageJPEGRepresentation(photo, 1.0)!
//                    print("add")
//                    
//                    multipartFormData.appendBodyPart(data: imagePickedData, name: "MENU_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
//                    multipartFormData.appendBodyPart(data: imagePickedData, name:"RESTAURANT_IMAGES", fileName: ".jpg", mimeType: "image/jpeg")
//                }
                
                multipartFormData.appendBodyPart(data: keyJSON, name: "format")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response)
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
            self.collectionView?.reloadData()
        }
        
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            pickerController.modalPresentationStyle = .FormSheet;
        }
        
        self.presentViewController(pickerController, animated: true) {}
    }

}
