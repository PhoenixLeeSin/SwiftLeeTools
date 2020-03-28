//
//  CryptoViewController.swift
//  topsiOSPro_Example
//
//  Created by 李桂盛 on 2020/2/25.
//  Copyright © 2020 李桂盛. All rights reserved.
//

import UIKit
import SwiftLeeTools

class CryptoViewController: UIViewController , UITextFieldDelegate{

    //密码
    @IBOutlet weak var ClientPwd: UITextField!
    //key
    @IBOutlet weak var keyFromServer: UITextField!
    //根据密码和key生成的hmac
    @IBOutlet weak var hmacL: UILabel!
    //token时间戳
    @IBOutlet weak var token: UITextField!
    //最后加密的结果
    @IBOutlet weak var lastValue: UILabel!
    
    
    //server存储的hmac
    @IBOutlet weak var hmacServerL: UILabel!
    //结果
    @IBOutlet weak var resultL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func getLastHMAC(_ sender: Any) {
        if !(hmacL.text?.isEmpty ?? false) && !(token.text?.isEmpty ?? false) {
            lastValue.text = CryptoSwoftTool.getEncryptedPasswordWith(hmacL.text!.bytes, token.text!, .md5).toHexString()
        }
        
    }
    @IBAction func vertfySameViaServer(_ sender: Any) {
        let hamcServer = (hmacServerL.text!.bytes.toHexString() + token.text!).bytes.md5().toHexString()
        if hamcServer == lastValue.text {
            resultL.text = "Same!"
        } else {
            resultL.text = "Different!"
        }
    }
    
    
    //delegate 默认MD5
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(ClientPwd.text?.isEmpty ?? false) && !(keyFromServer.text?.isEmpty ?? false) {
            hmacL.text = CryptoSwoftTool.getHMACByServerWith(keyFromServer.text!, ClientPwd.text!, .md5).toHexString()
            hmacServerL.text = hmacL.text
        }
    }
    
}
