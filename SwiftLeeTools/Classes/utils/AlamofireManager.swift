//
//  AlamofireManager.swift
//  TopsProSys
//
//  Created by 李天星 on 2019/7/16.
//  Copyright © 2019年 com.topscommmac01. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireManager: NSObject {
    static let sharedSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 //超时时间为30秒
        return Alamofire.SessionManager(configuration: configuration)
    }()

    /// 获取token
    static func getToken() -> [String:String]{
        let token = UserDefaults.standard.string(forKey: "token")
        var httpHeader = ["Authorization":""]
        if let resultToken = token{
            httpHeader = ["Authorization":resultToken]
        }
        return httpHeader
    }
}


