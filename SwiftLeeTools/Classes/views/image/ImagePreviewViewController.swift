//
//  ImagePreviewViewController.swift
//  Alamofire
//
//  Created by topscommmac01_lixiaojin on 2019/7/2.
//

import UIKit

public class ImagePreviewViewController: UIViewController {

    //存放图片数组
    public var imagesArr:[UIImage]!
    //默认显示的图片索引
    public var indexImage:Int! = 0
    //当前显示的图片索引
    public var currentIndex:Int!
    //用来存放图片的单元格
    var imageUICollectionView:UICollectionView!
    //单元格布局
    var imageUICollectionViewFlowLayout:UICollectionViewFlowLayout!
    //页控制器，小圆点
    public var imageUIPageController:UIPageControl!
    
    //删除图片
    public var deleteImageProtocol:DeleteImageProtocol!
    
    public var ImageCountLabel:UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //背景色设置为黑色
        self.view.backgroundColor = UIColor.black
        //collectionView尺寸样式设置
        imageUICollectionViewFlowLayout = UICollectionViewFlowLayout()
        imageUICollectionViewFlowLayout.minimumLineSpacing = 0
        imageUICollectionViewFlowLayout.minimumInteritemSpacing = 0
        //横向滚动
        imageUICollectionViewFlowLayout.scrollDirection = .horizontal
        
        //uicollectionview初始化
        imageUICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: imageUICollectionViewFlowLayout)
        imageUICollectionView.backgroundColor = UIColor.black
        imageUICollectionView.register(ImagePreviewCell.self, forCellWithReuseIdentifier: "cell")
        
        imageUICollectionView.delegate = self
        imageUICollectionView.dataSource = self
        imageUICollectionView.isPagingEnabled = true
        
        //不自动调整内边距，确保全屏
        if #available(iOS 11.0, *){
            imageUICollectionView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(imageUICollectionView)
//        imageUICollectionView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
        //将视图滚动到默认图片上
        let indexPath = IndexPath(item: indexImage, section: 0)
        imageUICollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        // 小圆点pageControl
        imageUIPageController = UIPageControl()
        imageUIPageController.center = CGPoint(x: UIScreen.main.bounds.width/2,y: UIScreen.main.bounds.height - 20)
        imageUIPageController.numberOfPages = imagesArr.count
        imageUIPageController.isUserInteractionEnabled = false
        imageUIPageController.currentPage = indexImage
        
        
        //数字
        ImageCountLabel = UILabel.init(frame: CGRect.init(x: ConstantsHelp.SCREENWITH/2-40, y:UIScreen.main.bounds.height - 34, width: 80,height:24))
        ImageCountLabel.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        ImageCountLabel.layer.cornerRadius = 12
        ImageCountLabel.layer.masksToBounds = true
        ImageCountLabel.textAlignment = .center
        ImageCountLabel.textColor = .white
        ImageCountLabel.text = "\(indexImage! + 1)/\(imagesArr.count)"
        
        if imagesArr.count > ConstantsHelp.imageCount{
            view.addSubview(ImageCountLabel)
        }else{
            view.addSubview(self.imageUIPageController)
        }
    }
    
    //视图显示时
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),for:UIBarMetrics.default)
        let uiBarButtonItem = UIBarButtonItem(title: "删除", style: .done, target: self, action: #selector(deleteThisImage(_:)))
        self.navigationItem.setRightBarButton(uiBarButtonItem, animated: true)

        //隐藏导航栏
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    //视图消失时
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //显示导航栏
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    //隐藏状态栏
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //将要对子视图布局时调用（横竖屏切换时）
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //重新设置collectionView的尺寸
        imageUICollectionView.frame.size = self.view.bounds.size
        imageUICollectionView.collectionViewLayout.invalidateLayout()
        
        //将视图滚动到当前图片上
        let indexPath = IndexPath(item: self.imageUIPageController.currentPage, section: 0)
        imageUICollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        //重新设置页控制器的位置
        imageUIPageController.center = CGPoint(x: UIScreen.main.bounds.width/2,y: UIScreen.main.bounds.height - 20)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc public func deleteThisImage(_ index : Int){
        if currentIndex >= 0,currentIndex < imagesArr.count,imagesArr.count > 0 {
            imagesArr.remove(at: currentIndex)
            imageUIPageController.numberOfPages = imagesArr.count
            deleteImageProtocol.deleteImageIndexOf(currentIndex)
            imageUICollectionView.reloadData()
            if imagesArr.count == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}


//ImagePreviewVC的CollectionView相关协议方法实现
extension ImagePreviewViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //collectionView单元格创建
    public func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",for: indexPath) as! ImagePreviewCell
        let image = self.imagesArr[indexPath.row]
        cell.imageView.image = image
        return cell
    }
    
    //collectionView单元格数量
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArr.count
    }
    
    //collectionView单元格尺寸
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    //collectionView里某个cell将要显示
    public func collectionView(_ collectionView: UICollectionView,willDisplay cell: UICollectionViewCell,forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImagePreviewCell{
            //由于单元格是复用的，所以要重置内部元素尺寸
            cell.resetSize()
        }
    }
    
    //collectionView里某个cell显示完毕
    public func collectionView(_ collectionView: UICollectionView,didEndDisplaying cell: UICollectionViewCell,forItemAt indexPath: IndexPath) {
        //当前显示的单元格
        let visibleCell = collectionView.visibleCells[0]
        //设置页控制器当前页
        self.imageUIPageController.currentPage = collectionView.indexPath(for: visibleCell)!.item
        currentIndex = self.imageUIPageController.currentPage
        self.ImageCountLabel.text = "\(currentIndex + 1)/\(imagesArr.count)"
    }
}
