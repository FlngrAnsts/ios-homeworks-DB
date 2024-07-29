//
//  KeychainStore.swift
//  Documents
//
//  Created by Anastasiya on 25.07.2024.
//

import Foundation
import KeychainSwift

final class KeychainStore: Store {
    var name: String {
        return "KeychainStore"
    }
    
    func load() -> String {
        if let data = KeychainSwift().getData("database") {
            return decode(data: data)
        } else {
            return ""
        }
    }
    
    func save(item: String) {
        if let data = encode(item: item) {
            KeychainSwift().set(data, forKey: "database")
        }
    }
    
    
}
