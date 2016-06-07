//
//  Constrants.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/12/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//


// This is a global accessable file
import UIKit

class Constant{
    struct GlobalConstants {
        // Constant define here.
        static let URL_BASE = "http://192.168.178.5:8080/RESTAURANT_API"
        static let URL_BASE_KA = "http://api2.khmeracademy.org"
        static let URL_USER_KA = "/api/authentication/mobilelogin"
        
        
        static let headers = [
            "Authorization": "Basic cmVzdGF1cmFudEFETUlOOnJlc3RhdXJhbnRQQFNTV09SRA==",
            "Accept": "application/json; charset=utf-8"
        ]
        
        static let headers_ka = [
            "Authorization": "Basic S0FBUEkhQCMkOiFAIyRLQUFQSQ==",
            "Accept": "application/json; charset=utf-8"
        ]
    }
}

typealias DownloadComplete = () -> ()