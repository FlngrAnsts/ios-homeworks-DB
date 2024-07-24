//
//  FileManagerServiceProtocol.swift
//  Documents
//
//  Created by Anastasiya on 24.07.2024.
//

import Foundation
import UIKit

protocol FileManagerServiceProtocol {
    func contentsOfDirectory(path: String) -> [String]
    func createDirectory(path: String, name: String)
    func createFile(path: String, image: UIImage)
    func removeContent(path: String, nameDeleteItem: String)
    func isPatchForItemIsFolder(path: String, name: String) -> Bool
    
}
