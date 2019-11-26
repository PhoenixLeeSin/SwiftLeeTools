//
//  BaseMenuUICollectionViewViewController.swift
//  topsiOSPro
//
//  Created by topscommmac01_lixiaojin on 2019/5/31.
//

import UIKit
import SnapKit
import QorumLogs

open class BaseMenuUICollectionViewViewController: BaseUIScrollViewViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    open var collectionView : UICollectionView?
    open let Identifier    = "MenuCollectionViewCell"
    open var buttonColCount:Int = 4 //每行显示4个功能菜单
    //图标宽度
    open var width:CGFloat!
    //菜单视图高度
    open var menuCollectionViewHeight:CGFloat!
    //菜单数据源
    open var resourceArray:[[String:String]] = [["title": "", "image": ""]]
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        baseScrollView.showsVerticalScrollIndicator = false
        loadMenuData()  ///初始化菜单数据源，如果需要，重写该方法
        
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resourceArray.count
    }
    
    
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MenuCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuCollectionViewCell
        cell.itemLabel.itemUIImageView.image = UIImage(named: resourceArray[indexPath.row]["image"]!)
        cell.itemLabel.itemUILabel.text = resourceArray[indexPath.row][ConstantsHelp.title]
        
        //显示类型
        let type = resourceArray[indexPath.row]["type"]
        //        QL1(type)
        if type != nil{
            if type == "" || type == "number"{
                cell.itemLabel.showType = .number
            }else if type == "point"{
                cell.itemLabel.showType = .point
            }
        }else{
            cell.itemLabel.showType = .number
        }
        
        
        //数字角标
        if let num = resourceArray[indexPath.row]["num"] {
            cell.itemLabel.itemNumCircleUILabel.num = Int(num)!
        }else{
            cell.itemLabel.itemNumCircleUILabel.num = 0
        }
        return cell
    }
    
    //菜单点击事件
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //    //collection即将显示时调用
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        self.cellAnimateScale(collectionView, cell)
    //    }
    //
    //    func cellAnimateScale(_ collectionView:UICollectionView,_ cell:UICollectionViewCell){
    //        var duration:CGFloat = 0.5
    //
    //        UIView.animate(withDuration: TimeInterval(duration), animations: {
    //            cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
    //        })
    //
    //    }
    //
    open func loadMenuData() {
        createMenuView()
    }
    
    open func createMenuView() {
        if collectionView != nil{
            collectionView?.removeFromSuperview()
        }
        //计算图标宽度
        width = (ConstantsHelp.SCREENWITH-20) / (CGFloat(self.buttonColCount) + CGFloat(0.5))
        //计算菜单视图高度
        menuCollectionViewHeight = (width+8) * ceil(CGFloat(Float(resourceArray.count) / Float(buttonColCount))) + CGFloat(ConstantsHelp.labelHeight)
        // 初始化
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: width, height: width+8)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        // 设置分区头视图和尾视图宽高
        layout.headerReferenceSize = CGSize.init(width: ConstantsHelp.SCREENWITH, height: CGFloat(ConstantsHelp.labelHeight)-8)
        collectionView = UICollectionView.init(frame: CGRect(x:0, y:0, width:ConstantsHelp.SCREENWITH, height:menuCollectionViewHeight), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.allowsSelection = true
        
        baseScrollView.addSubview(collectionView!)
        
        locationCollectionView()
        
        registerCell()
    }
    
    open func registerCell(){
        // 注册cell
        collectionView?.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    //定位collectionView
    open func locationCollectionView(){
        collectionView!.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(ConstantsHelp.leftMargin)
            make.right.equalToSuperview().offset(ConstantsHelp.rightMargin)
            make.width.equalTo(ConstantsHelp.SCREENWITH - CGFloat(2 * ConstantsHelp.leftMargin))
            make.height.equalTo(menuCollectionViewHeight)
        }
    }
}



