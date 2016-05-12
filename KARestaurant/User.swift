//
//  User.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/12/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import Foundation

class User: NSObject {
    private var _userId : NSString!
    private var _username : NSString!
    private var _email : NSString!
    private var _gender : NSString!
    
    
    var userId : NSString{
        set{
            _userId = newValue
        }
        get{
            return _userId
        }
    }
    
    var username : NSString{
        set{
            _username = newValue
        }
        get{
            return _username
        }
    }
    
    var email : NSString{
        set{
            _email = newValue
        }
        get{
            return _email
        }
    }
    
    var gender : NSString{
        set{
            _gender = newValue
        }
        get{
            return _gender
        }
    }
    
    init(userId: NSString, username: NSString, email: NSString, gender: NSString) {
        _userId = userId
        _username = username
        _email = email
        _gender = gender
    }
}
