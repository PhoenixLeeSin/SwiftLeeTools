//
//  MyWebViewController.swift
//  topsiOSPro_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools

class MyWebViewController: ProgressWebViewController {
    
    public let appDeleagte = UIApplication.shared.delegate  as! AppDelegate
    public var isPortrait = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:-设置cookie
//        var cookieProperties = [HTTPCookiePropertyKey:String]()
//        cookieProperties[HTTPCookiePropertyKey.name] = "JSESSIONID" as String
//        cookieProperties[HTTPCookiePropertyKey.value] = "B77C0AA2444901DC555C3F158615285C" as String
//        cookieProperties[HTTPCookiePropertyKey.domain] = "172.20.3.53" as String
//        cookieProperties[HTTPCookiePropertyKey.path] = "/er" as String
//        
//        self.cookies = [HTTPCookie(properties: cookieProperties)!]
        //NARK:-设置headers
        self.headers = ["Authorization":"90d67db63b0a4653983c18ff783afd77"]
        // Do any additional setup after loading the view.
    }
//    override func rotateDidClick(sender: AnyObject) {
//        if isPortrait{
//            appDeleagte.allowRotation = true
//            isPortrait = false
//            let value = UIInterfaceOrientation.landscapeRight.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//        }else{
//            appDeleagte.allowRotation = false
//            isPortrait = true
//            let value = UIInterfaceOrientation.portrait.rawValue
//            UIDevice.current.setValue(value, forKey: "orientation")
//        }
//    }

}
