//
//  ShowAVPlayerViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 李桂盛 on 2019/12/6.
//  Copyright © 2019 李桂盛. All rights reserved.
//

import UIKit
import SwiftLeeTools

class ShowAVPlayerViewController: BaseAVPlayerViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        url = "http://172.20.3.53:8924/er/cbo/cboAttachment_download.action?attachmentId=19120600000003"
        type = .MP4
    }
    


}
