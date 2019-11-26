//
//  CircleUILabel.swift
//  topsiOSPro
//
//  Created by topscommmac01_lixiaojin on 2019/5/31.
//


import Foundation
import UIKit

class CircleUILabel: UILabel{
    var num:Int = 0{
        didSet{
            //如果num小于等于0则不显示
            if num <= 0 {
                self.isHidden = true
            }else{
                self.isHidden = false
                if num > 99 {
                    self.text = "99+"
                }else{
                    self.text = "\(num)"
                }
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //页面初始化相关设置
    private func initialSetUp() -> Void {
        self.layer.masksToBounds = true
        self.textAlignment = .center
        //默认字体
        self.font = UIFont.systemFont(ofSize: 14)
        //背景默认为红色
        self.backgroundColor = UIColor.red
        //文字默认为红色
        self.textColor = UIColor.white
        //文字大小自适应标签宽度
        self.adjustsFontSizeToFitWidth = true
        //文本中线于label中线对齐
        self.baselineAdjustment = UIBaselineAdjustment.alignCenters
        //默认不显示，当设置了num大于0才显示
        self.isHidden = true
    }
    
    //布局相关设置
    override func layoutSubviews() {
        super.layoutSubviews()
        //修改圆角半径
        self.layer.cornerRadius = self.bounds.width/2
    }
    
    //数字改变时n播放的动画
    func playAnimate(){
        //从小到大，且有弹性效果
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowAnimatedContent, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    
}

