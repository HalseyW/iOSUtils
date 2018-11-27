//
//  UserDefaultUtils.swift
//  iOSUtils
//
//  Created by Wushhhhhh on 2017/8/25.
//  Copyright © 2018年 wushhhhhh. All rights reserved.
//
//  UserDefaults的key值，直接扩展String，避免直接使用字符串导致错误
//  extension String {
//      static let ID = "id"
//  }
import Foundation

extension UserDefaults {
    static func saveInt(_ value: Int, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    static func saveString(_ value: String, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    static func saveBool(_ value: Bool, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    static func saveFloat(_ value: Float, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    static func saveDouble(_ value: Any, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }
    
    static func getInt(forKey: String) {
        UserDefaults.standard.integer(forKey: forKey)
    }
    
    static func getString(forKey: String) {
        UserDefaults.standard.string(forKey: forKey)
    }
    
    static func getBool(forKey: String) {
        UserDefaults.standard.bool(forKey: forKey)
    }
    
    static func getFloat(forKey: String) {
        UserDefaults.standard.float(forKey: forKey)
    }
    
    static func getDouble(forKey: String) {
        UserDefaults.standard.double(forKey: forKey)
    }
    
    static func remove(forKey: String) {
        UserDefaults.standard.removeObject(forKey: forKey)
    }
}
