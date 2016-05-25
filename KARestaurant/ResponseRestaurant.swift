//
//  ResponseRestaurant.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/19/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import Foundation
import ObjectMapper

class  ResponseRestaurant: Mappable {
    var message : String?
    var code : String?
    var data : [Restaurants]?
    var pagination : Pagination?
    
    required init?(_ map: Map){
        
    }
    
    required init?(){
        
    }
    
    func mapping(map: Map) {
        message <- map["MESSAGE"]
        code <- map["CODE"]
        data <- map["DATA"]
        pagination <- map["PAGINATION"]
    }
}


class Restaurants: Mappable{
    var id : Int?
    var name : String?
    var restDescription : String?
    var createdDate : String?
    var updateDate : String?
    var createdBy : CreatedBy?
    var updatedBy : String?
    var status : String?
    var address : String?
    var isDeliver : String?
    var thumbnail : String?
    var menus : [Menu]?
    var images : [Image]?
    var category : String?
    var location : Location?
    var telephone : Telephone?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["ID"]
        name <- map["NAME"]
        restDescription <- map["DESCRIPTION"]
        createdDate <- map["CREATED_DATE"]
        updateDate <- map["UPDATED_DATE"]
        createdBy <- map["CREATED_BY"]
        updatedBy <- map["UPDATED_BY"]
        status <- map["STATUS"]
        address <- map["ADDRESS"]
        isDeliver <- map["IS_DELIVERY"]
        thumbnail <- map["THUMBNAIL"]
        menus <- map["MENUS"]
        images <- map["IMAGES"]
        category <- map["CATEGORY"]
        location <- map["LOCATION"]
        telephone <- map["TELEPHONE"]
    }
}

class CreatedBy: Mappable {
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


class Menu: Mappable {
    var id : Int?
    var title : String?
    var menuDescription : String?
    var restaurant : String?
    var url : String?
    var type : String?
    var status : String?
    var createdDate : String?
    var createBy : CreatedBy?
    var isThumbmail : String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["ID"]
        title <- map["TITLE"]
        menuDescription <- map["DESCRIPTION"]
        restaurant <- map["RESTARUANT"]
        url <- map["URL"]
        type <- map["TYPE"]
        status <- map["STATUS"]
        createdDate <- map["CREATED_DATE"]
        createBy <- map["CREATED_BY"]
        isThumbmail <- map["IS_THUMBNAIL"]
    }
}

class Image: Menu {
}

class Location: Mappable {
    var longtitude : String?
    var latitude : String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        longtitude <- map["LONGITUDE"]
        latitude <- map["LATITUDE"]
    }
}

class Telephone: Mappable {
    var number : String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        number <- map["NUMBER"]
    }
}

class Pagination: Mappable {
    var page : Int?
    var limit : Int?
    var totalCount : Int?
    var totalPages : Int?
   
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        page <- map["PAGE"]
        limit <- map["LIMIT"]
        totalCount <- map["TOTAL_COUNT"]
        totalPages <- map["TOTAL_PAGES"]
        
    }
}