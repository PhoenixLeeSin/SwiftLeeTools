//
//  NetWorkTools.swift
//  TopsProSys
//
//  Created by 李桂盛 on 2019/12/9.
//  Copyright © 2019 com.topscommmac01. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//MARK:- 获取需要数据节点名称
public enum DataKey: String {
    
    case all = "all"
    case dataMap = "dataMap"
    case dataList = "dataList"
    case listDataMap = "listDataMap"
}
//MARK:- 错误码
public enum ErrorCode{
    //200...299
    case invalidResponse(String)
    //actionResult中的 ’success‘为false
    case sysError(String)
    //其他错误 如 ‘failure’ 返回HTTP状态码 以及 错误信息描述
    case networkUnavailable(String?,Int?)
}

public typealias Success<T> = (T) -> Void

public typealias Failure = (ErrorCode) -> Void

public final class NetWorkTools {
    
    private init() {}
    
    static let shared = NetWorkTools()
    
    var sessionManger: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        let manger = Alamofire.SessionManager(configuration: config)
        return manger
    }()
    
}
extension NetWorkTools {
    /**
     * 基本请求方法
     * @param url             请求地址
     * @param param           参数
     * @param method          post get
     * @param dataKey         获取的数据部分 例如 data 下面的 ‘dataList’部分
     * @param headers         请求头
     * @param isNeedReConnect 需要重连 默认true 重连3次
     * @param success         成功回调
     * @param failure         失败回调
     */
    public static func getNormalRequestWith(url: String,
                                         param: Parameters,
                                         method: HTTPMethod,
                                         dataKey: DataKey = .all,
                                         headers: [String:String],
                                         isNeedRetrier: Bool = true,
                                         success: @escaping Success<JSON>,
                                         failure: @escaping Failure) {
        
        if isNeedRetrier {
            shared.sessionManger.retrier = NetWorkRetrier()
        } else {
            shared.sessionManger.retrier = nil
        }
        
        shared.sessionManger.request(url, method: method, parameters: param, encoding: URLEncoding.default, headers: headers)
            .validate() //200...299
            .responseJSON { (response) in
                //在200...299之外
                if let error = response.error {
                    failure(.invalidResponse(error.localizedDescription))
                }
                switch response.result {
                case .success:
                    if let data = response.data{
                        let actionReuslt = JSON(data)[ConstantsHelp.actionReuslt]
                        if actionReuslt[ConstantsHelp.success].boolValue {
                            let json = JSON(data)[dataKey.rawValue]
                            success(json)
                        } else {
                            let message = (actionReuslt[ConstantsHelp.message].stringValue)
                                failure(.sysError(message))
                        }
                    }
                case .failure(let error):
                    if let error = error as? AFError {
                        failure(.networkUnavailable(error.localizedDescription, error._code))
                    }
                }
        }
    }

    /**
     * 基本上传方法
     * @param url             请求地址
     * @param keys            参数
     * @param parameters      整个数据
     * @param datasArr        数据信息
     * @param datasInfoArr    数据信息描述
     * @param isNeedReConnect 需要重连 默认true 重连3次
     * @param success         成功回调
     * @param failure         失败回调
     */
    public static func uploadRequestWith(url: String,
                                         keys: [String],
                                         parameters: JSON,
                                         datasArr:[Data],
                                         datasInfoArr:[String],
                                         isNeedRetrier: Bool,
                                         headers: [String:String],
                                         success: @escaping Success<JSON>,
                                         failure: @escaping Failure){
        if isNeedRetrier {
            shared.sessionManger.retrier = NetWorkRetrier()
        } else {
            shared.sessionManger.retrier = nil
        }
        
        shared.sessionManger.upload(multipartFormData: { (multipartFormData) in
            //拼接数据
            var count = datasArr.count
            count = datasArr.count <= datasInfoArr.count ? datasArr.count:datasInfoArr.count
            for index in 0..<count {
                let data = datasArr[index]
                
                let withName = !VerifyHelp.checkImageInfo(imageName: datasInfoArr[index]) ? "withName" + String(index) + data.getImageFormat()!: datasInfoArr[index]
                let fileName = !VerifyHelp.checkImageInfo(imageName: datasInfoArr[index]) ? "fileName" + String(index) + data.getImageFormat()! : datasInfoArr[index]
                               
                multipartFormData.append(data, withName: withName, fileName: fileName, mimeType: "application/octet-stream")
            }
            if keys.count > 0{
                for value in keys{
                    let data:Data = parameters[value].stringValue.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                    multipartFormData.append(data, withName:value)
                }
            }
            
        }, to: url, headers: headers) { (result) in
            switch result {
            case .success(let upload, _ , _):
                upload.responseJSON { (response) in

                    if let data = response.result.value as? [String : AnyObject] {
                        let actionResult = JSON(data)[ConstantsHelp.actionReuslt]
                        if  actionResult[ConstantsHelp.success].boolValue {
                            success(actionResult)
                        } else {
                            let message = (actionResult[ConstantsHelp.message].stringValue)
                            failure(.sysError(message))
                        }
                    }
                    else {
                       if let error = response.error {
                           failure(.invalidResponse(error.localizedDescription))
                       }
                    }
                    
                }
            case .failure(let error):
                if let error = error as? AFError {
                    failure(.networkUnavailable(error.localizedDescription, error._code))
                }
            }
        }
    }
    /**
     * 基本下载方法
     * @param url             请求地址
     * @param isNeedReConnect 需要重连 默认true 重连3次
     * @param method          HTTPMethod
     * @param params          Parameters
     * @param headers         [String:String]
     * @param success         成功回调
     * @param failure         失败回调
     */
    public static func downloadFileWith(url: String,
                                        isNeedRetrier: Bool = true,
                                        method: HTTPMethod = .post,
                                        params: Parameters,
                                        headers: [String:String],
                                        success: @escaping Success<String>,
                                        failure: @escaping Failure) {
        if isNeedRetrier {
            shared.sessionManger.retrier = NetWorkRetrier()
        } else {
            shared.sessionManger.retrier = nil
        }
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        shared.sessionManger.download(url, method: method, parameters: params, encoding: URLEncoding.default, headers: headers, to: destination).responseData { (response) in
            switch response.result {
            case .success:
                if let path = response.destinationURL?.path{
                      success(path)
                }else {
                    failure(.sysError("下载失败，请稍后重试"))
                }
            case .failure(let error):
                if let error = error as? AFError {
                    failure(.networkUnavailable(error.localizedDescription, error._code))
                }
            }
        }
    }
}
//MARK:-RequestRetrier
class NetWorkRetrier: RequestRetrier {
    
    private var count : Int = 0
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if count < 3 {
            completion(true,1)
            count += 1
            print(count)
        } else {
            completion(false, 0)
        }
    }
}
