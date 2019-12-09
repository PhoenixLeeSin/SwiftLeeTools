//
//  MenuCollectionViewCell.swift
//  SwiftLeeTools
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
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
