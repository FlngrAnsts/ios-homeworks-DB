//
//  LogInViewController.swift
//  Documents
//
//  Created by Anastasiya on 24.07.2024.
//

import UIKit

class LogInViewController: UIViewController {
    
    let store: Store
    
    let step: Step
    
    var password = ""
    
    let routeToMaint: (()-> Void)
    
    
    init(store: Store, step: Step, routeToMaint:@escaping ()-> Void) {
        self.store = store
        self.step = step
        self.routeToMaint = routeToMaint
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "bla-bla-bla"
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.keyboardType = UIKeyboardType.default
        textField.backgroundColor  = UIColor.systemGray6
        textField.font = UIFont.boldSystemFont(ofSize: 16.0)
        textField.isSecureTextEntry = true
        textField.textColor = .black
        textField.placeholder = "Password"
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var logInButton: CustomButton = {
        let button = CustomButton(){
            self.tapButton()
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemMint
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneView()
        tuneSubview()
        
    }
    
    private func tuneView(){
        view.backgroundColor = .systemBackground
        
        switch step{
            
        case .passwordCreated:
            passwordLabel.text = "Введите пароль"
            logInButton.setTitle("Войти", for: .normal)
        case .creatPassword:
            passwordLabel.text = "Создайте пароль"
            logInButton.setTitle("Создать пароль", for: .normal)
        case .repeatPassword:
            passwordLabel.text = "Повторите пароль"
            logInButton.setTitle("Подтвердить пароль", for: .normal)
        }
    }
    
    private func tuneSubview(){
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(logInButton)
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            passwordLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    func tapButton(){
        if(passwordTextField.text?.count ?? 0 < 4){
            TextPicker.showMessage(in: self, title: "Ошика", message: "Слишком короткий пароль"){[weak self] in
                guard let self else {return}
                self.clear(self.step)
            }
            return
        }
        switch step {
        case .passwordCreated:
            if store.load() != passwordTextField.text {
                TextPicker.showMessage(in: self, title: "Ошика", message: "Неверный пароль") {[weak self] in
                    self?.clear(.passwordCreated)
                }
                return
            }
            routeToMaint()
        case .creatPassword:
            let loginViewController = LogInViewController(store: store, step: .repeatPassword, routeToMaint: routeToMaint)
            loginViewController.password = passwordTextField.text ?? ""
            navigationController?.pushViewController(loginViewController, animated: true)
        case .repeatPassword:
            if(password != passwordTextField.text){
                TextPicker.showMessage(in: self, title: "Ошика", message: "Пароли не совпадат"){ [weak self] in
                    self?.clear(.creatPassword)
                }
                return
            }
            store.save(item: passwordTextField.text!)
            routeToMaint()
            // переход
        }
        
        
    }
    func clear(_ step: Step){
        let vc = LogInViewController(store: store, step: step, routeToMaint: routeToMaint)
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    
}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
