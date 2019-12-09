//
//  VerifyDataViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools

class VerifyDataViewController: BaseUIViewViewController {
    let resultUILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        //展示结果
        resultUILabel.numberOfLines = 0
        resultUILabel.lineBreakMode = .byCharWrapping
        self.view.addSubview(resultUILabel)
        resultUILabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            } else {
                make.top.equalTo(topLayoutGuide.snp.top)
            }
        }
        
        //
        let verifyUIButton = UIButton()
        verifyUIButton.setTitle("这是测试testCoreData", for: .normal)
        verifyUIButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.view.addSubview(verifyUIButton)
        verifyUIButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(resultUILabel.snp.bottom).offset(30)
        }
        verifyUIButton.addTarget(self, action: #selector(verifyData(button:)), for: .touchDown)
    }

    @objc func verifyData(button:UIButton){
        var result = "鲁B:123456是车牌号码：" + String(VerifyHelp.isCarNumber(number: "鲁B:123456")) + "\r\n"
        result = result + "12345678901是电话号码：" + String(VerifyHelp.isPhoneNumber(phoneNumber: "12345678901")) + "\r\n"
        result = result + "371323199007077878是身份证:" + String(VerifyHelp.isIdNumber(idNumber: "371323199007077878")) + "\r\n"
        result = result + "leesin@gmail.com是邮箱:" + String(VerifyHelp.isEmail(email: "leesin@gmail.com")) + "\r\n"
        resultUILabel.text = result
    }
    
    
}
