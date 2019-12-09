
//
//  BaseSegmentViewController.swift
//  TopsProSys
//  滑动切换下方内容视图
//  Created by 李桂盛 on 2019/11/30.
//  Copyright © 2019 com.topscommmac01. All rights reserved.
//

import UIKit
import JXSegmentedView
import SwiftyJSON

open class BaseSegmentTableViewViewController: BaseTableViewListViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:-填充的数据
   public var contentTitles: [[String : String]] = []
   public var headerTitleKey: String = ""
   public var imageName: String = ""
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

    }
    open func setupUI(){
        //MARK:-记得调整baseView以及子视图的frame
        baseView.snp.remakeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        tableView.snp.remakeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        //MARK:-必须设置 不然导致tableview顶部留白
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    //MARk:-子类覆盖点击方法
     open func didSelectedCellWithIndexWith(json:JSON,index:Int){
        
    }
    

}
extension BaseSegmentTableViewViewController{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.url == nil ? 0 : self.listDataMap.arrayValue.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let json = self.listDataMap.arrayValue[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        let view = CommonViews.getApplyNormalListView(json: json,imageSquarIsHidden: false,imageName:imageName,headerTitle: json[headerTitleKey].stringValue, headerTitleIsHidden: false, contentTitles: contentTitles)
        cell.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let json = self.listDataMap.arrayValue[indexPath.row]
        let index = indexPath.row
        self.didSelectedCellWithIndexWith(json: json, index: index)
    }
}
extension BaseSegmentTableViewViewController: JXSegmentedListContainerViewListDelegate {
    open  func listView() -> UIView {
        return view
    }
}
