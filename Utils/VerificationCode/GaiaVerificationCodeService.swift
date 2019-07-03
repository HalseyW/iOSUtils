//
//  GaiaVerificationCodeService.swift
//  iOSUtils
//
//  Created by HalseyW-15 on 2019/7/3.
//  Copyright © 2019 wushhhhhh. All rights reserved.
//

import Foundation

class GaiaVerificationCodeService {
    /// Service回调代理
    weak var delegate: GaiaVerificationCodeDelegate?
    /// 是否为第二次发送验证码，服务端更换运营商，第一次为false，之后变为true
    private var isRetry = false
    /// 倒计时器
    private var countdownTimer: Timer?
    /// 是否正在倒计时
    private(set) var isCountingDown = false {
        didSet {
            if isCountingDown {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerScheduled), userInfo: nil, repeats: true)
                countdownTime = 59
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
        }
    }
    /// 倒计时时间
    private var countdownTime = 0 {
        didSet {
            guard let delegate = self.delegate else {
                fatalError("VerificationCodeService delegate is nil")
            }
            if countdownTime == 0 {
                isCountingDown = false
            }
            delegate.countdownTimeDidChange(to: countdownTime)
        }
    }
    
    /// 发送验证码
    ///
    /// - Parameter account: 接收验证码的账号
    func sendVerificationCode(with account: String) {
        let param = ["account" : account, "retry": isRetry] as [String : Any]
        HTTPUtils.post(URL: HTTPUtils.sendVerificationCodeURL, param: param, success: { (json) in
            self.isCountingDown = true
            self.delegate?.verificationCodeSendResult(message: nil)
        }) { (error) in
            self.delegate?.verificationCodeSendResult(message: error.errorMsg)
        }
        isRetry = true
    }
    
    /// 验证验证码
    ///
    /// - Parameters:
    ///   - code: 需要被验证码
    ///   - account: 接收验证码的账号
    func verify(verifycationCode code: String, with account: String) {
        let URL = HTTPUtils.verifyVerificationCodeURL + "?account=" + account + "&code=" + code
        HTTPUtils.get(URL: URL, success: { (json) in
            self.delegate?.verifyVerrificationCodeResult(message: nil)
        }) { (error) in
            self.delegate?.verifyVerrificationCodeResult(message: error.errorMsg)
        }
    }
    
    /// 倒计时方法
    @objc private func onTimerScheduled() {
        countdownTime -= 1
    }
}
