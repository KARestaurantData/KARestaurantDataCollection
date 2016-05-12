//
//  User.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/12/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import Foundation
import Alamofire

class User {
    private var _userId : String!
    private var _username : String!
    private var _email : String!
    private var _gender : String!
    
    init(userId: String, username: String, email: String, gender: String) {
        _userId = userId
        _username = username
        _email = email
        _gender = gender
    }
    
    var userId : String{
        set{
            _userId = newValue
        }
        get{
            return _userId
        }
    }
    
    var username : String{
        set{
            _username = newValue
        }
        get{
            return _username
        }
    }
    
    var email : String{
        set{
            _email = newValue
        }
        get{
            return _email
        }
    }
    
    var gender : String{
        set{
            _gender = newValue
        }
        get{
            return _gender
        }
    }
    
    
    func downloadUserDetail(complete: DownloadComplete){
//        Alamofire.request(.GET, "url").responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
//        
//        
//        }
    }
}
