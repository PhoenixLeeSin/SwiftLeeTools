//  CommonViews.swift
//  TopsProSys
//  Created by topscommmac01 on 2018/10/23.
//  Copyright © 2018年 com.topscommmac01. All rights reserved.
import Foundation
import UIKit
import SnapKit
import QorumLogs
import SwiftyJSON



public class CommonViews: NSObject{
    
    
    //获取横线
    public class func getLineView() -> UIView{
        let horizontalLine = UIView()
        horizontalLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.9)
        }
        horizontalLine.backgroundColor = ConstantsHelp.normalBackgroundUIColor
        return horizontalLine
    }
    
    //分割线
    public class func getSeparatorUIView() -> UIView {
        let separatorUIView = UIView()
        separatorUIView.backgroundColor = ConstantsHelp.normalBackgroundUIColor
        separatorUIView.snp.makeConstraints { (make) in
            make.height.equalTo(CGFloat(ConstantsHelp.littlePadding))
            make.width.equalTo(ConstantsHelp.SCREENWITH)
        }
        return separatorUIView
    }
    
    //获取更小横向间隔
    public class func getLittleMarginView() -> UIView{
        let horizontalLine = UIView()
        horizontalLine.snp.makeConstraints { (make) in
            make.height.equalTo(2)
        }
        horizontalLine.backgroundColor = ConstantsHelp.normalBackgroundUIColor
        return horizontalLine
    }
    
    ///获取横向间隔
    public class func getMarginView() -> UIView{
        let horizontalLine = UIView()
        horizontalLine.snp.makeConstraints { (make) in
            make.height.equalTo(5)
        }
        horizontalLine.backgroundColor = ConstantsHelp.lightBackgroundUIColor
        return horizontalLine
    }
    
    //获取竖线
    public class func getVerticalLine() -> UIView{
        let verticalLine = UIView()
        verticalLine.snp.makeConstraints { (make) in
            make.width.equalTo(0.3)
        }
        verticalLine.backgroundColor = ConstantsHelp.deepBackgroundUIColor
        return verticalLine
    }
    
    //获取一般UILabel
    public class func getUILabel(title:String,width:Int = ConstantsHelp.leftTitleWidth) -> UILabel{
        let titleUILabel:UILabel = UILabel()
        titleUILabel.text = title
        titleUILabel.lineBreakMode = .byTruncatingMiddle
        titleUILabel.adjustsFontSizeToFitWidth = true
        titleUILabel.textAlignment = .right
        titleUILabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        titleUILabel.snp.makeConstraints { (make) in
            make.height.equalTo(ConstantsHelp.labelHeight)
            if width != 0{
                make.width.equalTo(width)
            }
        }
        return titleUILabel
    }
    
    //获取必填UILabel
    public class func getNotNullLabel(title:String,width:Int = ConstantsHelp.leftTitleWidth,titleColor:String = "#808080") -> UILabel{
        let titleUILabel:UILabel = UILabel()
        titleUILabel.lineBreakMode = .byTruncatingMiddle
        titleUILabel.adjustsFontSizeToFitWidth = true
        titleUILabel.textAlignment = .right
        titleUILabel.textColor = UIColor().hexStringToColor(hexString: titleColor, alpha: 1)
        titleUILabel.snp.makeConstraints { (make) in
            make.height.equalTo(ConstantsHelp.labelHeight)
            if width != 0{
              make.width.equalTo(width)
            }
        }
        let strg = "*" + title //全部文字
        let ranStr = "*" //需变色文字
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:strg) //所有文字变为富文本
        let theRange = NSString(string: strg).range(of: ranStr)   //颜色处理的范围
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.red, range: theRange)  //颜色处理
        titleUILabel.attributedText = attrstring   //赋值
        return titleUILabel
    }
    
    //获取需要显示内容UILabel,使用者自己定义尺寸
    public class func getCommentUILabel(title :String) -> UILabel{
        let titleUILabel:UILabel = UILabel()
        titleUILabel.text = title
        titleUILabel.lineBreakMode = .byTruncatingMiddle
        titleUILabel.adjustsFontSizeToFitWidth = true
        titleUILabel.textAlignment = .left
        titleUILabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return titleUILabel
    }
    
    //获取需要显示内容UILabel,使用者自己定义尺寸
    public class func getCommentGrayUILabel(title :String) -> UILabel{
        let titleUILabel:UILabel = UILabel()
        titleUILabel.text = title
        titleUILabel.lineBreakMode = .byTruncatingMiddle
        titleUILabel.adjustsFontSizeToFitWidth = true
        titleUILabel.textAlignment = .right
        titleUILabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        titleUILabel.snp.makeConstraints { (make) in
            make.height.equalTo(ConstantsHelp.labelHeight)
        }
        return titleUILabel
    }
    
    public class func getCommentGrayNoHeightUILabel(title :String) -> UILabel{
        let titleUILabel:UILabel = UILabel()
        titleUILabel.text = title
        titleUILabel.lineBreakMode = .byTruncatingMiddle
        titleUILabel.adjustsFontSizeToFitWidth = true
        titleUILabel.textAlignment = .right
        titleUILabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return titleUILabel
    }
    
    //获取需要显示内容UILabel,使用者自己定义尺寸
    public class func getCommentGrayNotNullUILabel(title:String,titleColor:String = "#808080") -> UILabel{
        let titleUILabel:UILabel = UILabel()
        titleUILabel.text = title
        titleUILabel.lineBreakMode = .byTruncatingMiddle
        titleUILabel.adjustsFontSizeToFitWidth = true
        titleUILabel.textAlignment = .right
        titleUILabel.textColor = UIColor().hexStringToColor(hexString: titleColor, alpha: 1)
        titleUILabel.snp.makeConstraints { (make) in
            make.height.equalTo(ConstantsHelp.labelHeight)
        }
        let strg = "*" + title //全部文字
        let ranStr = "*" //需变色文字
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:strg) //所有文字变为富文本
        let theRange = NSString(string: strg).range(of: ranStr)   //颜色处理的范围
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.red, range: theRange)  //颜色处理
        titleUILabel.attributedText = attrstring   //赋值
        return titleUILabel
    }
    
    //获取右侧TextField
    public class func getUITextFeild() -> UITextField{
        let uiTextField = UITextField()
        uiTextField.clearButtonMode = .whileEditing
        uiTextField.returnKeyType = .done
        uiTextField.borderStyle = .roundedRect
        uiTextField.layer.borderColor = ConstantsHelp.borderCGColor
        uiTextField.adjustsFontSizeToFitWidth = true
        uiTextField.layer.borderWidth = 0.5
        uiTextField.layer.cornerRadius = 5
        uiTextField.backgroundColor = ConstantsHelp.backgroundUIColor
        uiTextField.snp.makeConstraints { (make) in
            make.height.equalTo(ConstantsHelp.uiTextFieldHeight)
        }
        return uiTextField
    }

    //获取较高TextField
    public class func getBiggerEditUITextView() -> UITextView{
        let editUiTextView = UITextView()
        editUiTextView.font = UIFont.systemFont(ofSize: ConstantsHelp.smallFontSize)
        editUiTextView.layer.borderColor = ConstantsHelp.borderCGColor
        editUiTextView.returnKeyType = .done
        editUiTextView.layer.borderWidth = 0.5
        editUiTextView.layer.cornerRadius = 5
        editUiTextView.textColor = UIColor.black
        editUiTextView.backgroundColor = ConstantsHelp.backgroundUIColor
        editUiTextView.snp.makeConstraints { (make) in
            make.height.equalTo(ConstantsHelp.uiTextFieldBigHeight)
        }
        return editUiTextView
    }
    
    
    //获取右侧值UILabel
    public class func getRightUILabel(title :String) -> UILabel{
        let titleUILabel:UILabel = UILabel()
        titleUILabel.text = title
        titleUILabel.lineBreakMode = .byTruncatingMiddle
        titleUILabel.textAlignment = .left
        return titleUILabel
    }
    
    //获取一般按钮
    public class func getPickUIButton(_ title :String) -> UIButton{
        let normalUIButton:UIButton = UIButton()
        normalUIButton.setTitle(title, for: .normal)
        normalUIButton.setTitleColor(ConstantsHelp.fontNormalUIColor, for: .normal)
        normalUIButton.layer.borderColor = ConstantsHelp.borderCGColor
        normalUIButton.layer.borderWidth = 0.5
        normalUIButton.layer.cornerRadius = 5
        normalUIButton.layer.backgroundColor = ConstantsHelp.lightBackgroundCGColor
        normalUIButton.titleLabel?.adjustsFontSizeToFitWidth = true
        if #available(iOS 9.0, *) {
            normalUIButton.semanticContentAttribute = .forceRightToLeft
        } else {
            // Fallback on earlier versions
        }
        normalUIButton.snp.makeConstraints { (make) in
            make.height.equalTo(ConstantsHelp.uiTextFieldHeight)
        }
        return normalUIButton
    }
    
    //获取停止按钮
    public class func getCancleUIButton(_ title :String) -> UIButton{
        let normalUIButton:UIButton = UIButton()
        normalUIButton.setTitle(title, for: .normal)
        normalUIButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        normalUIButton.layer.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        normalUIButton.layer.borderColor = ConstantsHelp.borderCGColor
        normalUIButton.layer.borderWidth = 0.5
        normalUIButton.layer.cornerRadius = 5
        normalUIButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
        }
        return normalUIButton
    }
    
    
    ///获取提交按钮
    public class func getSubmitUIButton(_ title :String) -> UIButton{
        let normalUIButton:UIButton = UIButton()
        normalUIButton.setTitle(title, for: .normal)
        normalUIButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        normalUIButton.layer.backgroundColor = ConstantsHelp.mainCGColor
        normalUIButton.layer.borderColor = ConstantsHelp.borderCGColor
        normalUIButton.layer.borderWidth = 0.5
        normalUIButton.layer.cornerRadius = 5
        normalUIButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
        }
        return normalUIButton
    }
   
    
    //获取填写信息部分，左侧title，右侧文本框
    public class func getTextFieldInfoView(dataMap:JSON,titles:[[String:String]]) -> UIView{
        let infoView = UIView()
        var titleLeft = UILabel()
        var valueRight = UITextField()
        for (index,value) in titles.enumerated() {
            titleLeft = UILabel()
            titleLeft.lineBreakMode = .byTruncatingMiddle
            titleLeft.text = value["value"]! + NSLocalizedString("colon",comment:"")
            titleLeft.textAlignment = .right
            titleLeft.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            infoView.addSubview(titleLeft)
            titleLeft.snp.makeConstraints{(make) -> Void in
                make.left.equalTo(0)
                make.top.equalTo(ConstantsHelp.labelHeight * index)
                make.height.equalTo(ConstantsHelp.labelHeight)
                make.width.equalTo(ConstantsHelp.leftTitleWidth)
            }
            valueRight = UITextField()
            valueRight.text = dataMap[value["key"]!].stringValue
            valueRight.placeholder = "2"
            valueRight.returnKeyType = .done
            
            infoView.addSubview(valueRight)
            valueRight.snp.makeConstraints{(make) -> Void in
                make.left.equalTo(ConstantsHelp.leftTitleWidth)
                make.top.equalTo(ConstantsHelp.labelHeight * index)
                make.height.equalTo(ConstantsHelp.labelHeight)
            }
            let horizontalLine = getLineView()
            infoView.addSubview(horizontalLine)
            horizontalLine.snp.makeConstraints{(make) -> Void in
                make.left.equalTo(ConstantsHelp.leftMargin)
                make.width.equalTo(ConstantsHelp.SCREENWITH)
                make.top.equalTo(ConstantsHelp.labelHeight * (index + 1))
            }
        }
        infoView.snp.makeConstraints { (make) in
            make.bottom.equalTo(valueRight.snp.bottom).offset(ConstantsHelp.littlePadding)
        }
        
        return infoView
    }
   //通用list item
  public class func getNormalItemView(json:JSON,contentTitles:[[String:String]],isShowSeparatorUIView:Bool = true,leftTitleWidth:Int = ConstantsHelp.leftTitleWidth) -> UIView {
       let itemView = UIView()
       var leftTitleUILabel:UILabel!
       var rightValueUILabel:UILabel!
       var lineTempUILabel:UILabel = UILabel()
       for (index,value) in contentTitles.enumerated() {
           if value[ConstantsHelp.isAllowNull] != nil && value[ConstantsHelp.isAllowNull]! == ConstantsHelp.no && json[value["key"]!].stringValue == "" {
               continue
           }
           if value[ConstantsHelp.isAllowZero] != nil && value[ConstantsHelp.isAllowZero]! == ConstantsHelp.no && json[value["key"]!].intValue == 0 {
               continue
           }
           leftTitleUILabel = UILabel()
           leftTitleUILabel.textAlignment = .right
           leftTitleUILabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
           leftTitleUILabel.adjustsFontSizeToFitWidth = true
           leftTitleUILabel.text = value["value"]! + NSLocalizedString("colon", comment: "")
           itemView.addSubview(leftTitleUILabel)
           leftTitleUILabel.snp.makeConstraints { (make) in
               make.left.equalTo(itemView)
               make.width.equalTo(leftTitleWidth)
           }
           
           if index == 0 {
               leftTitleUILabel.snp.makeConstraints { (make) in
                   make.top.equalTo(itemView).offset(ConstantsHelp.normalPadding)
               }
           }else{
               leftTitleUILabel.snp.makeConstraints { (make) in
                   make.top.equalTo(lineTempUILabel.snp.bottom).offset(ConstantsHelp.normalPadding)
               }
           }
           
           rightValueUILabel = UILabel()
           rightValueUILabel.lineBreakMode = .byCharWrapping
           rightValueUILabel.numberOfLines  = 0
           //时间处理
           if value[ConstantsHelp.dateType] != nil,value[ConstantsHelp.dateType]! != ""{
               rightValueUILabel.text = json[value["key"]!].stringValue.replacingOccurrences(of: "T", with: " ")
               if value[ConstantsHelp.dateType] == ConstantsHelp.date{
                   rightValueUILabel.text = StringUtils.getPrefixNStr(currentStr: rightValueUILabel.text!, length: 10)
               }else if value[ConstantsHelp.dateType] == ConstantsHelp.hour{
                   rightValueUILabel.text = StringUtils.getIndexStr(currentStr:rightValueUILabel.text!, start: 11, end:16 )
               }else if value[ConstantsHelp.dateType] == ConstantsHelp.dateHour{
                   rightValueUILabel.text = StringUtils.getPrefixNStr(currentStr: rightValueUILabel.text!, length: 16)
               }else if value[ConstantsHelp.dateType] == ConstantsHelp.second{
                   rightValueUILabel.text = StringUtils.getSuffixNStr(currentStr: rightValueUILabel.text!, length: 8)
               }
               
           }else{
               var temp = json[value["key"]!].stringValue
               if value["key"] == "username" , json["usercode"].stringValue != ""{
                   temp = temp + "[" + json["usercode"].stringValue + "]"
               }
               rightValueUILabel.text = temp
           }
           
           if value[ConstantsHelp.color] != nil,value[ConstantsHelp.color]! != ""{
               rightValueUILabel.textColor = UIColor.colorWithHexString(hex: value[ConstantsHelp.color]!)
           }
           
           if value[ConstantsHelp.bit] != nil,value[ConstantsHelp.bit] != "",rightValueUILabel.text! != ""{
               rightValueUILabel.text = VerifyHelp.decimalFormat(rightValueUILabel.text!,value[ConstantsHelp.bit]!)
           }
           
           if value[ConstantsHelp.unit] != nil,value[ConstantsHelp.unit]! != "",rightValueUILabel.text! != ""{
               if value[ConstantsHelp.unit]! == ConstantsHelp.money{
                   rightValueUILabel.text = VerifyHelp.moneyFormat(rightValueUILabel.text!)
               }else{
                   rightValueUILabel.text = rightValueUILabel.text! + value[ConstantsHelp.unit]!
               }
           }
           
           if value[ConstantsHelp.type] != nil,value[ConstantsHelp.type] != "",rightValueUILabel.text != nil,rightValueUILabel.text! != ""{
               if value[ConstantsHelp.type] == ConstantsHelp.dept{
                    rightValueUILabel.text = rightValueUILabel.text!.trimmingCharacters(in: CharacterSet(charactersIn: "\\"))
               }
           }
           
           if value[ConstantsHelp.extendSpace] != nil,value[ConstantsHelp.extendSpace] != "",json[value[ConstantsHelp.extendSpace]!].stringValue != "",rightValueUILabel.text! != ""{
               rightValueUILabel.text = rightValueUILabel.text! + " " + json[value[ConstantsHelp.extendSpace]!].stringValue
           }
           
           if value[ConstantsHelp.extendBracket] != nil,value[ConstantsHelp.extendBracket] != "",json[value[ConstantsHelp.extendBracket]!].stringValue != "",rightValueUILabel.text! != ""{
               rightValueUILabel.text = rightValueUILabel.text! + "[" + json[value[ConstantsHelp.extendBracket]!].stringValue + "]"
           }

           if value[ConstantsHelp.valuePlaceholder] != nil,value[ConstantsHelp.valuePlaceholder] != "",rightValueUILabel.text! == ""{
               rightValueUILabel.text = value[ConstantsHelp.valuePlaceholder]
           }
           
           itemView.addSubview(rightValueUILabel)
           rightValueUILabel.snp.makeConstraints { (make) in
               make.left.equalTo(leftTitleUILabel.snp.right).offset(ConstantsHelp.littlePadding)
               make.right.equalToSuperview().offset(ConstantsHelp.rightMargin)
               
           }
           
           if index == 0 {
               rightValueUILabel.snp.makeConstraints { (make) in
                   make.top.equalTo(itemView).offset(ConstantsHelp.normalPadding)
               }
           }else{
               rightValueUILabel.snp.makeConstraints { (make) in
                   make.top.equalTo(lineTempUILabel.snp.bottom).offset(ConstantsHelp.normalPadding)
               }
           }
           if rightValueUILabel.text! == ""{
               rightValueUILabel.text = "无"
               rightValueUILabel.isHidden = true
           }
           
           lineTempUILabel = UILabel()
           itemView.addSubview(lineTempUILabel)
           lineTempUILabel.snp.makeConstraints { (make) in
               make.left.right.equalToSuperview()
               make.top.equalTo(rightValueUILabel.snp.bottom)
               make.height.equalTo(0.1)
           }
           
       }
       if isShowSeparatorUIView{
           let separatorUIView = self.getSeparatorUIView()
           itemView.addSubview(separatorUIView)
           separatorUIView.snp.makeConstraints { (make) in
               make.top.equalTo(lineTempUILabel.snp.bottom).offset(ConstantsHelp.normalPadding)
               make.left.equalToSuperview()
               make.bottom.equalToSuperview().offset(-1)
           }
       }else{
           itemView.snp.makeConstraints { (make) in
               make.bottom.equalTo(lineTempUILabel.snp.bottom)
           }
       }
       
       return itemView
   }
    /**
    * 生成申请界面的view 具体样式参照OA办公->固定资产申请(颗粒度大 下面是粒度小的)
    * @param contentTitles           展示内容 包括 'value','allowNull','type'
    * @param leftTitleWidth          左侧宽度
    */
    public class func getApplyView(contentTitles:[[String:String]],leftTitleWidth:Int = ConstantsHelp.leftTitleWidth) -> UIView{
        let contentView = UIView()
        contentView.isUserInteractionEnabled = true
        var leftLabel = UILabel()
        var rightUI = UIView()
        //添加具体申请项
        for (index,value) in contentTitles.enumerated(){
            if (value[ConstantsHelp.isAllowNull] != nil){
                leftLabel = UILabel()
                leftLabel.text = value["value"]! + NSLocalizedString("colon", comment: "")
                leftLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }else{
                //不为空
                leftLabel = self.getNotNullLabel(title: value["value"]! + NSLocalizedString("colon", comment: ""))
            }
            leftLabel.textAlignment = .right
            leftLabel.adjustsFontSizeToFitWidth = true
            contentView.addSubview(leftLabel)
            leftLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalTo(leftTitleWidth)
                make.height.equalTo(ConstantsHelp.labelHeight)
            }
            //判断index的情况
            if index == 0 {
                leftLabel.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(ConstantsHelp.normalPadding)
                }
            }else{
                leftLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(rightUI.snp.bottom).offset(ConstantsHelp.normalPadding)
                }
            }
            //右侧类型()
            switch value["type"]! {
            case ConstantsHelp.UIViewType.uibutton.rawValue:
                rightUI = self.getPickUIButton("")
            case ConstantsHelp.UIViewType.uitextField.rawValue:
                rightUI = self.getUITextFeild()
            case ConstantsHelp.UIViewType.uitextview.rawValue:
                rightUI = self.getBiggerEditUITextView()
            default:
                break;
            }
            contentView.addSubview(rightUI)
            rightUI.tag = 1000+index
            
            rightUI.snp.makeConstraints { (make) in
                make.left.equalTo(ConstantsHelp.littlePadding + leftTitleWidth)
                make.right.equalTo(ConstantsHelp.rightMargin)
                make.top.equalTo(leftLabel.snp.top)
            }
        }
        let lineView = self.getLineView()
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(rightUI.snp.bottom).offset(ConstantsHelp.littlePadding)
            make.bottom.equalToSuperview().offset(-1)
        }
        return contentView
    }
    /**
    * 单独一行 左侧label 右侧button
    * 生成申请界面的view 具体样式参照OA办公->固定资产申请(粒度小的)
    * @param contentTitles           展示内容 包括 'value','allowNull','type'
    * @param leftTitleWidth          左侧宽度
    * @param viewTag                 控件的Tag值
    */
    public class func getApplyWithUIButton(contentTitles:[String:String],leftTitleWidth:Int = ConstantsHelp.leftTitleWidth,viewTag:Int = 1000) -> UIView{
        let contentView = UIView()
        contentView.isUserInteractionEnabled = true
        var leftLabel = UILabel()
        var rightUI = UIView()
        //添加具体申请项
        if (contentTitles[ConstantsHelp.isAllowNull] != nil){
            leftLabel = UILabel()
            leftLabel.text = contentTitles["value"]! + NSLocalizedString("colon", comment: "")
            leftLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }else{
            //不为空
            leftLabel = self.getNotNullLabel(title: contentTitles["value"]! + NSLocalizedString("colon", comment: ""))
        }
        leftLabel.textAlignment = .right
        leftLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(leftTitleWidth)
            make.height.equalTo(ConstantsHelp.labelHeight)
        }
        //判断index的情况
        
        leftLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstantsHelp.normalPadding)
        }
        
        //右侧类型(tag 默认1000)
        rightUI = self.getPickUIButton("")
        contentView.addSubview(rightUI)
        rightUI.tag = 1000
        
        rightUI.snp.makeConstraints { (make) in
            make.left.equalTo(ConstantsHelp.littlePadding + leftTitleWidth)
            make.right.equalTo(ConstantsHelp.rightMargin)
            make.top.equalTo(leftLabel.snp.top)
        }
        let lineView = self.getLineView()
        lineView.backgroundColor = .white
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(rightUI.snp.bottom).offset(ConstantsHelp.littlePadding)
            make.bottom.equalToSuperview().offset(-1)
        }
        return contentView
    }
    /**
    * 单独一行 左侧label 右侧UITextFeild
    * 生成申请界面的view 具体样式参照OA办公->固定资产申请(粒度小的)
    * @param contentTitles           展示内容 包括 'value','allowNull','type'
    * @param leftTitleWidth          左侧宽度
    * @param viewTag                 控件的Tag值
    */
    public class func getApplyWithUITextField(contentTitles:[String:String],leftTitleWidth:Int = ConstantsHelp.leftTitleWidth,viewTag:Int = 1000) -> UIView{
        let contentView = UIView()
        contentView.isUserInteractionEnabled = true
        var leftLabel = UILabel()
        var rightUI = UIView()
        //添加具体申请项
        if (contentTitles[ConstantsHelp.isAllowNull] != nil){
            leftLabel = UILabel()
            leftLabel.text = contentTitles["value"]! + NSLocalizedString("colon", comment: "")
            leftLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }else{
            //不为空
            leftLabel = self.getNotNullLabel(title: contentTitles["value"]! + NSLocalizedString("colon", comment: ""))
        }
        leftLabel.textAlignment = .right
        leftLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(leftTitleWidth)
            make.height.equalTo(ConstantsHelp.labelHeight)
        }
        //判断index的情况
        
        leftLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstantsHelp.normalPadding)
        }
        
        //右侧类型(tag 默认1000)
        rightUI = self.getUITextFeild()
        contentView.addSubview(rightUI)
        rightUI.tag = 1000
        
        rightUI.snp.makeConstraints { (make) in
            make.left.equalTo(ConstantsHelp.littlePadding + leftTitleWidth)
            make.right.equalTo(ConstantsHelp.rightMargin)
            make.top.equalTo(leftLabel.snp.top)
        }
        let lineView = self.self.getLineView()
        lineView.backgroundColor = .white
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(rightUI.snp.bottom).offset(ConstantsHelp.littlePadding)
            make.bottom.equalToSuperview().offset(-1)
        }
        return contentView
    }
    /**
    * 单独一行 左侧label 右侧UITextView
    * 生成申请界面的view 具体样式参照OA办公->固定资产申请(粒度小的)
    * @param contentTitles           展示内容 包括 'value','allowNull','type'
    * @param leftTitleWidth          左侧宽度
    * @param viewTag                 控件的Tag值
    */
    public class func getApplyWithUITextView(contentTitles:[String:String],leftTitleWidth:Int = ConstantsHelp.leftTitleWidth,viewTag:Int = 1000) -> UIView{
        let contentView = UIView()
        contentView.isUserInteractionEnabled = true
        var leftLabel = UILabel()
        var rightUI = UIView()
        //添加具体申请项
        if (contentTitles[ConstantsHelp.isAllowNull] != nil){
            leftLabel = UILabel()
            leftLabel.text = contentTitles["value"]! + NSLocalizedString("colon", comment: "")
            leftLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }else{
            //不为空
            leftLabel = self.getNotNullLabel(title: contentTitles["value"]! + NSLocalizedString("colon", comment: ""))
        }
        leftLabel.textAlignment = .right
        leftLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(leftTitleWidth)
            make.height.equalTo(ConstantsHelp.labelHeight)
        }
        //判断index的情况
        
        leftLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstantsHelp.normalPadding)
        }
        
        //右侧类型(tag 默认1000)
        rightUI = self.getBiggerEditUITextView()
        contentView.addSubview(rightUI)
        rightUI.tag = 1000
        
        rightUI.snp.makeConstraints { (make) in
            make.left.equalTo(ConstantsHelp.littlePadding + leftTitleWidth)
            make.right.equalTo(ConstantsHelp.rightMargin)
            make.top.equalTo(leftLabel.snp.top)
        }
        let lineView = self.getLineView()
        lineView.backgroundColor = .white
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(rightUI.snp.bottom).offset(ConstantsHelp.littlePadding)
            make.bottom.equalToSuperview().offset(-1)
        }
        return contentView
    }
    /**
    * 生成申请记录列表样式的view 具体样式参照OA办公->办理历史
    * @param json                    数据源
    * @param imageSquarIsHidden      方框是否隐藏
    * @param imageSquareColor        方框颜色
    * @param headerTitle             标题头
    * @param headerTitleIsHidden     标题是否隐藏
    * @param contentTitles           展示内容
    * @param isShowSeparatorUIView   是否展示分割线
    * @param leftTitleWidth          左侧宽度
    */
    public class func getApplyNormalListView(json:JSON,imageSquarIsHidden:Bool = false,imageSquareColor:UIColor,headerTitle:String?,headerTitleIsHidden:Bool,contentTitles:[[String:String]],isShowSeparatorUIView:Bool = true,leftTitleWidth:Int = ConstantsHelp.leftTitleWidth) -> UIView{
        
        let contentView = UIView()
        var leftLabel = UILabel()
        var rightLabel = UILabel()
        let headerL = UILabel()
        let imageSquare = UIImageView()
        let lineView = CommonViews.getLineView()
        //添加方框
        if !imageSquarIsHidden {
            contentView.addSubview(imageSquare)
            imageSquare.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(ConstantsHelp.topMargin)
                make.left.equalToSuperview().offset(ConstantsHelp.leftMargin)
                make.width.height.equalTo(20)
            }
            imageSquare.layer.cornerRadius = 3.0
            imageSquare.layer.masksToBounds = true
            imageSquare.backgroundColor = imageSquareColor
        }
        //添加标题
        if (headerTitle != nil){
            headerL.numberOfLines = 0
            headerL.lineBreakMode = .byWordWrapping
            headerL.textAlignment = .left
            headerL.text = headerTitle!
            contentView.addSubview(headerL)
            headerL.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(ConstantsHelp.topMargin)
                make.left.equalToSuperview().offset(ConstantsHelp.leftMargin * 3 + ConstantsHelp.littlePadding)
                make.right.equalToSuperview().offset(ConstantsHelp.rightMargin)
            }
        }
        //添加分割线
        if isShowSeparatorUIView{
            contentView.addSubview(lineView)
            lineView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(ConstantsHelp.leftMargin)
                make.right.equalToSuperview().offset(ConstantsHelp.rightMargin)
            }
            if imageSquarIsHidden && headerTitle == nil{
                lineView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(ConstantsHelp.littlePadding)
                }
            }else {
                lineView.snp.makeConstraints { (make) in
                    make.top.equalTo(headerTitle != nil ? headerL.snp.bottom : imageSquare.snp.bottom).offset(ConstantsHelp.normalPadding)
                }
            }
        }
        //添加具体展示项目
        for (index,value) in contentTitles.enumerated() {
            leftLabel = UILabel()
            leftLabel.textAlignment = .right
            leftLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            leftLabel.text = value["value"]! + NSLocalizedString("colon", comment: "")
            leftLabel.adjustsFontSizeToFitWidth = true
            contentView.addSubview(leftLabel)
            leftLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.width.equalTo(leftTitleWidth)
            }
            //判断index的情况
            if index == 0 {
                leftLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(lineView.snp.bottom).offset(ConstantsHelp.littlePadding)
                }
            }else{
                leftLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(rightLabel.snp.bottom).offset(ConstantsHelp.normalPadding)
                }
            }
            rightLabel = UILabel()
            rightLabel.textAlignment = .left
            rightLabel.numberOfLines = 0
            rightLabel.lineBreakMode = .byWordWrapping
            contentView.addSubview(rightLabel)
            //额外格式处理
            if value[ConstantsHelp.dateType] != nil,value[ConstantsHelp.dateType]! != ""{
                rightLabel.text = json[value["key"]!].stringValue.replacingOccurrences(of: "T", with: " ")
                if value[ConstantsHelp.dateType] == ConstantsHelp.date{
                    rightLabel.text = StringUtils.getPrefixNStr(currentStr: rightLabel.text!, length: 10)
                }else if value[ConstantsHelp.dateType] == ConstantsHelp.hour{
                    rightLabel.text = StringUtils.getIndexStr(currentStr:rightLabel.text!, start: 11, end:16 )
                }else if value[ConstantsHelp.dateType] == ConstantsHelp.dateHour{
                    rightLabel.text = StringUtils.getPrefixNStr(currentStr: rightLabel.text!, length: 16)
                }else if value[ConstantsHelp.dateType] == ConstantsHelp.second{
                    rightLabel.text = StringUtils.getSuffixNStr(currentStr: rightLabel.text!, length: 8)
                }
            }else{
                var temp = json[value["key"]!].stringValue
                if value["key"] == "username" , !temp.contains("["),json["usercode"].stringValue != ""{
                    temp = temp + "[" + json["usercode"].stringValue + "]"
                }
                rightLabel.text = temp
            }
            
            if value[ConstantsHelp.color] != nil,value[ConstantsHelp.color]! != ""{
                rightLabel.textColor = UIColor.colorWithHexString(hex: value[ConstantsHelp.color]!)
            }
            
            if value[ConstantsHelp.bit] != nil,value[ConstantsHelp.bit] != "",rightLabel.text! != ""{
                rightLabel.text = VerifyHelp.decimalFormat(rightLabel.text!,value[ConstantsHelp.bit]!)
            }
            
            if value[ConstantsHelp.unit] != nil,value[ConstantsHelp.unit]! != "",rightLabel.text! != ""{
                if value[ConstantsHelp.unit]! == ConstantsHelp.money{
                    rightLabel.text = VerifyHelp.moneyFormat(rightLabel.text!)
                }else{
                    rightLabel.text = rightLabel.text! + value[ConstantsHelp.unit]!
                }
            }
            
            if value[ConstantsHelp.type] != nil,value[ConstantsHelp.type] != "",rightLabel.text != nil,rightLabel.text! != ""{
                if value[ConstantsHelp.type] == ConstantsHelp.dept{
                     rightLabel.text = rightLabel.text!.trimmingCharacters(in: CharacterSet(charactersIn: "\\"))
                }
            }
            
            if value[ConstantsHelp.extendSpace] != nil,value[ConstantsHelp.extendSpace] != "",json[value[ConstantsHelp.extendSpace]!].stringValue != "",rightLabel.text! != ""{
                rightLabel.text = rightLabel.text! + " " + json[value[ConstantsHelp.extendSpace]!].stringValue
            }
            
            if value[ConstantsHelp.extendBracket] != nil,value[ConstantsHelp.extendBracket] != "",json[value[ConstantsHelp.extendBracket]!].stringValue != "",rightLabel.text! != ""{
                rightLabel.text = rightLabel.text! + "[" + json[value[ConstantsHelp.extendBracket]!].stringValue + "]"
            }

            if value[ConstantsHelp.valuePlaceholder] != nil,value[ConstantsHelp.valuePlaceholder] != "",rightLabel.text! == ""{
                rightLabel.text = value[ConstantsHelp.valuePlaceholder]
            }
            
            if rightLabel.text == ""{
                rightLabel.text = " "
            }
            rightLabel.snp.makeConstraints { (make) in
                make.left.equalTo(ConstantsHelp.littlePadding + leftTitleWidth)
                make.right.equalTo(ConstantsHelp.rightMargin*2)
                make.top.equalTo(leftLabel.snp.top)
            }
        }
        //view之间分割线
        let separatorUIView = self.getSeparatorUIView()
        contentView.addSubview(separatorUIView)
        separatorUIView.snp.makeConstraints { (make) in
            make.top.equalTo(rightLabel.snp.bottom).offset(ConstantsHelp.normalPadding)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
        }
        return contentView
    }
}
