//
//  MyListMenuViewController.swift
//  topsiOSPro_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools
import QorumLogs

class MyListMenuViewController: BaseGroupedTableViewViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        QL1("viewDidLoad")
        self.valueDirect = [
            0:["本视图为tableview基本列表","点我展示collectionview","点我展示scrollview","点击tableview刷新加载以及空白视图","AutoTableView","wkwebview加载Doc","wkwebview加载Pdf","wkwebview加载html","wkwebview加载ppt","wkwebview加载xlsx","wkwebview加载txt","wkwebview加载other"],
            ] as [Int:[AnyObject]]
        
        self.imageDirect = [
        0:["AppIcon","AppIcon","AppIcon","AppIcon","AppIcon","AppIcon","AppIcon","AppIcon","AppIcon","AppIcon","AppIcon","AppIcon"],
        ] as [Int:[AnyObject]]
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break;
        case 1:
            let viewcontroller = MyMenuViewController()
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        case 2:            
            let viewcontroller = MyScrollViewController()
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        case 3:
            let viewcontroller = MytableViewViewController()
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        case 4:
            let viewcontroller = MyAutoTableViewController()
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        case 5:
            let viewcontroller = MyWebViewController()
            //Doc
            viewcontroller.url = URL.init(string: "http://172.20.3.53:8919/toa/cbo/cboAttachment_download.action?attachmentId=19091100001002")!
            viewcontroller.fileType = .doc
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        case 6:
            let viewcontroller = MyWebViewController()
            //Pdf
            viewcontroller.fileType = .pdf
            viewcontroller.url = URL.init(string: "http://172.20.3.53:8919/toa/cbo/cboAttachment_download.action?attachmentId=19091600001003")!
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        case 7:
            let viewcontroller = MyWebViewController()
            viewcontroller.fileType = .html
            //流程图
            viewcontroller.url = URL.init(string: "http://172.20.3.53:8924/er/cbo/cboApprovalFlow_viewDiagram.action?sourceid=19112200000003&sourcetype=ErTravel&t=1574480250291")!
            viewcontroller.fileType = .html
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        case 8:
            let viewcontroller = MyWebViewController()
            viewcontroller.fileType = .ppt
            //流程图
            viewcontroller.url = URL.init(string: "http://172.20.3.53:8110/ywxt/ZIP/DOC/20191123161933519586.ppt")!
            viewcontroller.fileType = .ppt
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        case 9:
            let viewcontroller = MyWebViewController()
            //流程图
            viewcontroller.url = URL.init(string: "http://172.20.3.53:8919/toa/cbo/cboAttachment_download.action?attachmentId=19111200001004")!
            viewcontroller.fileType = .ppt
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        case 10:
            let viewcontroller = MyWebViewController()
            viewcontroller.fileType = .txt
            //other
            viewcontroller.url = URL.init(string: "http://172.20.3.53:8919/toa/cbo/cboAttachment_download.action?attachmentId=19111200001003")!
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        case 11:
            let viewcontroller = MyWebViewController()
            viewcontroller.fileType = .other
            //other
            viewcontroller.url = URL.init(string: "http://172.20.3.53:8919/toa/cbo/cboAttachment_download.action?attachmentId=19102100003005")!
            self.navigationController?.pushViewController(viewcontroller, animated: true)
            
        default:
            break;
        }
    }


}
