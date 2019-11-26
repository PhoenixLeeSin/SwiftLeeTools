//
//  BaseTableViewListViewController.swift
//  TopsProSys
//
//  Created by topscommmac01 on 2018/10/24.
//  Copyright © 2018年 com.topscommmac01. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh
import QorumLogs
import SnapKit

open class BaseTableViewListViewController: BaseUIViewViewController{
    
    open var tableView:UITableView!
    public let headerFresh = MJRefreshGifHeader()
    public let footer = MJRefreshAutoNormalFooter() //底部加载
    open var listDataMap:JSON = JSON()
    open var data :JSON = JSON()
    open var url:String!
    open var rows = ConstantsHelp.rows
    open var parameters:Parameters! =  [
        ConstantsHelp.pageTitle:1,
        ConstantsHelp.rowsTitle:ConstantsHelp.rows,
        ConstantsHelp.sidxTitle:ConstantsHelp.sortcode,
        ConstantsHelp.sordTitle:ConstantsHelp.desc,
    ]
    //Item 内容
    open var itemContent:[[String:String]] = [[:]]
    open var successBackWithMoreData:Int = 0
    open var successBackWithNoMoreData:Int = 1
    open var errorBackWithNoData:Int = 2
    
    open var menuLabel:String = "myMessage" //当前使用模块标识

    //列表数量
    open var records:Int = 0{
        didSet{
            recordsChange()
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        addOthers()
        initTableView()
        addTableView()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //初始化基础视图
    open func initTableView() {
        tableView = UITableView()
    }
    
    open func addTableView() {
        tableView.rowHeight = 55
        
        baseView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(baseView)
        }
        tableView.separatorStyle = .none //分割线设置，不显示横线
        headerFresh.setRefreshingTarget(self, refreshingAction: #selector(refreshPage))
        var idleImages = [UIImage]()
        for i in 0...26 {
//            idleImages.append(UIImage(named: "refresh_image_0\(i)")!)
        }
        headerFresh.setImages(idleImages, for: .refreshing)
        
        headerFresh.setTitle("下拉刷新", for: .idle)
        headerFresh.setTitle("释放更新", for: .pulling)
        headerFresh.setTitle("正在刷新", for: .refreshing)
        footer.setTitle("即将刷新", for: .willRefresh)
        footer.setTitle("没有更多数据", for: .noMoreData)
        
        headerFresh.setRefreshingTarget(self, refreshingAction: #selector(refreshPage))
        footer.setRefreshingTarget(self, refreshingAction: #selector(loadMore))
        self.tableView.mj_header = headerFresh
        self.tableView.mj_footer = footer
        self.tableView.mj_footer!.isHidden = true

        locationTableView()
    }
    
    open func locationTableView()  {
        tableView.snp.makeConstraints { (make) in
            // 避免ios11.0以下系统 页面自动向下偏移64px
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.top.equalTo(view)
                make.bottom.equalTo(bottomLayoutGuide.snp.bottom)
            }
        }
    }
    
    open func addOthers(){

    }

    //请求数据
    func requestList(url:String,parameters:Parameters,successBack:@escaping (JSON) -> Void,doneBack:@escaping (Int) -> Void) {
         QL1("tokenHeder\(AlamofireManager.getToken())")
        QL1("url = \(url)")
        QL1(parameters)
        AlamofireManager.sharedSessionManager.request(url, method:HTTPMethod.post,parameters:parameters,headers:AlamofireManager.getToken()).validate().responseJSON{ response in
            self.hideHUD()
            switch response.result{
            case .success:
                self.data = JSON(response.data as Any)
                let actionResult:JSON  = self.data[ConstantsHelp.actionReuslt]
                if actionResult[ConstantsHelp.success].boolValue {
                  QL1(self.data)
                    let listDataMap:JSON  = JSON(response.data as Any)[ConstantsHelp.listDataMap]
                    let dataList:JSON  = JSON(response.data as Any)[ConstantsHelp.dataList]
                    self.records = JSON(response.data as Any)["dataMap"]["records"].intValue
                    if listDataMap.count > 0 {
                        self.tableView.mj_footer!.isHidden = false
                        self.tableView.autoShowEmptyView(dataSourceCount: 1)
                        successBack(listDataMap)
                    }else if dataList.count > 0 {
                        self.tableView.mj_footer!.isHidden = false
                        self.tableView.autoShowEmptyView(dataSourceCount: 1)
                        successBack(dataList)
                    }else{
                        if self.page == 1{
                            self.listDataMap = JSON()
                            self.organize()
                            self.tableView.reloadData()
                            self.tableView.mj_footer!.isHidden = true
                            self.tableView.autoShowEmptyView(dataSourceCount: 0)
                        }else{
                             self.tableView.mj_footer!.isHidden = false
                        }
                        doneBack(self.successBackWithNoMoreData)
                        self.putData(listDataMap: listDataMap, data:self.data )
                    }
                    
                }else{
                    if self.data[ConstantsHelp.timeout].boolValue{ //登陆超时
                        self.loginAgain()
                    }else{
                        QL1(actionResult[ConstantsHelp.message].stringValue)
                        self.showToast(message:actionResult[ConstantsHelp.message].stringValue)
                        doneBack(self.errorBackWithNoData)
                    }
                }
            case .failure(let error):
                self.checkNetWrokReachability(url, error: error)
                QL1("BaseTableViewListViewController requestList 似乎已断开与互联网的连接failure \(error)")
//                self.showAlertOne(title: "", message: "似乎已断开与互联网的连接")
                doneBack(self.errorBackWithNoData)
            }
        }
    }
    
    func organize(){
    
    }
    
    func successBack(jsonList:JSON) {
        if page == 1 {
            self.listDataMap = jsonList
            self.organize()
            putData(listDataMap: listDataMap, data:data )

            if self.listDataMap.count < rows {
                self.doneBack(value: successBackWithNoMoreData)
            }else{
                self.doneBack(value:successBackWithMoreData)
            }
            tableView.reloadData()
        }else{
            do {
                if self.listDataMap.isEmpty{
                    self.listDataMap = jsonList
                }else{
                    try self.listDataMap.merge(with: jsonList)
                }
                self.organize()
                putData(listDataMap: listDataMap, data:data )
                self.doneBack(value:successBackWithMoreData)
                tableView.reloadData()
            }catch{
                QL1("数据合并出错")
            }
        }
        
        self.hideHUD()
    }
    
    
    func doneBack(value:Int) {
        if page == 1 {
            tableView.mj_header!.endRefreshing()
        }else{
            tableView.mj_footer!.endRefreshing()
        }
        if(value == successBackWithNoMoreData){ //没有更多数据
            tableView.mj_footer!.endRefreshingWithNoMoreData()
        }else{
            tableView.mj_footer!.endRefreshing()
        }
    }

    @objc func refreshPage() {
        QL1("刷新")
        page = 1
        loadDataMethod(url:url)
    }
    
    @objc func loadMore() {
        showLoading(isSupportClick: true)
        page += 1
        loadDataMethod(url:url)
    }
    
    func loadDataMethod(url:String) {
        QL1("page = \(page)")
        parameters[ConstantsHelp.pageTitle] = page
        self.requestList(url: url,parameters: parameters, successBack: successBack, doneBack: doneBack)
    }
    
    
    func recordsChange() {
        QL1("records = \(records)")
    }
    
    //子类重写获得数据，其中listDataMap为合并后的listDataMap，data为网络请求获取的根数据
    func putData(listDataMap:JSON,data:JSON){
        
    }
}

extension UITableView {
    
   public func autoShowEmptyView(dataSourceCount:Int?){
        self.autoShowEmptyView(title: nil, image: nil, dataSourceCount: dataSourceCount)
    }
    
    func autoShowEmptyView(title:String?,image:UIImage?,dataSourceCount:Int?){
        
        guard let count = dataSourceCount else {
            let empty = EmptyView.init(frame: self.bounds)
            empty.setEmpty(title: title, image: image)
            self.backgroundView = empty
            return
        }
        
        if count == 0 {
            let empty = EmptyView.init(frame: self.bounds)
            empty.setEmpty(title: title, image: image)
            self.backgroundView = empty
        } else {
            self.backgroundView = nil
        }
    }
    
}


extension BaseTableViewListViewController{
    //如果是当前页，显示加载动画
    func animateTableCell(_ tableCell:UITableViewCell,_ indexRow:Int) {
//        判断是否属于当前页码
        if ((indexRow >= ((page - 1) * rows) && page > 1) || (page == 1 && indexRow > rows / 2)){
            //设置cell透明度为0 不显示
            tableCell.alpha = 0
            tableCell.layer.setAffineTransform(CGAffineTransform(scaleX: 0.5, y: 0.5))
            UIView.animate(withDuration: 0.2, delay:0, options:[],
                           animations: {
//                tableCell.layer.setAffineTransform(CGAffineTransform(translationX: -50, y: 0))
                            tableCell.layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: 1))
                tableCell.alpha = 1
            })
        }
    }
    
    
}
