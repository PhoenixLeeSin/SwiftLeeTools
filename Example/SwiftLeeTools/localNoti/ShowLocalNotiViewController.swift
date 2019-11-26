//
//  ShowLocalNotiViewController.swift
//  topsiOSPro_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools
import SwiftDate
import SwiftyJSON

class ShowLocalNotiViewController: BaseUIViewViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "本地推送"
        let button = CommonViews.getSubmitUIButton("发送本地推送")
        baseView.addSubview(button)
        button.snp.remakeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        button.addTarget(self, action: #selector(localNoti(_ :)), for: .touchUpInside)
    }
    
    @objc func localNoti(_ sender:UIButton){
        if #available(iOS 10.0, *) {
            let date = Date() + 8.hours + 10.seconds
            NotificationManager.add(id: "aa.com.sdsds", title: "我是主标题", time: date, subtitle: "我是副标题", body: "我是内容", badge: 2, userInfo: ["key":"value"])
        }
    }

}
