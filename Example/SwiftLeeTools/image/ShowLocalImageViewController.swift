//
//  ShowLocalImageViewController.swift
//  topsiOSPro_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools
import SnapKit

class ShowLocalImageViewController: BaseUIViewViewController,DeleteImageProtocol {
    
    let uiButton = UIButton()
    var imageArr : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        uiButton.setTitle("预览", for: .normal)
        self.baseView.addSubview(uiButton)
        uiButton.snp.makeConstraints { (make) in
            make.top.equalTo(ConstantsHelp.topMargin)
            make.left.equalTo(ConstantsHelp.leftMargin)
            make.right.equalTo(ConstantsHelp.rightMargin)
            make.height.equalTo(ConstantsHelp.buttonHeight)
        }
        
        uiButton.addTarget(self, action: #selector(showLocalImage), for: .touchDown)
        
    }
    

    @objc func showLocalImage(){
        
        imageArr.append(UIImage(named: "1")!)
        imageArr.append(UIImage(named: "2")!)
        imageArr.append(UIImage(named: "3")!)
        imageArr.append(UIImage(named: "4")!)
        imageArr.append(UIImage(named: "5")!)
        imageArr.append(UIImage(named: "6")!)
        
        let imagePreview = ImagePreviewViewController()
        imagePreview.imagesArr = imageArr
        imagePreview.currentIndex = 0
        imagePreview.indexImage = 0
        imagePreview.deleteImageProtocol = self
        self.navigationController?.pushViewController(imagePreview, animated: true)
    }

    //代理实现删除图片
    func deleteImageIndexOf(_ index:Int) {
        imageArr.remove(at: (index))
    }
}
