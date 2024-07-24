//
//  FileManagerService.swift
//  Documents
//
//  Created by Anastasiya on 24.07.2024.
//

import Foundation
import UIKit

class FileManagerService: FileManagerServiceProtocol{
    
    func contentsOfDirectory(path: String) -> [String] {
        return (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? []
    }
    
    func createDirectory(path: String, name: String) {
        try? FileManager.default.createDirectory(atPath: path + "/" + name, withIntermediateDirectories: true)
    }
    
    func createFile(path: String, image: UIImage) {
        if let data = image.pngData() {
            let randomInt = Int.random(in: 0..<1000)
            let url = URL(fileURLWithPath: path + "/" + "image_\(randomInt).jpg")
            try? data.write(to: url)
        }
    }
    
    func removeContent(path: String, nameDeleteItem: String) {
        try? FileManager.default.removeItem(atPath: path + "/" + nameDeleteItem)
    }
    
    func isPatchForItemIsFolder(path: String, name: String) -> Bool{
        var objCBool: ObjCBool = .init(false)
        FileManager.default.fileExists(atPath: path + "/" + name, isDirectory: &objCBool)
        return objCBool.boolValue
    }
    
}
