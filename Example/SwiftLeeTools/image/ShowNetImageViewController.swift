//
//  ShowNetImageViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools
import SnapKit
import AlamofireImage
import ImageSlideshow

class ShowNetImageViewController: BaseUIViewViewController {

    

    lazy var imageSlideShow = ImageSlideshow()

    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageArr:[AlamofireSource] = []
        imageArr.append(AlamofireSource(urlString: "http://img4.imgtn.bdimg.com/it/u=688059555,2062039633&fm=26&gp=0.jpg")!)
        imageArr.append(AlamofireSource(urlString: "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3253325827,761778924&fm=26&gp=0.jpg")!)
        imageArr.append(AlamofireSource(urlString: "http://sjbz.fd.zol-img.com.cn/t_s720x1280c/g2/M00/0A/07/ChMlWl0essqIU5PrAA-77dSn6ZoAALjfwEg5TQAD7wF815.jpg")!)
        imageArr.append(AlamofireSource(urlString: "http://sjbz.fd.zol-img.com.cn/t_s750x1334c/g2/M00/0A/07/ChMlWl0essyIMC1PAAbZyx9kTH0AALjfwGxIsUABtnj204.jpg")!)
        imageArr.append(AlamofireSource(urlString: "http://b.zol-img.com.cn/sjbizhi/images/9/750x1334/1562292824836.jpg")!)

        imageSlideShow.contentScaleMode = .scaleAspectFill
        
        imageSlideShow.setImageInputs(imageArr)
        
        let labelPageIndicator = LabelPageIndicator()
        imageSlideShow.pageIndicator = labelPageIndicator
        labelPageIndicator.textColor = UIColor.white
        labelPageIndicator.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.baseView.addSubview(imageSlideShow)
        imageSlideShow.snp.makeConstraints { (make) in
            make.width.height.equalTo(200)
            make.center.equalTo(self.baseView.snp.center)
        }
        
        makeTapGesture()

    }
    

    func makeTapGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlideShow.circular = false
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
    }

    
    @objc func didTap() {
        imageSlideShow.presentFullScreenController(from: self)
    }
}
