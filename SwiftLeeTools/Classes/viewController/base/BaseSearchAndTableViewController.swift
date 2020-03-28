//
//  BaseSearchAndTableViewController.swift
//  TopsProSys
//  基础搜索加表格视图
//  Created by 李桂盛 on 2019/12/3.
//  Copyright © 2019 com.topscommmac01. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

open class BaseSearchAndTableViewController: BaseTableViewListViewController,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating {

    private var searchController:UISearchController = UISearchController()
    //MARK:-上一次的关键词
    private var lastSearchBarText:String = ""
    //MARK:-搜索框placeholder
    public var searchBarPlaceholder:String = ""
    //MARK:-填充的数据
    public var contentTitles: [[String : String]] = []
    public var headerTitleKey: String = ""
    public var imageName: String = ""
    //MARK:-搜索时可能需要添加的参数
    public var paramKey: String = "key"
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableviewAndSearchController()
    }
    //MARK:-设置tableview以及searchcontroller
    func setupTableviewAndSearchController(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = searchBarPlaceholder
        
        if #available(iOS 11.0, *){
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            let uiView:UIView = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: 45))
            uiView.addSubview(searchController.searchBar)
            searchController.searchBar.backgroundColor = ConstantsHelp.normalTableViewUIColor
            self.tableView.tableHeaderView = uiView
        }
    }
    //MARK:-点击
    open func didSelectedWith(json: JSON, index: Int) {
        
    }
    //MARK:-delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDataMap.arrayValue.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let json = self.listDataMap.arrayValue[indexPath.row]
        let view = CommonViews.getApplyNormalListView(json: json, imageName: imageName, headerTitle: json[headerTitleKey].stringValue, headerTitleIsHidden: false, contentTitles: contentTitles)
        
        for sub in cell.contentView.subviews {
            sub.removeFromSuperview()
        }
        cell.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let json = self.listDataMap.arrayValue[indexPath.row]
        let index = indexPath.row
        self.didSelectedWith(json: json, index: index)
    }
    
    //MARK:-searchcontroller
    public func updateSearchResults(for searchController: UISearchController) {
        
        if let  searchBarText = searchController.searchBar.text {
            if searchBarText == "" && self.lastSearchBarText == ""{
                return
            }else{
                self.setupParamWith(value: searchBarText)
                self.lastSearchBarText = searchBarText
            }
        }        
    }
    //MARK:-处理（添加或去掉搜索的参数）
    public func setupParamWith(value: String) {

        if value == ""{
             self.parameters.removeValue(forKey: paramKey)
        }else{
            self.parameters[paramKey] = value
        }
        self.tableView.mj_header?.beginRefreshing()
    }
}
