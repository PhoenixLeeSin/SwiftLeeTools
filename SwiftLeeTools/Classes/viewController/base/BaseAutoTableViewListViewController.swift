//
//  BaseAutoTableViewListViewController.swift
//  TopsProSys
//
//  Created by topscommmac01 on 2018/11/9.
//  Copyright © 2018 com.topscommmac01. All rights reserved.
//

import UIKit
import SwiftyJSON

open class BaseAutoTableViewListViewController: BaseTableViewListViewController,UITableViewDelegate,UITableViewDataSource  {
    
    
   open var titleInfo = "列表信息"
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        title = titleInfo
        //数据请求地址
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.estimatedRowHeight = CGFloat((itemContent.count) * ConstantsHelp.itemRowHeight + ConstantsHelp.largePadding)
        tableView?.rowHeight = UITableViewAutomaticDimension
        //开始下拉刷新
        tableView.mj_header!.beginRefreshing()
    }
    
    //cell行数
   open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDataMap.count
    }
    
    //填充cell数据
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let map = listDataMap[indexPath.row]
        let itemUIView = CommonViews.getNormalItemView(json: map, contentTitles: itemContent)
        tableCell.addSubview(itemUIView)
        itemUIView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(tableCell)
        }
//        animateTableCell(tableCell,indexPath.row)
        return tableCell
    }
    
    //cell将要点击
   open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    //cell被点击
   open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        clickItem(index: indexPath.row, json: self.listDataMap[indexPath.row])
    }
    
    
    
   open func clickItem(index :Int , json :JSON) -> Void {
        
    }
    
    
    
}


