//
//  WelcomeViewController.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import UIKit

class WelcomeViewController: UIViewController {

    var welcomeLabel: UILabel!
    var nickNameField: InputWithLabel!
    var groupIdField: InputWithLabel!
    var joinCreateToggle: UISegmentedControl!
    var submitButton: UIButton!
    
    var completion: ((String, String?) async throws -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.hidesBackButton = true
        title = "Welcome to Tabeta!"
        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSubviews() {
        
        //MARK: Welcome label -
        welcomeLabel = UILabel()
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.numberOfLines = 2
        welcomeLabel.text = "Only a few more steps..."
        
        //MARK: NickName field -
        nickNameField = InputWithLabel()
        nickNameField.translatesAutoresizingMaskIntoConstraints = false
        nickNameField.configure { field, label in
            label.text = "Nickname"
            field.delegate = self
            field.placeholder = "Awesome nickname"
            field.autocorrectionType = .no
        }
        
        //MARK: joinCreate toggle -
        joinCreateToggle = UISegmentedControl(items: ["Create group", "Join group"])
        joinCreateToggle.translatesAutoresizingMaskIntoConstraints = false
        joinCreateToggle.selectedSegmentIndex = 0
        joinCreateToggle.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        joinCreateToggle.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        //MARK: Group ID field -
        groupIdField = InputWithLabel()
        groupIdField.translatesAutoresizingMaskIntoConstraints = false
        groupIdField.configure { field, label in
            label.text = "Group ID"
            field.delegate = self
            field.placeholder = "Awesome group ID"
        }
        groupIdField.isHidden = true
        
        //MARK: Submit button -
        let submitAction = UIAction(title: "Start!") { _ in
            guard let (nickname, groupId) = self.validateInputs() else { return }
            Task {
                try await self.completion?(nickname, groupId)
            }
        }
        submitButton = UIButton(type: .custom, primaryAction: submitAction)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.layer.cornerRadius = 25
        submitButton.backgroundColor = UIColor(named: "Button")
        view.addSubview(submitButton)
        
        //MARK: Final steps -
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, nickNameField, joinCreateToggle, groupIdField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.distribution = .equalSpacing
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        groupIdField.isHidden = sender.selectedSegmentIndex == 0
    }
    
    private func validateInputs() -> (String, String?)? {
        // Check for username
        guard let nickname = nickNameField.getTextField().text, !nickname.isEmpty else {
            return nil
        }
        // Check for groupname if needed
        var groupId: String? = nil
        if joinCreateToggle.selectedSegmentIndex == 1 {
            guard let text = groupIdField.getTextField().text, !text.isEmpty else {
                return nil
            }
            groupId = text
        }
        return (nickname, groupId)
    }
    
    func groupDidNotExist() {
        #warning("Don't forget this")
    }
}

extension WelcomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
