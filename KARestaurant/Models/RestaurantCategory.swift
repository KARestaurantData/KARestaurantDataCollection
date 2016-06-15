//
//  RestaurantCategory.swift
//  KARestaurant
//
//  Created by pheng on 6/9/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import Foundation
import ObjectMapper

class  CategoryResponse: Mappable {
    var message : String?
    var code : String?
    var data : [Category]?
    
    required init?(_ map: Map){
        
    }
    
    required init?(){
        
    }
    
    func mapping(map: Map) {
        message <- map["MESSAGE"]
        code <- map["CODE"]
        data <- map["DATA"]
    }
}

class Category: Mappable{
    var id : Int?
    var name : String?
    var categoryDescription : String?
    //var parent : [Category]?
    var status : String?
    var index : Int?
    var level : String?
    var createDate : String?
    var categoryCreatedBy : [CategoryCreatedBy]?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["ID"]
        name <- map["NAME"]
        categoryDescription <- map["DESCRIPTION"]
       // parent <- map["PARENT"]
        status <- map["STATUS"]
        index <- map["INDEX"]
        level <- map["LEVEL"]
        createDate <- map["CREATED_DATE"]
        categoryCreatedBy <- map["CREATED_BY"]
    }
}



class CategoryCreatedBy: Mappable {
    var id : Int?
    var email : String?
    var status : String?
    var username : String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["ID"]
        email <- map["EMAIL"]
        status <- map["STATUS"]
        username <- map["USERNAME"]
    }
}
