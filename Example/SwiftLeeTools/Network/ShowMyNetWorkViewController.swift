//
//  ShowMyNetWorkViewController.swift
//  topsiOSPro_Example
//
//  Created by 李桂盛 on 2019/12/10.
//  Copyright © 2019 李桂盛. All rights reserved.
//

import UIKit
import SwiftLeeTools
import SwiftyJSON
import Alamofire

class ShowMyNetWorkViewController: BaseUIViewViewController {

    let buttons = ["基本请求","上传","下载"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
    }
    func initUI() {
        for i in 0..<buttons.count {
            let button = CommonViews.getPickUIButton(buttons[i])
            baseView.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(100 + 100 * i)
                make.centerX.equalTo(baseView.snp.centerX)
            }
            button.tag = 100+i
            button.addTarget(self, action: #selector(btnClick(_ :)), for: .touchUpInside)
        }
    }
    
    @objc func btnClick(_ sender:UIButton) {
        switch sender.tag {
        case 100: ///重连
            let parameters:Parameters = ["loginname":"7886",
                                         "password":"123456",
                                         "uuid":"105DA37F-B657-45DD-AAE4-5F91D79D0B4E",
                                         "ismobile":"1",
                                         "needToken":"1",
                                         "showLoading":"false"
                ]

            let url = "http://172.20.3.53:8919/toa/toa/toaMobileLogin_login.json";
            self.requestDataWith(url: url, param: parameters, method: .post, dataKey: .dataMap, headers: [:],isNeedRetrier: false ,success: { (json) in
                    print(json)
            }) { (errorCode) in
                print(errorCode)
            }
//            self.requestDataWith(url: "ai.apiopen.top/EmadsilSearch", param: ["number":1012002], method: .post, dataKey: DataKey.all, headers: [:],isNeedRetrier: false, success: { (json) in
//
//            }) { (errorCode) in
//                print(errorCode)
//            }
        case 101:
            let keys = ["excessreason", "invoicetype", "amount", "invoiceamount", "remark", "invoicedate"]
            let dic = ["amount" : "3",
            "invoicetype" : "transportInvoice",
            "remark" : "这",
            "excessreason" : "噢",
            "invoiceamount" : "3",
            "invoicedate" : "2019-12-10"]
            let params = JSON(dic)
            let image = UIImage(named: "2")!
            let data = image.pngData()!
            if UserDefaults.standard.value(forKey: "token") == nil {
                self.showAlert(message: "在http请求里登陆一下")
                return
            }
            let headers = ["Authorization" : UserDefaults.standard.value(forKey: "token")as! String]
            self.uploadFileWith(url: "http://172.20.3.53:8924/er/er/erInvoice_commitInvoice.json", keys: keys, parameters: params, datasArr: [data], datasInfoArr: ["aa.png"], headers: headers , success: { (json) in
                print("1111")
            }) { (errorCode) in
                print(errorCode)
            }
        case 102:
            self.downloadFileWith(url: "http://172.20.3.53:8924/er/cbo/cboAttachment_download.action?attachmentId=19120600000003", params: [:], headers: [:], success: { (path) in
                print(path)
            }) { (errorCode) in
                print(errorCode)
            }
        default:
            break;
        }
    }

}
