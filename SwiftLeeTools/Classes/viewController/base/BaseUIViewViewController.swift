//
//  BaseUIViewViewController.swift
//  TopsProSys
//
//  Created by topscommmac01 on 2018/10/24.
//  Copyright © 2018年 com.topscommmac01. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import QorumLogs

open class BaseUIViewViewController: UIViewController {

    /// 分页参数
    open var page:Int = 1
    open var sidx:String = ""
    open var sord:String = ""
    
    open var baseView: UIView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        initBaseView()
        logConfig()
    }
    
    //初始化基础视图
   public func initBaseView() {
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        baseView = UIView()
        baseView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.addSubview(baseView)
        baseView.snp.makeConstraints{(make) -> Void in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom)
            }
             make.left.right.equalTo(view)
        }
    }
    //日志框架配置
   public func logConfig() {
        QorumLogs.enabled = true //日志开关,默认为false
    }
    open override var shouldAutorotate: Bool{
        return false
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }

}

//提示框
extension BaseUIViewViewController{
    // 只有一个按钮的确认提示框,其中按钮内容固定
    open func showAlertOne(title:String,message:String) {
        let alertController = UIAlertController(title: title,message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // 只有一个按钮的确认提示框,其中title内容为空
    open func showAlert(title:String = "",message:String,cancelTitle:String = "好的") {
        let alertController = UIAlertController(title:title,message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //提供回调功能的弹出框
    open func showAlertWithCallBack(title:String = "",message:String,okTitle:String = "好的",isShowCancel:Bool = false,cancelTitle:String = "取消",callback:@escaping()->Void) {
        let alertController = UIAlertController(title:title,message:message,preferredStyle: .alert);
        let okAciton = UIAlertAction(title:okTitle,style:.destructive,handler: {action in
            callback()
        })
        if isShowCancel{
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
        alertController.addAction(okAciton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //用户申请完毕之后弹出返回上一页面
    open func showAlertPop(title:String = "",message:String = "提交成功") {
        let alertController = UIAlertController(title:title,message:message,preferredStyle: .alert);
        let okAciton = UIAlertAction(title:"返回",style:.default,handler: {action in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(okAciton);
        self.present(alertController, animated: true, completion: nil)
    }
    
    ///自动消失的提示框，其中显示时间为1秒
    open func showToast(message:String) {
        let alertController = UIAlertController(title: "",message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
}


//网络请求
extension BaseUIViewViewController{
    
    //需要
    open func loginAgain(){
        
    }
    
    //根据请求地址和请求参数请求ActionResult，
    open func getResultActionOnly(urlRequest :String,parameters:Parameters?,backToActionResultFunc : @escaping (_ actionResult:JSON) -> Void)  {
        Alamofire.request(urlRequest, method: HTTPMethod.post,parameters: parameters).validate().responseJSON{
            response in
            switch response.result{
            case .success:
                if let data = response.data {
                    let actionResult:JSON  = JSON(data)[ConstantsHelp.actionReuslt]
                    if actionResult[ConstantsHelp.success].boolValue {
                        backToActionResultFunc(actionResult)
                    }else{
                        if JSON(data)[ConstantsHelp.timeout].boolValue{ //登陆超时
                            self.loginAgain()
                        }else{
                            self.showAlertOne(title: "提示",message: actionResult[ConstantsHelp.message].stringValue)
                        }
                    }
                }
            case .failure(let error):
                self.showAlertOne(title: "", message: "似乎已断开与互联网的连接")
                QL1("BaseViewController getResultActionOnly 似乎已断开与互联网的连接 failure \(error)")
            }
        }
    }
    
    
    //根据请求地址和参数请求 dataMap
    open func getResultMap(urlRequest :String,parameters:Parameters?,isSupportClick:Bool = true,backToMapFunc : @escaping (_ map:JSON) -> Void)  {
        if let show = parameters!["showLoading"]{
        }else{
            showLoading(isSupportClick: isSupportClick)
        }
        Alamofire.request(urlRequest, method: HTTPMethod.post, parameters: parameters).validate().responseJSON{
            response in
            switch response.result{
            case .success:
                self.hideHUD()
                if let data = response.data {
                    let actionResult:JSON  = JSON(data)[ConstantsHelp.actionReuslt]
                    if actionResult[ConstantsHelp.success].boolValue {
                        let dataMap:JSON  = JSON(data)[ConstantsHelp.dataMap]
                        backToMapFunc(dataMap)
                    }else{
                        if JSON(data)[ConstantsHelp.timeout].boolValue{  //登陆超时
                            self.loginAgain()
                        }else{
                            self.showAlertOne(title: "提示",message: actionResult[ConstantsHelp.message].stringValue)
                        }
                    }
                }
            case .failure(let error):
                self.hideHUD()
                self.showAlertOne(title: "", message: "似乎已断开与互联网的连接")
                QL1("BaseViewController getResultMap 似乎已断开与互联网的连接 failure \(error)")
            }
        }
    }
    
    //根据请求地址和参数请求所有数据
    open func getResultTotalMap(urlRequest :String,parameters:Parameters?,isNeedPop:Bool = false,backToMapFunc : @escaping (_ map:JSON) -> Void)  {
        if let show = parameters!["showLoading"]{
        }else{
            showLoading(isSupportClick: true)
        }
        Alamofire.request(urlRequest, method: HTTPMethod.post,parameters: parameters).validate().responseJSON{
            response in
            switch response.result{
            case .success:
                self.hideHUD()
                if let data = response.data {
                    let actionResult:JSON  = JSON(data)[ConstantsHelp.actionReuslt]
                    if actionResult[ConstantsHelp.success].boolValue {
                        let dataMap:JSON  = JSON(data)
                        backToMapFunc(dataMap)
                    }else{
                        if JSON(data)[ConstantsHelp.timeout].boolValue{ //登陆超时
                            self.loginAgain()
                        }else{
                            if !isNeedPop{
                                self.showAlertOne(title: "提示",message: actionResult[ConstantsHelp.message].stringValue)
                            }else{
                                self.showAlertPop(title: "提示", message:actionResult[ConstantsHelp.message].stringValue )
                            }
                        }
                    }
                }
            case .failure(let error):
                self.hideHUD()
//                self.showAlertOne(title: "", message: "似乎已断开与互联网的连接")
                QL1("BaseViewController getResultTotalMap 似乎已断开与互联网的连接 failure \(error)")
            }
        }
    }
    
    //根据请求地址和参数请求dataList类数据
    open func getResultListMap(urlRequest :String,parameters:Parameters,backToListMapFunc : @escaping (_ list:JSON) -> Void)  {
        showLoading(isSupportClick: true)
        Alamofire.request(urlRequest, method: HTTPMethod.post,parameters: parameters).validate().responseJSON{
            response in
            switch response.result{
            case .success:
                self.hideHUD()
                if let data = response.data {
                    let actionResult:JSON  = JSON(data)[ConstantsHelp.actionReuslt]
                    if actionResult[ConstantsHelp.success].boolValue {
                        let dataList:JSON  = JSON(data)[ConstantsHelp.dataList]
                        backToListMapFunc(dataList)
                    }else{
                        if JSON(data)[ConstantsHelp.timeout].boolValue{  //登陆超时
                            self.loginAgain()
                        }else{
                            self.showAlertOne(title: "提示",message: actionResult[ConstantsHelp.message].stringValue)
                        }
                    }
                }
            case .failure(let error):
                self.hideHUD()
//                self.showAlertOne(title: "", message: "似乎已断开与互联网的连接")
                QL1("BaseViewController getResultListMap 似乎已断开与互联网的连接 failure \(error)")
            }
        }
    }
    
    
    //根据请求地址和参数请求listDataMap类数据
    open func getResultlistDataMap(urlRequest :String,parameters:Parameters,backToListMapFunc : @escaping (_ list:JSON) -> Void)  {
        showLoading(isSupportClick: true)
        Alamofire.request(urlRequest, method: HTTPMethod.post,parameters: parameters).validate().responseJSON{
            response in
            switch response.result{
            case .success:
                self.hideHUD()
                if let data = response.data {
                    let actionResult:JSON  = JSON(data)[ConstantsHelp.actionReuslt]
                    if actionResult[ConstantsHelp.success].boolValue {
                        let listDataMap:JSON  = JSON(data)[ConstantsHelp.listDataMap]
                        backToListMapFunc(listDataMap)
                    }else{
                        if JSON(data)[ConstantsHelp.timeout].boolValue{  //登陆超时
                            self.loginAgain()
                        }else{
                            self.showAlertOne(title: "提示",message: actionResult[ConstantsHelp.message].stringValue)
                        }
                    }
                }
            case .failure(let error):
                self.hideHUD()
                //self.showAlertOne(title: "", message: "似乎已断开与互联网的连接")
                QL1("BaseViewController getResultlistDataMap 似乎已断开与互联网的连接 failure \(error)")
            }
        }
    }
        /// 只限下载pdf文件
      open  func downloadPDF(url:String,isShowLoading:Bool = true,backToInfoFunc:@escaping (_ url:String) -> Void) {
            QL1(url)
            if isShowLoading {
                showLoading(isSupportClick: true)
            }
            let destination: DownloadRequest.DownloadFileDestination = { _, response in
                let documentsURL = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }

            AlamofireManager.sharedSessionManager.download(url,method:.post,headers:AlamofireManager.getToken(),to:destination).responseData { response in
                switch response.result {
                case .success:
                    if isShowLoading{
                        self.hideHUD()
                    }
                    if let path = response.destinationURL?.path{
                        let fileType = StringUtils.getSignBackStr(str:path,sign:".").lowercased()
                        if fileType.hasSuffix("pdf"){
    //                        UserDefaults.standard.set(path, forKey:url)
                            backToInfoFunc(path)
                        } else {
                            self.loginAgain()
                        }
                    }
                case .failure(let error):
                    if isShowLoading{
                        self.hideHUD()
                    }
                    self.checkNetWrokReachability(url, error: error)
                    QL1("downloadFile 似乎已断开与互联网的连接 failure \(error)")
                }
            }
        }
    
    //上传图片
    open func postImageList(urlRequest:String,keys:[String],parameters:JSON,imagesArr:[Data],imagesInfoArr:[String],isShowLoading:Bool = false, backToInfoFunc : @escaping (_ map:JSON) -> Void)  {
        if isShowLoading{
            showLoading(isSupportClick: true)
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var count = imagesArr.count
            if imagesArr.count != imagesInfoArr.count{
                count = imagesArr.count < imagesInfoArr.count ? imagesArr.count:imagesInfoArr.count // 获取最小值，取最小值，避免两者数量不一致时下面方法取照片时数组越界
            }
            for index in 0..<count {
                let withName = !VerifyHelp.checkImageInfo(imageName: imagesInfoArr[index]) ? "withName" + String(index) + ".png" : imagesInfoArr[index]
                let fileName = !VerifyHelp.checkImageInfo(imageName: imagesInfoArr[index]) ? "fileName" + String(index) + ".png" : imagesInfoArr[index]
                let data = imagesArr[index]
                multipartFormData.append(data, withName: withName, fileName: fileName, mimeType: "image/jpeg")
            }
            if keys.count > 0{
                for value in keys{
                    let data:Data = parameters[value].stringValue.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                    multipartFormData.append(data, withName:value)
                }
            }
        },  to: urlRequest,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            if isShowLoading{
                                self.hideHUD()
                            }
                            let json = JSON(value)
                            let actionResult = json["actionResult"]
                            if actionResult["success"].boolValue {
                                backToInfoFunc(actionResult)
                            }else{
                                if json[ConstantsHelp.timeout].boolValue{ //登陆超时
                                    self.loginAgain()
                                }else{
                                    backToInfoFunc(actionResult)
                                    if isShowLoading{
                                        self.showAlertOne(title: "", message: "提交失败：\(actionResult["message"])")
                                    }
                                }
                            }
                        }
                        if  response.error != nil,response.error!._code == NSURLErrorTimedOut{
//                            self.hideHUD()
                            self.showAlert(message: "网络连接超时!\n请检查网络后重试")
                        }
                    }
                case .failure(let encodingError):
                    self.hideHUD()
                    self.showAlert(message:"提交失败,错误原因为:\(encodingError)")
                    QL1(encodingError)
                }
        })
    }
    
    ///检测网络是否连接
   open func checkNetWrokReachability(_ url:String,error:Error,isShowErrorInfo:Bool = false){
        let reachability = Reachability()
        if reachability != nil{
            if !(reachability?.isReachable)!{
                self.showAlert(message: "似乎已断开与互联网的连接")
            }else{
                let resultError = error as NSError
                if isShowErrorInfo {
                    self.showToast(message: resultError.localizedDescription)
                }
            }
        }
    }

}


