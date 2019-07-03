//
//  GaiaVerificationCodeDelegate.swift
//  iOSUtils
//
//  Created by HalseyW-15 on 2019/7/3.
//  Copyright © 2019 wushhhhhh. All rights reserved.
//
import Foundation

@objc protocol GaiaVerificationCodeDelegate {
    /// 验证码发送结果
    ///
    /// - Parameter message: nil 则成功，不为 nil 则失败
    func verificationCodeSendResult(message: String?)
    
    /// 验证验证码结果
    ///
    /// - Parameter message: nil 则成功，不为 nil 则失败
    func verifyVerrificationCodeResult(message: String?)
    
    /// 倒计时时间变化
    ///
    /// - Parameter time: 倒计时时间
    func countdownTimeDidChange(to time: Int)
}
