//
//  KeychainManager.swift
//  topsiOSPro
//
//  Created by topscommmac01_lixiaojin on 2019/6/4.
//

import UIKit
import QorumLogs

open class KeychainManager: NSObject {
    /// 创建环境
    public class func createQuaryMutableDictionary(identifier:String)->NSMutableDictionary{
        let keychainQuaryMutableDictionary = NSMutableDictionary.init(capacity: 0)
        keychainQuaryMutableDictionary.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrService as String)
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrAccount as String)
        keychainQuaryMutableDictionary.setValue(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as String)
        return keychainQuaryMutableDictionary
    }
    
    ///存储数据
    @discardableResult
    public class func keyChainSaveData(data:Any ,withIdentifier identifier:String)->Bool {
        let keyChainSaveMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        SecItemDelete(keyChainSaveMutableDictionary)
        keyChainSaveMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        let saveState = SecItemAdd(keyChainSaveMutableDictionary, nil)
        if saveState == noErr  {
            return true
        }
        return false
    }
    
    ///获取数据
    public class func keyChainReadData(identifier:String)-> String {
        var idObject:String = ""
        let keyChainReadmutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        keyChainReadmutableDictionary.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        keyChainReadmutableDictionary.setValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
        var queryResult: AnyObject?
        let readStatus = withUnsafeMutablePointer(to: &queryResult) { SecItemCopyMatching(keyChainReadmutableDictionary, UnsafeMutablePointer($0))}
        if readStatus == errSecSuccess {
            if let data = queryResult as! NSData? {
                if NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? String != nil{
                    idObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! String
                }
            }
        }
        return idObject
    }
    
    /// 删除数据
    public class func keyChianDelete(identifier:String)->Void{
        let keyChainDeleteMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        SecItemDelete(keyChainDeleteMutableDictionary)
    }
}

