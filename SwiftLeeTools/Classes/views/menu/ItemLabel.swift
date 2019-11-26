//
//  ItemLabel.swift
//  topsiOSPro
//
//  Created by topscommmac01_lixiaojin on 2019/5/31.
//

import Foundation
import UIKit
import SnapKit

//显示样式
public enum CircleUILabelShowType{
    case point //红点
    case number //数字
}

class ItemLabel: UIView {
    //图标
    var itemUIImageView:UIImageView = UIImageView()
    //文字描述
    var itemUILabel:UILabel = UILabel()
    //数字角标
    var itemNumCircleUILabel:CircleUILabel!
    
    //样式
    var showType:CircleUILabelShowType = .number{
        didSet{
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(itemUIImageView)
        itemUIImageView.snp.makeConstraints { (make) in
            make.left.equalTo(frame.width * 0.15)
            make.top.equalTo(0)
            make.width.equalTo(frame.width * 0.7)
            make.height.equalTo(frame.width * 0.7)
        }
        
        itemNumCircleUILabel = CircleUILabel()
        itemNumCircleUILabel.num = 0
        self.addSubview(itemNumCircleUILabel)
        itemNumCircleUILabel.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.top.equalTo(-5)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        self.addSubview(itemUILabel)
        //        itemUILabel.numberOfLines = 0
        //        itemUILabel.lineBreakMode = .byCharWrapping
        itemUILabel.adjustsFontSizeToFitWidth = true
        itemUILabel.textAlignment = .center
        itemUILabel.font = UIFont.systemFont(ofSize: 14)
        itemUILabel.textColor = ConstantsHelp.fontItemLabelColor
        itemUILabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.width.equalTo(frame.width)
            make.top.equalTo(itemUIImageView.snp.bottom).offset(3)
        }
    }
    
    func updateView(){
        if showType == .number{
            itemNumCircleUILabel.snp.updateConstraints { (make) in
                make.right.equalTo(-5)
                make.top.equalTo(-5)
                make.width.equalTo(25)
                make.height.equalTo(25)
            }
            itemNumCircleUILabel.textColor = .white
        }else if showType == .point{
            itemNumCircleUILabel.snp.updateConstraints { (make) in
                make.right.equalTo(-12)
                make.top.equalTo(-1)
                make.width.equalTo(10)
                make.height.equalTo(10)
            }
            itemNumCircleUILabel.textColor = .red
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

