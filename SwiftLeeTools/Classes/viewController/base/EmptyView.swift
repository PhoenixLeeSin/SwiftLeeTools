//
//  EmptyView.swift
//  TopsProSys
//  数据为空通用页面
//  Created by topscommmac01 on 2018/11/27.
//  Copyright © 2018 com.topscommmac01. All rights reserved.
//

import UIKit

// frame paras
private let marginX:CGFloat = 14
private let paddingY:CGFloat = 20

private let PLACEHODER_TITLE = "暂无相关数据"
private let PLACEHODER_IMAGE = UIImage.init(named: "emptyView")

class EmptyView: UIView {
    
    lazy var noDataImageView: UIImageView = {
        // imageView
        let noDataImageView = UIImageView.init()
        noDataImageView.image = PLACEHODER_IMAGE
        return noDataImageView
    }()
    
    lazy var infoLabel: UILabel = {
        // label
        let infoLabel = UILabel.init()
        infoLabel.text = PLACEHODER_TITLE
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.lineBreakMode = .byWordWrapping
        infoLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        return infoLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmptyView {
    
    func setupUI() {
        self.addSubview(infoLabel)
        self.addSubview(noDataImageView)
        
        infoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(marginX)
            make.right.equalTo(self).offset(-marginX)
            make.centerY.equalTo(self).offset(paddingY)
        }
        
        noDataImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(ConstantsHelp.SCREENWITH * 0.3)
            make.bottom.equalTo(self.snp.centerY).offset(-paddingY)
            make.centerX.equalTo(self)
        }
    }
    
}

extension EmptyView {
    
    /// 设置有标题的 空白视图
    ///
    /// - parameter title: 标题
    func setEmpty(title:String) -> () {
        self.setEmpty(title: PLACEHODER_TITLE, image: PLACEHODER_IMAGE)
    }
    
    
    /// 设置 带有图片的 空白视图
    ///
    /// - parameter image: 图片
    func setEmpty(image:UIImage) -> () {
        self.setEmpty(title: PLACEHODER_TITLE, image: image)
    }
    
    
    /// 设置带有标题与图片的 空白视图
    ///
    /// - parameter title: 标题
    /// - parameter image: 图片
    func setEmpty(title:String?,image:UIImage?) -> () {
        noDataImageView.image = image ?? PLACEHODER_IMAGE
        infoLabel.text = title ?? PLACEHODER_TITLE
    }
}

