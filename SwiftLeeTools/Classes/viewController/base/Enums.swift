//
//  Enums.swift
//  ProgressWebViewController
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import Foundation

public enum BarButtonItemType {
    case back
    case forward
    case reload
    case stop
    case activity
    case done
    case flexibleSpace
    case rotate
}

public enum NavigationBarPosition {
    case none
    case left
    case right
}

@objc public enum NavigationType: Int {
    case linkActivated
    case formSubmitted
    case backForward
    case reload
    case formResubmitted
    case other
}
public enum FileType {
    ///特殊类型
    case txt
    ///iOS13需要下载在打开
    case pdf
    case doc
    case docx
    case xls
    case xlsx
    case ppt
    case pptx
    case html
    case other
}
