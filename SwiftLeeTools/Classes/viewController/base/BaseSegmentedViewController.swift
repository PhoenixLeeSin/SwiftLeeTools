//
//  BaseSegmentedViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 李桂盛 on 2019/11/30.
//  Copyright © 2019 李效晋. All rights reserved.
//

import UIKit
import JXSegmentedView
//MARK:-数据源类型
public enum DataSourceType {
    case title //纯文字
    case titleAndImage //文字和图片
    case dot//红点
    case number//数字
}
//MARK:-指示器类型
public enum IndicatorType {
    case line //固定宽
    case autoLine //同cell等宽
    case lengthen //延长
}
open class BaseSegmentedViewController: BaseUIViewViewController {

    open var dataSourceType:DataSourceType = .title
    open var indicatorType:IndicatorType = .line
    private var jxSegmentedBaseDataSource:JXSegmentedBaseDataSource!
    private var jxSegmentedIndicatorBaseView:JXSegmentedIndicatorBaseView!
    open var titleSelectedColor:UIColor = .black
    open var indicatorColor:UIColor = .black
    open var segmentTitles:[String] = []
    open var segmentImages:[String] = []
    open var dotStates:[Bool] = []
    open var numbers:[Int] = []
    open var indicatorWidth:CGFloat = 20
    private let segmentedView = JXSegmentedView()
    open var listContainViewControllerStringArr:[String] = []
    
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
        
        setupSegmentConfig()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    open func setupSegmentConfig(){
        switch self.dataSourceType {
        case .title:
            let dataSource = JXSegmentedTitleDataSource()
            dataSource.titleSelectedColor = titleSelectedColor
            dataSource.isTitleZoomEnabled = true
            dataSource.titleSelectedZoomScale = 1.3
            dataSource.titles = segmentTitles
            self.jxSegmentedBaseDataSource = dataSource
        case .titleAndImage:
            let dataSource = JXSegmentedTitleImageDataSource()
            dataSource.titleSelectedColor = titleSelectedColor
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = segmentTitles
            dataSource.titleImageType = .rightImage
            dataSource.isImageZoomEnabled = true
            dataSource.normalImageInfos = segmentImages
            dataSource.loadImageClosure = {(imageView, normalImageInfo) in
                //如果normalImageInfo传递的是图片的地址，你需要借助SDWebImage等第三方库进行图片加载。
                //加载bundle内的图片，就用下面的方式，内部默认也采用该方法。
                imageView.image = UIImage(named: normalImageInfo)
            }
            self.jxSegmentedBaseDataSource = dataSource
        case .dot:
            let dataSource = JXSegmentedDotDataSource()
            dataSource.titleSelectedColor = titleSelectedColor
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = segmentTitles
            dataSource.dotStates = dotStates
            self.jxSegmentedBaseDataSource = dataSource
        case .number:
            let dataSource = JXSegmentedNumberDataSource()
            dataSource.titleSelectedColor = titleSelectedColor
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = segmentTitles
            dataSource.numbers = numbers
            dataSource.numberStringFormatterClosure = {(number) -> String in
                if number > 999 {
                    return "999+"
                }
                return "\(number)"
            }
            self.jxSegmentedBaseDataSource = dataSource
        }
        switch self.indicatorType {
        case .line:
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = indicatorWidth
            indicator.indicatorColor = indicatorColor
            self.jxSegmentedIndicatorBaseView = indicator
        case .autoLine:
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            indicator.indicatorColor = indicatorColor
            self.jxSegmentedIndicatorBaseView = indicator
        case .lengthen:
            let indicator = JXSegmentedIndicatorLineView()
            indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
            indicator.lineStyle = .lengthen
            indicator.indicatorColor = indicatorColor
            self.jxSegmentedIndicatorBaseView = indicator
        }
        
        segmentedView.dataSource = self.jxSegmentedBaseDataSource
        segmentedView.delegate = self
        baseView.addSubview(segmentedView)
        
        segmentedView.listContainer = listContainerView
        baseView.addSubview(listContainerView)
        
        segmentedView.indicators = [jxSegmentedIndicatorBaseView]

    }
    
    
}
extension BaseSegmentedViewController: JXSegmentedViewDelegate {
    public func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = jxSegmentedBaseDataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }

        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension BaseSegmentedViewController: JXSegmentedListContainerViewDataSource {
    public func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    public func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        guard let viewcontrollerType  = NSClassFromString(namespace + "." + listContainViewControllerStringArr[index]) as? BaseSegmentTableViewViewController.Type else{
            return BaseSegmentTableViewViewController()
        }
        let viewcontroller = viewcontrollerType.init()
        
        return viewcontroller
    }
}
