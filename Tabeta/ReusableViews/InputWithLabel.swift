//
//  InputWithLabel.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import UIKit

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
    
    func configure(_ conf: (UITextField, UILabel) -> ()) {
        conf(inputField, label)
    }
    
    func getTextField() -> UITextField {
        inputField
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
