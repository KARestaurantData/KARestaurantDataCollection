//
//  Image.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/19/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import Foundation
import ObjectMapper

class ImageUpload: Mappable
{
    var code : String?
    var imageName : String?
    var imageUrl : String?
    var message : String?

    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        code <- map["CODE"]
        imageName <- map["IMAGE_NAME"]
        imageUrl <- map["IMAGE_URL"]
        message <- map["MESSAGE"]
    }
}

class ImageUploadResponse: Mappable {
    var message: String?
    var code: String?
    var image: [ImageUpload]?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        message <- map["MESSAGE"]
        code <- map["CODE"]
        image <- map["IMAGES"]
    }
}

