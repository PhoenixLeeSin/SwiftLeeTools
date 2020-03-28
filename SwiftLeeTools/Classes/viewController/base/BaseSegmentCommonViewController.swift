//
//  BaseSegmentCommonViewController.swift
//  
//  segment下 更通用的baseUIViewController
//  Created by 李桂盛 on 2020/3/26.
//

import UIKit

open class BaseSegmentCommonViewController: BaseUIViewViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    open func setupUI(){
        //MARK:-记得调整baseView以及子视图的frame
        baseView.snp.remakeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
