//
//  Settings.swift
//  Documents
//
//  Created by Anastasiya on 29.07.2024.
//

import Foundation

final class Settings {
    
    static let shared = Settings()
    
    var alphabetOrder: Bool {
        get {
            UserDefaults.standard.bool(forKey: "alphabetOrder")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "alphabetOrder")
        }
    }
    
    var viewPhotoSize: Bool {
        get {
            UserDefaults.standard.bool(forKey: "viewPhotoSize")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "viewPhotoSize")
        }
    }
    
}
