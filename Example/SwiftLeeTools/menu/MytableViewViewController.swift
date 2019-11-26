//
//  MytableViewViewController.swift
//  topsiOSPro_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools
import SwiftyJSON

class MytableViewViewController: BaseTableViewListViewController ,UITableViewDelegate,UITableViewDataSource{

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let seg = UISegmentedControl.init(items: ["请求1","请求2"])
        seg.layer.position = CGPoint.init(x: ConstantsHelp.SCREENWITH / 2.0, y: 10)
        self.navigationItem.titleView = seg
        seg.addTarget(self, action: #selector(segClick(_ :)), for: .valueChanged)
        //设置加载动画
        var idleImages = [UIImage]()
        for i in 0...26 {
            idleImages.append(UIImage(named: "refresh_image_0\(i)")!)
        }
        headerFresh.setImages(idleImages, for: .refreshing)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView?.estimatedRowHeight = CGFloat(ConstantsHelp.itemRowHeight * 3)
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame:CGRect(x:0, y: 0, width: ConstantsHelp.SCREENWITH, height:10))
    }
    func refreshWith(index:Int){
        self.listDataMap = JSON()
        switch index {
        case 0:
            self.parameters = [:]
            url = "http://172.20.3.53:8919/toa/" +
            "toa/toaRestaurantFood_foodList.json"
        case 1:
            self.parameters = ["restaurantid": "19080700000002"]
            url = "http://172.20.3.53:8919/toa/toa/toaRestaurantMeun_meunByDate.json"
        default:
            break;
        }

        self.tableView.mj_header?.beginRefreshing()
        
        if self.listDataMap.arrayValue.count == 0 {
            self.tableView.autoShowEmptyView(dataSourceCount: 0)
            self.tableView.backgroundColor = .white
        }
    }
    @objc func segClick(_ seg:UISegmentedControl){
        refreshWith(index: seg.selectedSegmentIndex)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDataMap.arrayValue.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.listDataMap[indexPath.row]["name"].stringValue
        return cell
    }
}
