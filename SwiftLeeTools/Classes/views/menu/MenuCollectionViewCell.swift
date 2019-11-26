//
//  MenuCollectionViewCell.swift
//  topsiOSPro
//
//  Created by topscommmac01_lixiaojin on 2019/5/31.
//

import Foundation
import UIKit
import SnapKit


class MenuCollectionViewCell: UICollectionViewCell {
    var itemLabel:ItemLabel!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        itemLabel = ItemLabel(frame: self.frame)
        self.addSubview(itemLabel)
        itemLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
