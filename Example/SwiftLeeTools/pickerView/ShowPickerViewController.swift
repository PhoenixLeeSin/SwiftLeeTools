//
//  ShowPickerViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools
let singleData = ["swift", "ObjecTive-C", "C", "C++", "java", "php", "python", "ruby", "js"]
// 每一列为数组
let multipleData = [["1天", "2天", "3天", "4天", "5天", "6天", "7天"],["1小时", "2小时", "3小时", "4小时", "5小时"],  ["1分钟","2分钟","3分钟","4分钟","5分钟","6分钟","7分钟","8分钟","9分钟","10分钟"]]

// 注意这个数据的格式!!!!!!
let multipleAssociatedData: [[[String: [String]?]]] = [// 数组
    
    [   ["交通工具": ["陆地", "空中", "水上"]],//字典
        ["食品": ["健康食品", "垃圾食品"]],
        ["游戏": ["益智游戏", "角色游戏"]]
        
    ],// 数组
    
    [   ["陆地": ["公交车", "小轿车", "自行车"]],
        ["空中": ["飞机"]],
        ["水上": ["轮船"]],
        ["健康食品": ["蔬菜", "水果"]],
        ["垃圾食品": ["辣条", "不健康小吃"]],
        ["益智游戏": ["消消乐", "消灭星星"]],
        ["角色游戏": ["lol", "cf"]]
        
    ]
]
let btnTitlesArray = ["单列数据选择",
"多列不关联数据选择",
"多列关联选择",
"省市区选择",
"日期选择",
"时间选择"]

class ShowPickerViewController: BaseUIViewViewController {

    var showLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addBtns
        for i in 0..<btnTitlesArray.count{
            let btn = CommonViews.getPickUIButton(btnTitlesArray[i])
            baseView.addSubview(btn)
            btn.tag = 100+i
            btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            btn.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.width.equalTo(120)
            }
            if i == 0 {
                btn.snp.makeConstraints { (make) in
                    make.top.equalToSuperview()
                }
            }else{
                let button = baseView.viewWithTag(100 + i - 1) as! UIButton
                btn.snp.makeConstraints { (make) in
                    make.top.equalTo(button.snp.bottom).offset(ConstantsHelp.normalPadding)
                }
            }
        }
        
        
    }
    
    @objc func btnClick(_ sender:UIButton){
        switch sender.tag {
        case 100:
            PickerViewManager.showSingleColPicker("编程语言选择", data: singleData, defaultSelectedIndex: 2) {[unowned self] (selectedIndex, selectedValue) in
                 self.showToast(message: selectedValue)
            }
        case 101:
            PickerViewManager.showMultipleColsPicker("持续时间选择", data: multipleData, defaultSelectedIndexs: [0,1,1]) {[unowned self] (selectedIndexs, selectedValues) in
                self.showToast(message: "选中了第\(selectedIndexs)行----选中的数据为\(selectedValues)")
            }
        case 102:
            // 注意这里设置的是默认的选中值, 而不是选中的下标,省得去数关联数组里的下标
            PickerViewManager.showMultipleAssociatedColsPicker("多列关联数据", data: multipleAssociatedData, defaultSelectedValues: ["交通工具","陆地","自行车"]) {[unowned self] (selectedIndexs, selectedValues) in
                self.showToast(message: "选中了第\(selectedIndexs)行----选中的数据为\(selectedValues)")
            }
        case 103:
            // 注意设置默认值得时候, 必须设置完整, 不能进行省略 ["四川", "成都", "成华区"] 比如不能设置为["四川", "成都"]
            // ["北京", "通州"] 不能设置为["北京"]
            PickerViewManager.showCitiesPicker("省市区选择", defaultSelectedValues: ["北京", "/", "/"], selectTopLevel: true) {[unowned self] (selectedIndexs, selectedValues) in
                // 处理数据
                let combinedString = selectedValues.reduce("", { (result, value) -> String in
                    result + " " + value
                })
                self.showToast(message: combinedString)
                
            }
        case 104:
            PickerViewManager.showDatePicker("日期选择") {[unowned self] ( selectedDate) in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let string = formatter.string(from: selectedDate)
                self.showToast(message: string)
            }
        case 105:
            // style里面可以更改的和系统的DatePicker属性是一一对应的
            var dateStyle = DatePickerSetting()
            dateStyle.dateMode = .time
            
            PickerViewManager.showDatePicker("时间选择", datePickerSetting: dateStyle) { (selectedDate) in
                let formatter = DateFormatter()
                // H -> 24小时制
                formatter.dateFormat = "HH: mm"
                let string = formatter.string(from: selectedDate)
                self.showToast(message: string)
            }
            
        default:
            break;
        }
    }

}
