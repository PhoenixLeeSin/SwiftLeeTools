//
//  Data+Ex.swift
//  TopsProSys
//
//  Created by 李桂盛 on 2019/12/10.
//  Copyright © 2019 com.topscommmac01. All rights reserved.
//

import Foundation

extension Data {
    func getImageFormat() -> String?{
        var c: UInt8 = UInt8()
        self.copyBytes(to: &c, count: 1)
        switch c {
        case 0xFF:
            return ".jpg"
        case 0x89:
            return ".png"
        case 0x47:
            return ".gif"
        case 0x4D:
            return ".tiff"
        default:
            return nil
        }
    }
}
