//
//  Store.swift
//  Documents
//
//  Created by Anastasiya on 25.07.2024.
//

import Foundation

protocol Store {
    var name: String { get }
    func load() -> String
    func save(item: String)
}

extension Store{
    func decode(data: Data) -> String {
        return (try? JSONDecoder().decode(String.self, from: data)) ?? ""
    }
    
    func encode(item: String) -> Data? {
        try? JSONEncoder().encode(item)
    }
}
