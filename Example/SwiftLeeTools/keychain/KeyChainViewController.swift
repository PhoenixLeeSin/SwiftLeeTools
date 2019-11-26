//
//  KeyChainViewController.swift
//  topsiOSPro_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools


class KeyChainViewController: BaseUIViewViewController {

    var resultUILabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    

    func initViews(){
        let saveUIButton = CommonViews.getSubmitUIButton("保存")
        baseView.addSubview(saveUIButton)
        saveUIButton.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        saveUIButton.addTarget(self, action: #selector(saveIn), for: .touchDown)
        
        
        let readUIButton = CommonViews.getSubmitUIButton("读取")
        baseView.addSubview(readUIButton)
        readUIButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(saveUIButton.snp.bottom).offset(ConstantsHelp.topMargin)
        }
        readUIButton.addTarget(self, action: #selector(readOut), for: .touchDown)
        
        let deleteUIButton = CommonViews.getSubmitUIButton("删除")
        baseView.addSubview(deleteUIButton)
        deleteUIButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(readUIButton.snp.bottom).offset(ConstantsHelp.topMargin)
        }
        deleteUIButton.addTarget(self, action: #selector(deleteMe), for: .touchDown)
        
    }
    
    
    
    @objc func saveIn(){
        let result:Bool =  KeychainManager.keyChainSaveData(data: "hello", withIdentifier: "hi")
        showToast(message: "保存结果:\(result)")
    }
    
    @objc func readOut(){
        let result:String =  KeychainManager.keyChainReadData(identifier: "hi")
        showToast(message: "读取结果:\(result)")
    }
    
    @objc func deleteMe(){
        let result = KeychainManager.keyChianDelete(identifier: "hi")
        showToast(message: "删除成功")
    }
    
    

}
