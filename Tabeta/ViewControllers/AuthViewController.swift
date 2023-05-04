//
//  AuthViewController.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import UIKit
import OSLog

public final class AuthViewController: UIViewController {
    
    let emailInput = InputWithLabel()
    let passwordInput = InputWithLabel()
    var modeButton = UIButton()
    var authButton = UIButton()
    public var authAction: ((Bool, UserCredentials) -> ())?
    
    private let logger = Logger(subsystem: "com.raahs.Tabeta", category: "Auth")
    
    /// true = signIn,
    /// false = register
    var currentMode: Bool = true {
        didSet {
            updateTitles(for: currentMode)
        }
    }
    
    //MARK: Life cycle -
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        configureSubviews()
        updateTitles(for: currentMode)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: Private functions -
    
    private func updateTitles(for mode: Bool) {
        if mode {
            title = "Sign in"
            authButton.setTitle("Sign in", for: .normal)
            modeButton.setTitle("Register", for: .normal)
            return
        }
        title = "Register"
        authButton.setTitle("Register", for: .normal)
        modeButton.setTitle("Sign in", for: .normal)
    }
    
    private func validateInputs() -> (email: String, password: String)? {
        guard let email = emailInput.getTextField().text, !email.isEmpty,
              let password = passwordInput.getTextField().text, !password.isEmpty
        else { return nil }
        return (email, password)
    }
    
    @objc func authButtonAction() {
        guard let (email, password) = validateInputs() else { return }
        guard let authAction = authAction else {
            logger.warning("auhtAction() not found.")
            return
        }
        let credentials = UserCredentials(email: email, password: password)
        view.endEditing(true)
        authAction(currentMode, credentials)
    }
    
    @objc func modeButtonAction() {
        currentMode.toggle()
    }
}

//MARK: Subviews -
extension AuthViewController {
    private func configureSubviews() {
        let stackBottomAnchor = configureTextFields()
        
        //MARK: Sign in button
        authButton.translatesAutoresizingMaskIntoConstraints = false
        authButton.addTarget(self, action: #selector(authButtonAction), for: .touchUpInside)
        authButton.backgroundColor = UIColor(named: "Button")
        authButton.layer.cornerRadius = 25
        
        view.addSubview(authButton)
        NSLayoutConstraint.activate([
            authButton.topAnchor.constraint(equalTo: stackBottomAnchor, constant: 30),
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.heightAnchor.constraint(equalToConstant: 50),
            authButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        //MARK: Mode button
        modeButton.addTarget(self, action: #selector(modeButtonAction), for: .touchUpInside)
        modeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(modeButton)
        NSLayoutConstraint.activate([
            modeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modeButton.topAnchor.constraint(equalTo: authButton.bottomAnchor, constant: 12)
        ])
    }
    
    private func configureTextFields() -> NSLayoutYAxisAnchor {
        let stackView = UIStackView(arrangedSubviews: [emailInput, passwordInput])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        
        emailInput.configure { field, label in
            label.text = "E-mail"
            field.placeholder = "name@example.com"
            field.keyboardType = .emailAddress
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
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
        
        return stackView.bottomAnchor
    }
}

extension AuthViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
