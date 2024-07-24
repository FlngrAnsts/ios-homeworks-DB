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
        showMessageAddFolder(in: self) { [weak self] text in
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
    
    func showMessageAddFolder(in viewController: UIViewController, complition: @escaping ((_ text: String) -> Void)){
        let alert = UIAlertController(title: "Add Folder", message: nil, preferredStyle: .alert)
        let alerOkAction = UIAlertAction(title: "Ok", style: .default){_ in
            if let text = alert.textFields?[0].text{
                complition(text)
            }
        }
        let alerCancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField{ textField in
            textField.placeholder = "Entel name folder"
        }
        alert.addAction(alerOkAction)
        alert.addAction(alerCancelAction)
        viewController.present(alert, animated: true)
    }
    
    private func presentImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fileManager.contentsOfDirectory(path: content.path).count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        config.text = fileManager.contentsOfDirectory(path: content.path)[indexPath.row]
        cell.contentConfiguration = config
        cell.accessoryType = fileManager.isPatchForItemIsFolder(path: content.path, name: fileManager.contentsOfDirectory(path: content.path)[indexPath.row]) ? .disclosureIndicator : .none
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileManager.removeContent(path: content.path, nameDeleteItem: fileManager.contentsOfDirectory(path: content.path)[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fileManager.isPatchForItemIsFolder(path: content.path, name: fileManager.contentsOfDirectory(path: content.path)[indexPath.row]) {
            let vc = MainTableViewController()
            vc.content = Content(path: content.path + "/" + fileManager.contentsOfDirectory(path: content.path)[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
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

