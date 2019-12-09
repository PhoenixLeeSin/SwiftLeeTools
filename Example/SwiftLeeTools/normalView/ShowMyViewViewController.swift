//
//  ShowMyViewViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools
import SwiftyJSON

class ShowMyViewViewController: BaseGroupedTableViewViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "封装基本View展示"
        
        self.valueDirect = [
            0:["申请填写","申请记录","申请单行button","申请单行uitextfield","申请单行uitextview"],
            ] as [Int:[AnyObject]]
        
        self.imageDirect = [
        0:["AppIcon","AppIcon","AppIcon","AppIcon","AppIcon"],
        ] as [Int:[AnyObject]]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewcontroller = ShowMyViewDetailViewController()
        viewcontroller.index = indexPath.row
        self.navigationController?.pushViewController(viewcontroller, animated: true)

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for sub in baseView.subviews{
            sub.removeFromSuperview()
        }
    }
}
