//
//  FullScreenSlideshowEx.swift
//  TopsProSys
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import Foundation
import SnapKit
import QorumLogs
import ImageSlideshow

extension FullScreenSlideshowViewController{
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ///MARK:-设置
        self.slideshow.circular = false
        
        let rotateUIButton = UIButton()
        let path = Bundle(for: ProgressWebViewController.self).resourcePath! + "/SwiftLeeTools.bundle"
        let bundle = Bundle(path: path)!
        let image =  UIImage(named: "rotate", in: bundle, compatibleWith: nil)!
        rotateUIButton.setImage(image, for: .normal)
        
        
        if !isBeingDismissed {
            self.view.addSubview(rotateUIButton)
            rotateUIButton.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(ConstantsHelp.rightMargin)
                make.height.width.equalTo(ConstantsHelp.normalPadding*4)
                if #available(iOS 11.0, *) {
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0)
                } else {
                    make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(0)
                }
//                make.top.equalTo(closeButton.snp.top)
            }
            rotateUIButton.addTarget(self, action: #selector(rotateMe(sender:)), for: .touchDown)
            
            let shadowView = UIView()
            self.view.addSubview(shadowView)
            shadowView.backgroundColor = UIColor.colorWithHexString(hex:"#111111", alpha: 0.2)
            shadowView.snp.makeConstraints { (make) in
                if #available(iOS 11.0, *) {
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                } else {
                    make.top.equalTo(self.topLayoutGuide.snp.bottom)
                }
                make.left.right.equalToSuperview()
                make.bottom.equalTo(rotateUIButton)
            }
            view.bringSubviewToFront(closeButton)
            view.bringSubviewToFront(rotateUIButton)
        }
    }
    
    
    @objc func rotateMe(sender:UIButton){
        let srcUIImage = slideshow.slideshowItems[slideshow.currentPage].imageView.image
        switch slideshow.slideshowItems[slideshow.currentPage].imageView.image?.imageOrientation.rawValue {
        case UIImage.Orientation.up.rawValue:
            let newUIImage = UIImage(cgImage: (srcUIImage?.cgImage)!, scale: srcUIImage!.scale, orientation: .left)
            self.slideshow.slideshowItems[self.slideshow.currentPage].imageView.image = newUIImage
            
        case UIImage.Orientation.left.rawValue:
            let newUIImage = UIImage(cgImage: (srcUIImage?.cgImage)!, scale: srcUIImage!.scale, orientation: .down)
            slideshow.slideshowItems[slideshow.currentPage].imageView.image = newUIImage
        case UIImage.Orientation.down.rawValue:
            let newUIImage = UIImage(cgImage: (srcUIImage?.cgImage)!, scale: srcUIImage!.scale, orientation: .right)
            slideshow.slideshowItems[slideshow.currentPage].imageView.image = newUIImage
        case UIImage.Orientation.right.rawValue:
            let newUIImage = UIImage(cgImage: (srcUIImage?.cgImage)!, scale: srcUIImage!.scale, orientation: .up)
            slideshow.slideshowItems[slideshow.currentPage].imageView.image = newUIImage
        default:
            QL1("未知")
        }
        
    }

}
