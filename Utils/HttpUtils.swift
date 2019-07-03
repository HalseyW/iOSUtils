//
//  HttpUtils.swift
//  MVVMPractice
//
//  Created by HalseyW-15 on 2019/7/2.
//  Copyright © 2019 wushhhhhh. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct HTTPUtils {
    static let sendVerificationCodeURL = "https://192.168.1.135/account/rest/sendCode"
    static let verifyVerificationCodeURL = "https://192.168.1.135/account/rest/verifyCode"
    /// 配置Alamofire
    static let manager: SessionManager = {
        /// 屏蔽Http验证
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["192.168.1.135": .disableEvaluation]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        return Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
    //网络状态监听
    static let networkReachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    
    /// 发送post请求
    ///
    /// - Parameters:
    ///   - URL: 请求地址
    ///   - param: 请求参数
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调
    static func post(URL: String, param: [String: Any], success: @escaping (_ json: JSON) -> Void, failure: @escaping (_ error: HTTPError) -> Void) {
        let dataRequest = manager.request(URL, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
        dataRequest.responseJSON { (dataResponse) in
            if dataResponse.result.isSuccess {
                handleSuccessResponseData(from: dataResponse.data, success, failure)
            } else {
                handleFailResponseResult(from: dataResponse, failure)
            }
        }
    }
    
    /// 发送get请求
    ///
    /// - Parameters:
    ///   - URL: 请求地址
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调
    static func get(URL: String, success: @escaping (_ json: JSON) -> Void, failure: @escaping (_ error: HTTPError) -> Void) {
        let dataRequest = manager.request(URL, method: .get, encoding: JSONEncoding.default, headers: nil)
        dataRequest.responseJSON { (dataResponse) in
            if dataResponse.result.isSuccess {
                handleSuccessResponseData(from: dataResponse.data, success, failure)
            } else {
                handleFailResponseResult(from: dataResponse, failure)
            }
        }
    }
    
    /// 处理请求成功后服务器返回的数据
    ///
    /// - Parameters:
    ///   - data: 服务器返回的数据
    ///   - success: 请求成功（这里的请求成功指的是正确返回数据）的闭包
    ///   - failure: 请求错误的闭包
    static func handleSuccessResponseData(from data: Data?, _ success: @escaping (_ json: JSON) -> Void, _ failure: @escaping (_ error: HTTPError) -> Void) {
        guard let data = data else {
            return
        }
        let json = JSON(data)
        let code = json["code"].stringValue
        if code == "success" {
            success(json)
        } else {
            let subCode = json["subCode"].stringValue
            let msg = json["msg"].stringValue
            failure(HTTPError(code: subCode, errorMsg: msg))
        }
    }
    
    /// 处理请求失败后的结果
    ///
    /// - Parameters:
    ///   - dataResponse: 请求结果
    ///   - failure: 请求错误的回调
    static func handleFailResponseResult(from dataResponse: DataResponse<Any>, _ failure: @escaping (_ error: HTTPError) -> Void) {
        if let error = dataResponse.result.error {
            failure(HTTPError(code: "Other -1: ", errorMsg: "\(error.localizedDescription)"))
        } else {
            let code = dataResponse.response?.statusCode
            failure(HTTPError(code: "Other -2: ", errorMsg: "\(code ?? -1)"))
        }
    }
    
    /// 获取设备当前网络状态
    ///
    /// - Returns: 网络状态：1：WiFi；2：移动网络；0：没有网络或其他
    static func getNetworkType() -> Int {
        let type = networkReachabilityManager?.networkReachabilityStatus
        if type == .reachable(.ethernetOrWiFi) {
            return 1
        } else if type == .reachable(.wwan) {
            return 2
        } else {
            return 0
        }
    }
}

/// 网络请求错误实体类
struct HTTPError {
    var code: String
    var errorMsg: String
    
    init(code: String, errorMsg: String) {
        self.code = code
        self.errorMsg = errorMsg
    }
}
