//
//  CryptoSwoftTool.swift
//  cryDemo
//  加密解密工具
//  Created by 李桂盛 on 2020/2/25.
//  Copyright © 2020 LeeSin. All rights reserved.
//

import Foundation
import CryptoSwift


public enum EncryAlgorithmType: String {
    case md5
    case sha1
    case sha224
    case sha256
    case sha384
    case sha512
}

public class CryptoSwoftTool {
    
    
    /* 根据服务器返回的key 密码 加密类型生成HMAC 散列消息身份验证码
    * @param key         服务器返回的key
    * @param password    密码
    * @param variant     加密类型
    */
    public class func getHMACByServerWith(_ key: String, _ password: String, _ variant: HMAC.Variant) -> [UInt8] {
        return try! HMAC(key: key.bytes, variant: variant).authenticate(password.bytes)
    }
    
    /* 根据上一方法生成的hHMAC添加时间戳 再次加密 生成发送给服务器的密码参数
    * @param key         服务器返回的key
    * @param password    密码
    * @param variant     加密类型
    */
    public class func getEncryptedPasswordWith(_ hmac: [UInt8], _ token: String, _ encryAlgorithmType: EncryAlgorithmType) -> [UInt8] {
        switch encryAlgorithmType {
        case .md5:
            return (hmac.toHexString() + token).bytes.md5()
        case .sha1:
            return (hmac.toHexString() + token).bytes.sha1()
        case .sha224:
            return (hmac.toHexString() + token).bytes.sha224()
        case .sha256:
            return (hmac.toHexString() + token).bytes.sha256()
        case .sha384:
            return (hmac.toHexString() + token).bytes.sha384()
        case .sha512:
            return (hmac.toHexString() + token).bytes.sha512()
        }
    }
}
