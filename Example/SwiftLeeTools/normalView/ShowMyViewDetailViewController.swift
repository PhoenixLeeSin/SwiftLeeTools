//
//  ShowMyViewDetailViewController.swift
//  topsiOSPro_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools
import SwiftyJSON

class ShowMyViewDetailViewController: BaseUIViewViewController {

    var index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showViewWith()
    }
    func showViewWith(){
        for sub in baseView.subviews{
            sub.removeFromSuperview()
        }
        switch index {
            //MARK:-申请填写 粒度大
        case 0:
            let dic = [["value":"填写姓名",ConstantsHelp.isAllowNull:"ok","type":ConstantsHelp.UIViewType.uitextField.rawValue],
                       ["value":"填写年龄","type":ConstantsHelp.UIViewType.uibutton.rawValue],
                       ["value":"提交说明",ConstantsHelp.isAllowNull:"ok","type":ConstantsHelp.UIViewType.uitextview.rawValue]
            ]
            
            let view = CommonViews.getApplyView(contentTitles: dic, leftTitleWidth: ConstantsHelp.leftTitleWidth)
            baseView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(190)
            }
            
            ///取属性 赋值
            let uitextfiled = baseView.viewWithTag(1000) as! UITextField
            uitextfiled.placeholder = "这是placeholder"
            let uibutton = baseView.viewWithTag(1001) as! UIButton
            uibutton.setTitle("点我试试", for: .normal)
            uibutton.addTarget(self, action: #selector(buttonClick(_ :)), for: .touchUpInside)
            let uitextview = baseView.viewWithTag(1002) as! UITextView
            uitextview.text = "随便写的"
            //MARK:-申请记录
        case 1:
            let dic = ["name":"张三",
                       "age":10,
                       "bill":10000,
                       "desc":"烟雨楼",
                       "lang":"这是一个比较长的东西，总之很长，啊手机好的吧就会收到就安徽省的工商局的风格坚实的反光镜"] as [String : Any]
            let json = JSON(dic)
            let view = CommonViews.getApplyNormalListView(json: json, imageSquarIsHidden: false, imageSquareColor: .green, headerTitle: "通用OA列表", headerTitleIsHidden: true, contentTitles: [["key":"name","value":"姓名啊"],["key":"age","value":"年龄"],["key":"bill","value":"财富",ConstantsHelp.unit:"亿元"],["key":"desc","value":"说明"],["key":"lang","value":"撒读后感还是"]], isShowSeparatorUIView: true, leftTitleWidth: ConstantsHelp.leftTitleWidth)
            
            baseView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(190)
            }
            //MARK:-申请单行 button
        case 2:
            let dic = ["value":"填写年龄","type":ConstantsHelp.UIViewType.uibutton.rawValue,ConstantsHelp.isAllowNull:"oooo"]
                       
            
            let view = CommonViews.getApplyWithUIButton(contentTitles: dic, leftTitleWidth: ConstantsHelp.leftTitleWidth)
            baseView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(190)
            }
            ///取属性 赋值
            let uibutton = baseView.viewWithTag(1000) as! UIButton
            uibutton.setTitle("点我试试", for: .normal)
            uibutton.addTarget(self, action: #selector(buttonClick(_ :)), for: .touchUpInside)
        case 3:
            let dic = ["value":"填写年龄","type":ConstantsHelp.UIViewType.uibutton.rawValue,ConstantsHelp.isAllowNull:"oooo"]
                       
            
            let view = CommonViews.getApplyWithUITextField(contentTitles: dic, leftTitleWidth: ConstantsHelp.leftTitleWidth)
            baseView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(190)
            }
            ///取属性 赋值
            
            let uitextfield = baseView.viewWithTag(1000) as! UITextField
            uitextfield.placeholder = "placeholder"
        case 4:
            let dic = ["value":"填写年龄","type":ConstantsHelp.UIViewType.uibutton.rawValue,ConstantsHelp.isAllowNull:"oooo"]
                       
            
            let view = CommonViews.getApplyWithUITextView(contentTitles: dic, leftTitleWidth: ConstantsHelp.leftTitleWidth)
            baseView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(190)
            }
            ///取属性 赋值
            let uitextview = baseView.viewWithTag(1000) as! UITextView
            uitextview.text = "placeholder"
            
        default:
            break;
        }
    }
    @objc func buttonClick(_ sender:UIButton){
        self.showToast(message: "你点击了！**单行控件记得添加tag值**")
    }
}
