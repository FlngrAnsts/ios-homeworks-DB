//
//  SettingsViewController.swift
//  Documents
//
//  Created by Anastasiya on 29.07.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let updateTable: ()-> Void
    
    init( updateTable: @escaping () -> Void) {
        self.updateTable = updateTable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var alphabetOrderLabelView: UILabel = {
        let label = UILabel()
        label.text = "Cортировка"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var alphabetOrderSwitchView: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = !Settings.shared.alphabetOrder
        uiSwitch.addTarget(self, action: #selector(onClickalphAbetOrderSwitch(sender:)), for: UIControl.Event.valueChanged)
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    private lazy var viewPhotoSizeLabelView: UILabel = {
        let label = UILabel()
        label.text = "Показывать размер фотографии"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var viewPhotoSizeSwitchView: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = !Settings.shared.viewPhotoSize
        uiSwitch.addTarget(self, action: #selector(onClickViewPhotoSizeSwitch(sender:)), for: UIControl.Event.valueChanged)
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    private lazy var buttonPassword: CustomButton = {
        let button = CustomButton(){
            let keychan = KeychainStore()
            let changeViewcontroller = ChangeViewController(store: keychan)
            self.present(changeViewcontroller, animated: true)
        }
        button.setTitle("Изменить пароль", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
          
          tuneView()
          addSubviews()
          setupConstraints()
          
      }
      
      private func tuneView() {
          view.backgroundColor = .white
      }
      
      private func addSubviews() {
          view.addSubview(alphabetOrderLabelView)
          view.addSubview(alphabetOrderSwitchView)
          
          view.addSubview(viewPhotoSizeLabelView)
          view.addSubview(viewPhotoSizeSwitchView)
          
          view.addSubview(buttonPassword)
      }
      
      private func setupConstraints() {
          let safeAreaLayoutGuide = view.safeAreaLayoutGuide
          
          NSLayoutConstraint.activate([
              
              alphabetOrderLabelView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
              alphabetOrderLabelView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
              
              alphabetOrderSwitchView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
              alphabetOrderSwitchView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
              
              viewPhotoSizeLabelView.topAnchor.constraint(equalTo: viewPhotoSizeSwitchView.topAnchor, constant: 0),
              viewPhotoSizeLabelView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
              
              viewPhotoSizeSwitchView.topAnchor.constraint(equalTo: alphabetOrderSwitchView.bottomAnchor, constant:  16),
              viewPhotoSizeSwitchView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
              
              buttonPassword.topAnchor.constraint(equalTo: viewPhotoSizeSwitchView.bottomAnchor, constant:  16),
              buttonPassword.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
              buttonPassword.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16)
              
              
          ])
      }
      
      @objc func onClickalphAbetOrderSwitch(sender: UISwitch) {
          Settings.shared.alphabetOrder = !sender.isOn
          updateTable()
      }
      @objc func onClickViewPhotoSizeSwitch(sender: UISwitch) {
          Settings.shared.viewPhotoSize = !sender.isOn
          updateTable()
      }
    

    
}
