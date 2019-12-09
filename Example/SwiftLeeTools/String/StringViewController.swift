//
//  StringViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SnapKit
import SwiftLeeTools

class StringViewController: UIViewController {

    let resultUILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        
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
        let getPrefixNStrUIButton = UIButton()
        getPrefixNStrUIButton.setTitle("这是测试testCoreData", for: .normal)
        getPrefixNStrUIButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.view.addSubview(getPrefixNStrUIButton)
        getPrefixNStrUIButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(resultUILabel.snp.bottom)
        }
        getPrefixNStrUIButton.addTarget(self, action: #selector(getPrefixNStr(button:)), for: .touchDown)
        
    }
    
    
    
    @objc func getPrefixNStr(button:UIButton){
        //截取前Nh个字符串
        var result:String = "前6个字符串截取结果：" + StringUtils.getPrefixNStr(currentStr: button.titleLabel!.text!,length: 6) + "\r\n"
        //截取后N个字符串
        result = result + "后6个字符串截取结果：" + StringUtils.getSuffixNStr(currentStr: button.titleLabel!.text!, length: 6) + "\r\n"
        //按开始结束位截取
        result = result + "按索引1、7截取结果：" + StringUtils.getIndexStr(currentStr: (button.titleLabel?.text!)!, start: 1, end: 7) + "\r\n"
        //获取最后一个指定字符后面的信息
        result = result + "获取字符C后面的信息：" + StringUtils.getSignBackStr(str: (button.titleLabel?.text!)!, sign: "C") + "\r\n"
        
        result = result + "获取字符D后面的信息：" + StringUtils.getSignBackStr(str: (button.titleLabel?.text!)!, sign: "D") + "\r\n"
        //小数点后3为小数
        result = result + "1.23后三位小数：" + StringUtils.decimalHold("1.23", 3, true) + "\r\n"
        
        result = result + "1后三位小数：" + StringUtils.decimalHold("1", 3, true) + "\r\n"
        //MARK:-获取指定字符串宽度
        result = result + "对光反射金盾股份手机号电饭锅地方和规划局森岛帆高Width=" + "\(StringUtils.getStrWidth(str: "对光反射金盾股份手机号电饭锅地方和规划局森岛帆高", fontSize: 16.0))" + "\r\n"
        //MARK:-获取指定字符串高度
        result = result + "对光反射金盾股份手机号电饭锅地方和规划局森岛帆高Height=" + "\(StringUtils.getStrHeight(str: "对光反射金盾股份手机号电饭锅地方和规划局森岛帆高", fontSize: 16.0))" + "\r\n"
        //MARK:-大写
        result = result + "一二三的大写为：" + "123".numberRMM() + "\r\n"
        resultUILabel.text = result
        
    }

}
