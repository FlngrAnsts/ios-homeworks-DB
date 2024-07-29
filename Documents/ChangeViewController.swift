//
//  ChangeViewController.swift
//  Documents
//
//  Created by Anastasiya on 29.07.2024.
//

import UIKit

class ChangeViewController: UIViewController {
    
    let store: Store
    
    init(store: Store) {
        self.store = store
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите пароль"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.keyboardType = UIKeyboardType.default
        textField.backgroundColor  = UIColor.systemGray6
        textField.font = UIFont.boldSystemFont(ofSize: 16.0)
        textField.isSecureTextEntry = true
        textField.textColor = .black
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var repeadPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Повторите пароль"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var repeadPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.keyboardType = UIKeyboardType.default
        textField.backgroundColor  = UIColor.systemGray6
        textField.font = UIFont.boldSystemFont(ofSize: 16.0)
        textField.isSecureTextEntry = true
        textField.textColor = .black
        textField.placeholder = "Repead Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var sendPasswordButtonView: CustomButton = {
        let button = CustomButton(){
            self.buttonClick()
            
        }
        button.clipsToBounds = true
        button.setTitle("Изменить пароль", for: .normal)
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
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(repeadPasswordLabel)
        view.addSubview(repeadPasswordTextField)
        view.addSubview(sendPasswordButtonView)
        
        
        
    }
    
    private func setupConstraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            passwordLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            passwordLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            
            repeadPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            repeadPasswordLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            repeadPasswordLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            repeadPasswordTextField.topAnchor.constraint(equalTo: repeadPasswordLabel.bottomAnchor, constant: 8),
            repeadPasswordTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            repeadPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            repeadPasswordTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            sendPasswordButtonView.topAnchor.constraint(equalTo: repeadPasswordTextField.bottomAnchor, constant: 16),
            sendPasswordButtonView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            sendPasswordButtonView.heightAnchor.constraint(equalToConstant: 50),
            sendPasswordButtonView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            
            
        ])
        
    }
    
    func buttonClick(){
        if(passwordTextField.text?.count ?? 0 < 4 || repeadPasswordTextField.text?.count ?? 0 < 4){
            TextPicker.showMessage(in: self, title: "Ошика", message: "Слишком короткий пароль"){[weak self] in
                self?.clear()
            }
            return
        }
        if(passwordTextField.text != repeadPasswordTextField.text) {
            TextPicker.showMessage(in: self, title: "Ошика", message: "Пароли не совпадат"){ [weak self] in
                self?.clear()
            }
            return
        }
        store.save(item: passwordTextField.text!)
        dismiss(animated: true)
    }
    
    func clear(){
        passwordTextField.text = ""
        repeadPasswordTextField.text = ""
    }
    
}
