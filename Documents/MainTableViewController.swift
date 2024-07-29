//
//  MainTableViewController.swift
//  Documents
//
//  Created by Anastasiya on 24.07.2024.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var content: Content = Content(path: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    var fileManager: FileManagerServiceProtocol = FileManagerService()

    override func viewDidLoad() {
        super.viewDidLoad()
        tuneView()
        
    }
    private func tuneView(){
        view.backgroundColor = .systemBackground
        let createFolderButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(didTabCreateFolder))
        let addImageButton = UIBarButtonItem(image:UIImage(systemName: "plus") , style: .plain, target: self, action: #selector(didTabAddImage))
        navigationItem.rightBarButtonItems = [addImageButton, createFolderButton]
        title = content.title
    }
    
    @objc private func didTabCreateFolder(){
        TextPicker.showMessageAddFolder(in: self) { [weak self] text in
            guard let self else {
                return
            }
            fileManager.createDirectory(path: self.content.path, name: text)
            tableView.reloadData()
        }
    }
    
    @objc private func didTabAddImage(){
        presentImagePicker()
    }
    

    
    private func presentImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func fileSize(atPath path: String) -> Int64 {
        let fileManager = FileManager.default
        do {
            let attributes = try fileManager.attributesOfItem(atPath: path)
            if let fileSize = attributes[FileAttributeKey.size] as? Int64 {
                return fileSize
            } else {
                print("Unable to get file size")
                return -1
            }
        } catch {
            print("Error: \(error)")
            return -1
        }
    }
    
    func updateTable(){
        tableView.reloadData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fileManager.contentsOfDirectory(path: content.path, isSorted: !Settings.shared.alphabetOrder).count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        let isFolder = fileManager.isPatchForItemIsFolder(path: content.path, name: fileManager.contentsOfDirectory(path: content.path, isSorted: !Settings.shared.alphabetOrder)[indexPath.row])
        config.text = fileManager.contentsOfDirectory(path: content.path, isSorted: !Settings.shared.alphabetOrder)[indexPath.row]
        if(!isFolder && !Settings.shared.viewPhotoSize){
            config.secondaryText = "size: \(fileSize(atPath: content.path + "/" + fileManager.contentsOfDirectory(path: content.path, isSorted: !Settings.shared.alphabetOrder)[indexPath.row])) kb"
        }
        cell.contentConfiguration = config
        cell.accessoryType = isFolder ? .disclosureIndicator : .none
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileManager.removeContent(path: content.path, nameDeleteItem: fileManager.contentsOfDirectory(path: content.path, isSorted: !Settings.shared.alphabetOrder)[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fileManager.isPatchForItemIsFolder(path: content.path, name: fileManager.contentsOfDirectory(path: content.path, isSorted: !Settings.shared.alphabetOrder)[indexPath.row]) {
            let viewController = MainTableViewController()
            viewController.content = Content(path: content.path + "/" + fileManager.contentsOfDirectory(path: content.path, isSorted: !Settings.shared.alphabetOrder)[indexPath.row])
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension MainTableViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            fileManager.createFile(path: content.path, image: pickedImage)
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}

