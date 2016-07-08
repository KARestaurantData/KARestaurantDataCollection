//
//  KaAlert.swift
//  KARestaurant
//
//  Created by Kokpheng on 6/16/16.
//  Copyright © 2016 KARestaurant. All rights reserved.
//

import UIKit
import SCLAlertView
class KaAlert: NSObject {
    // Create Custom Completion Name
    typealias ButtonName = (buttonName: String) -> Void
    
    static func show(title: String, subTitle: String, duration: NSTimeInterval?=0.0, completeText: String?="Close", style: SCLAlertViewStyle? = .Success, showCloseButton: Bool?=false, colorStyle: UInt?=0x00ACC1, colorTextButton: UInt?=0xFFFFFF, circleIconImage: UIImage? = UIImage(named:"shop"), appearance: SCLAlertView.SCLAppearance?=nil, firstButton: String? = nil, secondButton: String? = nil, completeion: ButtonName) {
       
        var alert : SCLAlertView
        // Set Default SCLAppearance
        if appearance == nil {
            let appearance = SCLAlertView.SCLAppearance( showCloseButton: showCloseButton! )
             alert = SCLAlertView(appearance: appearance)
        }else{
            alert = SCLAlertView(appearance: appearance!)
        }
        
        // Add Button
        if firstButton != nil{
            alert.addButton(firstButton!) {
                completeion(buttonName: firstButton!)
            }
        }
        
        if secondButton != nil{
            alert.addButton(secondButton!) {
                completeion(buttonName: secondButton!)
            }
        }
        
        alert.showTitle(
            title, // Title of view
            subTitle: subTitle, // String of view
            duration: duration, // Duration to show before closing automatically, default: 0.0
            completeText: completeText, // Optional button value, default: ""
            style: style!, // Styles - see below.
            colorStyle: colorStyle,
            colorTextButton: colorTextButton,
            circleIconImage: circleIconImage
        )
    }
}
