//
//  Model.swift
//  Documents
//
//  Created by Anastasiya on 24.07.2024.
//

import Foundation

struct Content {
    var path: String = ""
    var title: String {
        return NSString(string: path).lastPathComponent
    }
    
    init(path: String) {
        self.path = path
    }
    
}
