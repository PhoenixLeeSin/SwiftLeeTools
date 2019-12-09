//
//  BaseUIScrollViewViewController.swift
//  TopsProSys
//  UIScrollView基类
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SnapKit


open class BaseUIScrollViewViewController: BaseUIViewViewController {
    public var baseScrollView:UIScrollView!
    public var innerUIView:UIView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        initOthersUIView()
        initBaseUIScrollView()
        initInnerUIView()
    }
    
    //初始化滚动视图
   public func initBaseUIScrollView() {
        baseScrollView = UIScrollView()
        baseScrollView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        baseScrollView.alwaysBounceVertical = true
        baseScrollView.isScrollEnabled = true
        self.baseView.addSubview(baseScrollView)
        positionUIScrollView()
    }
    
    //定位滚动视图
   public func positionUIScrollView() {
        baseScrollView.snp.makeConstraints{(make) in
            make.edges.equalToSuperview()
            make.width.equalTo(ConstantsHelp.SCREENWITH)
        }
    }
    
    //添加其他视图
    public  func initOthersUIView(){
        
    }
    
    public func initInnerUIView(){
        innerUIView = UIView()
        baseScrollView.addSubview(innerUIView)
        innerUIView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
