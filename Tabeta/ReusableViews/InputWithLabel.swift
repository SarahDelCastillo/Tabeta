//
//  InputWithLabel.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import UIKit

/// A Tabeta standard input field with a title label.
/// It should be configured before use.
class InputWithLabel: UIView {
    private var inputField: UITextField!
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inputField = UITextField()
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.placeholder = "Default placeholder"
        inputField.borderStyle = .roundedRect
        inputField.clipsToBounds = true
        inputField.layer.borderWidth = 2
        inputField.layer.cornerRadius = 8
        inputField.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "Default Label"
        
        addSubview(label)
        addSubview(inputField)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            inputField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            inputField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            inputField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            inputField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    /// Allows the configuration of the inner UITextField and UILabel.
    /// - Parameter conf: A closure in which the nedded configuration can be done.
    func configure(_ conf: (UITextField, UILabel) -> ()) {
        conf(inputField, label)
    }
    
    /// Convenience function that allows access of the inner UITextField.
    /// - Returns: The inner UITextField.
    func getTextField() -> UITextField {
        inputField
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
