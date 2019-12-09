//
//  ShowMySearchAndTableViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 李桂盛 on 2019/12/3.
//  Copyright © 2019 李效晋. All rights reserved.
//

import UIKit
import SwiftLeeTools

class ShowMySearchAndTableViewController: BaseSearchAndTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfig()

    }
    func setupConfig() {


        
        ///登录一下
        let loginUrl = "http://172.20.3.53:8918/" + "appCrm/userAction_checkLoginMobile.json"
        let param = ["loginName":"7886",
                     "password":"123456"]
        self.getResultMap(urlRequest: loginUrl, parameters: param) { (_) in
            
            self.searchBarPlaceholder = "searchBarPlaceholder"
            //MARK:-填充的数据
            self.contentTitles = [
                ["key":"Mobile","value":"联系电话"],
                ["key":"ProductManagerName","value":"负责人吧"]
            ]
            //MARK:-只有标题头
//            self.contentTitles = [
//            ]
            self.headerTitleKey = "ProductName"
            self.imageName = "6"
            //MARK:-搜索时可能需要添加的参数
            self.paramKey = "key"
            self.url = "http://172.20.3.53:8918/appPlm/productPlanAction_searchByKey.json"
            self.parameters = ["rows": 20, "page": 1, "sidx": "sortcode", "sord": "desc"]
            
            self.tableView.mj_header?.beginRefreshing()
        }
        
    }
    

}
