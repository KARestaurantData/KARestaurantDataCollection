//
//  City.swift
//  KARestaurant
//
//  Created by pheng on 6/9/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import Foundation
import ObjectMapper

class  CityResponse: Mappable {
    var message : String?
    var code : String?
    var data : [City]?
    
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

class City: Mappable{
    var id : Int?
    var name : String?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["ID"]
        name <- map["NAME"]
    }
}

class  DistrictResponse: Mappable {
    var message : String?
    var code : String?
    var data : [District]?
    
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

class District: Mappable{
    var id : Int?
    var name : String?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["ID"]
        name <- map["NAME"]
    }
}



class  CommuneResponse: Mappable {
    var message : String?
    var code : String?
    var data : [Commune]?
    
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

class Commune: Mappable{
    var id : Int?
    var name : String?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["ID"]
        name <- map["NAME"]
    }
}



class  VillageResponse: Mappable {
    var message : String?
    var code : String?
    var data : [Village]?
    
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

class Village: Mappable{
    var id : Int?
    var name : String?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["ID"]
        name <- map["NAME"]
    }
}

