//
//  RequestViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools
import SwiftyJSON
import SnapKit
import QorumLogs
import Alamofire

class RequestViewController: BaseUIViewViewController {

    //登录
    let loginUIButton = UIButton()
    //请求所有
    let allUIButton = UIButton()
    //请求dataList
    let dataListUIButton = UIButton()
    //请求listDataMap
    let listDataMapUIButton = UIButton()
    //数据展示
    let resultUILabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    

    func initView(){
        loginUIButton.setTitle("登录", for: .normal)
        loginUIButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.baseView.addSubview(loginUIButton)
        loginUIButton.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        loginUIButton.addTarget(self, action: #selector(loginTo), for: .touchDown)
        
        allUIButton.setTitle("dataMap", for: .normal)
        allUIButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.baseView.addSubview(allUIButton)
        allUIButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginUIButton.snp.bottom).offset(ConstantsHelp.topMargin)
            make.left.right.equalToSuperview()
        }
        allUIButton.addTarget(self, action: #selector(allGet), for: .touchDown)
        
        
    }
    
    
    @objc func loginTo(){
        print("loingTo")
        let parameters:Parameters = ["loginname":"7886",
                                    "password":"123456",
                                    "uuid":"105DA37F-B657-45DD-AAE4-5F91D79D0B4E",
                                    "ismobile":"1",
                                    "needToken":"1",
                                    "showLoading":"false"
            ] as [String : Any]
    
        let url = "http://172.20.3.53:8919/toa/toa/toaMobileLogin_login.json";
        getResultMap(urlRequest: url, parameters: parameters) { (json) in
            self.showAlert(message: "json = \(json)")
        }
    }
    

    @objc func allGet(){
        print("dataMapGet")
        let parameters:Parameters = ["loginName":"0903",
                                     "password":"lxj010203",
                                     "baseType":0,
                                     "LastMsgTime":"",
                                     "newMsgIds":"",
                                     "showLoading":"false"
            ] as [String : Any]
        
        let url = "http://172.20.3.53:8918/mobile/userAction_checkLoginForMobile.json";
        getResultTotalMap(urlRequest: url, parameters: parameters) { (json) in
            self.showAlert(message: "json = \(json)")
        }
    }
    
    
    
    
}
