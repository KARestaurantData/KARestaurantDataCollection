//
//  ConnectionManager.swift
//  KARestaurant
//
//  Created by Kokpheng on 5/12/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import Foundation

class ConnectionManager {
    
    func request() {
        let urlString = "http://swapi.co/api/people/1/"
        let url = NSURL(string: urlString)!
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithURL(url) { (data: NSData?, respone: NSURLResponse?, error: NSError?) -> Void in
            
            if let responeData = data{
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(responeData, options: NSJSONReadingOptions.AllowFragments)
                    
                    if let dictionaryData = json as? Dictionary<String, AnyObject>{
                        
                        
                    }
                    
                    print(json)
                    
                }catch{
                    print("Could not serialize")
                }
            }
            }.resume()
        
    }
}