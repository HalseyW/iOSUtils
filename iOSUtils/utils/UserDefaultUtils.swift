//
//  UserDefaultUtils.swift
//  iOSUtils
//
//  Created by Wushhhhhh on 2018/8/25.
//  Copyright © 2018年 wushhhhhh. All rights reserved.
//
import Foundation

extension UserDefaults {
    static func saveInt(_ value: Int, forKey: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: forKey.rawValue)
    }
    
    static func saveString(_ value: String, forKey: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: forKey.rawValue)
    }
    
    static func saveBool(_ value: Bool, forKey: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: forKey.rawValue)
    }
    
    static func saveFloat(_ value: Float, forKey: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: forKey.rawValue)
    }
    
    static func saveDouble(_ value: Any, forKey: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: forKey.rawValue)
    }
    
    static func getInt(forKey: UserDefaultsKey) {
        UserDefaults.standard.integer(forKey: forKey.rawValue)
    }
    
    static func getString(forKey: UserDefaultsKey) {
        UserDefaults.standard.string(forKey: forKey.rawValue)
    }
    
    static func getBool(forKey: UserDefaultsKey) {
        UserDefaults.standard.bool(forKey: forKey.rawValue)
    }
    
    static func getFloat(forKey: UserDefaultsKey) {
        UserDefaults.standard.float(forKey: forKey.rawValue)
    }
    
    static func getDouble(forKey: UserDefaultsKey) {
        UserDefaults.standard.double(forKey: forKey.rawValue)
    }
    
    static func remove(forKey: UserDefaultsKey) {
        UserDefaults.standard.removeObject(forKey: forKey.rawValue)
    }
}

/**
 UserDefaults的key值，避免直接使用字符串导致错误
 */
enum UserDefaultsKey: String {
    case id
}
