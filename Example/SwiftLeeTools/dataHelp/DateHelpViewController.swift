//
//  DateHelpViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools

class DateHelpViewController: BaseUIViewViewController {

    let resultUILabel = UILabel()
    let helpUIButton = UIButton()
    
    override  func viewDidLoad() {
        super.viewDidLoad()

        initViews()
    }
    

    func initViews(){
        helpUIButton.setTitle("获取结果", for: .normal)
        helpUIButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        baseView.addSubview(helpUIButton)
        helpUIButton.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(30)
        }
        helpUIButton.addTarget(self, action: #selector(goHaha), for: .touchDown)
    
        
        baseView.addSubview(resultUILabel)
        resultUILabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(helpUIButton.snp.bottom)
        }
    }
    
    
    @objc func goHaha(){
        var result = "2019-06-03 从1970年至今的毫秒数：" + String(DateUtils.dateStringToDate(dateStr: "2019-06-03",type: DateFormateType.YMD)!.timeIntervalSince1970) + "\r\n"
        result = result + "2019-06-03和2019-07-03之间的天数差 ：\(DateUtils.dateDifference(start: "2019-06-03", end: "2019-07-03"))" + "\r\n"
        result = result + "获取当前时间：" + DateUtils.getCurrentTime() + "\r\n"
        result = result + "获取2天前的时间：" + String(DateUtils.getDateByDays(-2).formatDate(format: .YMDHMS)) + "\r\n"
        result = result + "获取2天后的时间：" + String(DateUtils.getDateByDays(2).formatDate(format: .YMDHMS)) + "\r\n"

        
        resultUILabel.numberOfLines = 0
        resultUILabel.lineBreakMode = .byCharWrapping
        resultUILabel.text = result

    }

}
