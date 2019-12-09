//
//  ListBaseViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 李桂盛 on 2019/11/28.
//  Copyright © 2019 李效晋. All rights reserved.
//

import UIKit
import JXSegmentedView
import SwiftLeeTools
import SwiftyJSON

class ListBaseViewController: BaseSegmentTableViewViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageName = "6"
        ///登录一下
        let loginUrl = "http://172.20.3.53:8918/" + "appCrm/userAction_checkLoginMobile.json"
        let param = ["loginName":"7886",
                     "password":"123456"]
        self.getResultMap(urlRequest: loginUrl, parameters: param) { (_) in
            
            self.url = "http://172.20.3.53:8918/appPlm/productPlanAction_listProductPlan.json"
            self.parameters = ["productLineId":"1405080000002",
            "role":2,
            "from":1,
            "page":1,
            "rows":20,
            "sidx":"sortcode",
            "to":10000,]
            self.contentTitles = [["key":"ProductName","value":"名称"],
                           ["key":"ProductManagerName","value":"负责人吧"],
                           ["key":"ProductManagerMobile","value":"手机号"]
            ]
            self.headerTitleKey = "Id"
            self.tableView.mj_header?.beginRefreshing()
        }


    }
    override func didSelectedCellWithIndexWith(json: JSON, index: Int) {
        self.showToast(message: "\(index)")
    }
}

