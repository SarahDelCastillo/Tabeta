//
//  AuthViewController.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import UIKit

public final class AuthViewController: UIViewController {
    
    let emailInput = InputWithLabel()
    let passwordInput = InputWithLabel()
    public var completion: ((UserCredentials) -> ())?
    public var customAction: (title: String, (() -> ()))?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        navigationController?.navigationBar.prefersLargeTitles = true
        configureSubviews()
    }
    
    private func configureSubviews() {
        //MARK: Text fields
        let stackView = UIStackView(arrangedSubviews: [emailInput, passwordInput])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        emailInput.configure { field, label in
            label.text = "E-mail"
            field.placeholder = "name@example.com"
            field.delegate = self
        }
        
        passwordInput.configure { field, label in
            label.text = "Password"
            field.placeholder = "••••••••"
            field.isSecureTextEntry = true
            field.delegate = self
        }
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        //MARK: Sign in button
        let authAction = UIAction(title: title ?? "") { [weak self] _ in
            guard let (email, password) = self?.validateInputs() else { return }
            let credentials = UserCredentials(email: email, password: password)
            self?.view.endEditing(true)
            self?.completion?(credentials)
        }
        
        let authButton = UIButton(type: .custom, primaryAction: authAction)
        authButton.translatesAutoresizingMaskIntoConstraints = false
        authButton.backgroundColor = .red
        authButton.layer.cornerRadius = 25
        
        view.addSubview(authButton)
        NSLayoutConstraint.activate([
            authButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.heightAnchor.constraint(equalToConstant: 50),
            authButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        //MARK: Custom action button
        guard let (title, action) = customAction else { return }
        let customAction = UIAction(title: title) { _ in
            action()
        }
        
        let customActionButton = UIButton(type: .system, primaryAction: customAction)
        customActionButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(customActionButton)
        NSLayoutConstraint.activate([
            customActionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customActionButton.topAnchor.constraint(equalTo: authButton.bottomAnchor, constant: 10)
        ])
    }
    
    private func validateInputs() -> (email: String, password: String)? {
        guard let email = emailInput.getTextField().text, !email.isEmpty,
              let password = passwordInput.getTextField().text, !password.isEmpty
        else { return nil }
        return (email, password)
    }
}

extension AuthViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
