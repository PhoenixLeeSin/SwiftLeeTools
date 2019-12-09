//
//  Array+JHExtension.swift
//  SwiftToolTest
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit

extension Array where Element : Equatable {
  
    /// 删除  重复元素
    public func removedDuplicates() -> [Element] {
        return reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }

    public func contains(_ elements: [Element]) -> Bool {
        for item in elements {
            if contains(item) == false {
                return false
            }
        }
        return true
    }
 
}








































