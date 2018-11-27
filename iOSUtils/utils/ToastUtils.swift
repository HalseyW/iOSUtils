//
//  ToastUtils.swift
//  iOSUtils
//
//  Created by Wushhhhhh on 2017/8/25.
//  Copyright © 2018年 wushhhhhh. All rights reserved.
//
//  1. 时间可以修改
//  2. 位置可以修改
//  TODO: 3. 透明度/颜色/圆角可以修改
import Foundation
import UIKit

extension UIView {
    /**
     默认底部，默认时间1s
     */
    func makeToast(message: String) {
        let toast = getToastView(message: message)
        toast.alpha = 0
        toast.center = ToastPosition.bottom.getPosition(forToast: toast, inSuperView: self)
        self.addSubview(toast)
        
        showToast(toast, duration: 1)
    }
    
    /**
     默认底部，自定义时间
     */
    func makeToast(message: String, duration: TimeInterval) {
        let toast = getToastView(message: message)
        toast.alpha = 0
        toast.center = ToastPosition.bottom.getPosition(forToast: toast, inSuperView: self)
        self.addSubview(toast)
        
        showToast(toast, duration: duration)
    }
    
    /**
     自定义位置，默认时间1s
     */
    func makeToast(message: String, position: ToastPosition = .bottom) {
        let toast = getToastView(message: message)
        toast.alpha = 0
        toast.center = position.getPosition(forToast: toast, inSuperView: self)
        self.addSubview(toast)
        
        showToast(toast, duration: 1)
    }
    
    /**
     自定义位置，自定义时间
     */
    func makeToast(message: String, duration: TimeInterval, position: ToastPosition) {
        let toast = getToastView(message: message)
        toast.alpha = 0
        toast.center = position.getPosition(forToast: toast, inSuperView: self)
        self.addSubview(toast)
        
        showToast(toast, duration: duration)
    }
    
    /**
     通过动画显示toast，并在指定时间后消失
     */
    private func showToast(_ toast: UIView, duration: TimeInterval) {
        UIView.animate(withDuration: 0.2, animations: {
            toast.alpha = 1
        }) { _ in
            let timer = Timer(timeInterval: duration, target: self, selector: #selector(self.toastTimerDidFinish(_:)), userInfo: toast, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    /**
     当toast时间到之后
     */
    @objc private func toastTimerDidFinish(_ timer: Timer) {
        guard let toast = timer.userInfo as? UIView else {
            return
        }
        hideToast(toast, withTimer: timer)
    }
    
    /**
     隐藏toast
     */
    private func hideToast(_ toast: UIView, withTimer timer: Timer) {
        timer.invalidate()
        UIView.animate(withDuration: 0.2, animations: {
            toast.alpha = 0.0
        }) { _ in
            toast.removeFromSuperview()
        }
    }
    
    /**
     toast的view
     */
    private func getToastView(message: String) -> UIView {
        let toastView = UIView()
        toastView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        toastView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        toastView.layer.cornerRadius = 5.0
        
        let tvMessage = UILabel()
        tvMessage.textAlignment = .center
        tvMessage.textColor = .white
        tvMessage.text = message
        tvMessage.font = UIFont.systemFont(ofSize: 14)
        tvMessage.lineBreakMode = .byTruncatingTail
        tvMessage.numberOfLines = 0
        
        let maxMessageLabelSize = CGSize(width: self.bounds.width * 0.8, height: self.bounds.height * 0.8)
        let messageLabelSize = tvMessage.sizeThatFits(maxMessageLabelSize)
        tvMessage.frame = CGRect(x: 0, y: 0, width: messageLabelSize.width, height: messageLabelSize.height)
        
        var messageRect = CGRect.zero
        messageRect.origin.x = 10.0
        messageRect.origin.y = 10.0
        messageRect.size.width = tvMessage.bounds.size.width
        messageRect.size.height = tvMessage.bounds.size.height
        let longerWidth = messageRect.size.width
        let longerX = messageRect.origin.x
        let toastViewWidth = max(20.0, (longerX + longerWidth + 10.0))
        let toastViewHeight = max((messageRect.origin.y + messageRect.size.height + 10.0), 20.0)
        
        toastView.frame = CGRect(x: 0.0, y: 0.0, width: toastViewWidth, height: toastViewHeight)
        toastView.addSubview(tvMessage)
        tvMessage.center = (tvMessage.superview?.center)!

        return toastView
    }
    
    /**
     toast位置的枚举
     */
    enum ToastPosition {
        case top
        case bottom
        case center
        
        /**
         获取不同位置下toast的center point
         */
        fileprivate func getPosition(forToast toast: UIView, inSuperView superView: UIView) -> CGPoint {
            switch self {
            case .top:
                return CGPoint(x: superView.bounds.size.width / 2, y: toast.frame.size.height / 2 + superView.toastSafeAreaInsets.top)
            case .center:
                return CGPoint(x: superView.bounds.size.width / 2, y: superView.bounds.size.height / 2)
            case .bottom:
                return CGPoint(x: superView.bounds.size.width / 2, y: superView.bounds.size.height - toast.frame.size.height / 2 - superView.toastSafeAreaInsets.bottom)
            }
        }
    }
}

extension UIView {
    /**
     全面屏手机上的安全距离
     */
    private var toastSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return .zero
        }
    }
}
