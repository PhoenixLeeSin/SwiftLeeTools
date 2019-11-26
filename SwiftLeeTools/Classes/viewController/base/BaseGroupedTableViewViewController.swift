//
//  BaseGroupedTableViewViewController.swift
//  topsiOSPro
//
//  Created by topscommmac01_lixiaojin on 2019/6/3.
//

import UIKit
import QorumLogs

open class BaseGroupedTableViewViewController: BaseUIViewViewController,UITableViewDelegate,UITableViewDataSource  {
    
    open var tableView:UITableView!
    open var valueDirect:[Int:[AnyObject]] = [:]
    open var imageDirect:[Int:[AnyObject]] = [:]
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        initOthers()
        initTableView()
        QL1("viewDidLoad")
    }
    
    open func initOthers(){
        
    }
    
    open func initTableView() {
        tableView = UITableView(frame:baseView.frame, style:.grouped)
        baseView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(baseView)
        }
        locationTableView()
    }
    
    open func locationTableView() {
        tableView.snp.makeConstraints { (make) in
            // 避免ios11.0以下系统 页面自动向下偏移64px
            if #available(iOS 11.0, *){
                make.top.equalToSuperview()
            }else{
                make.top.equalTo(view.snp.top)
            }
        }
    }
    
    //返回分组个数
    open func numberOfSections(in tableView: UITableView) -> Int {
        return valueDirect.count
    }
    
    
    //自定义header视图
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    //设置分组头部高度
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(ConstantsHelp.littlePadding)
    }
    
    //设置分组尾的高度
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    //自定义footer视图
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    //每一组的行数
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (valueDirect[section]?.count)!
    }
    
    //将要点击
    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    //点击后 重写该方法，处理点击事件
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        QL1("indexPath.section = \(indexPath.section) , indexPath.row = \(indexPath.row)")
    }
    
//    //每行的视图 重写该方法，定制每行显示的内容
//    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        QL1("定制每行视图 in BaseGroupedTableViewViewController")
//        return UITableViewCell()
//    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if tableCell == nil {
            tableCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        //最左侧显示图标
        tableCell?.imageView?.image = UIImage(named: imageDirect[indexPath.section]![indexPath.row] as! String)
        tableCell?.textLabel?.text = valueDirect[indexPath.section]?[indexPath.row] as? String
        tableCell?.accessoryType = .disclosureIndicator
         QL1("tableView")
        return tableCell!
    }
}
