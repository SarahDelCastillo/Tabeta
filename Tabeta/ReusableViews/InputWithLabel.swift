//
//  InputWithLabel.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 29/04/2023.
//

import UIKit

class InputWithLabel: UIView {
    private let inputField = UITextField()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inputField.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Default Label"
        inputField.placeholder = "Default placeholder"
        inputField.borderStyle = .roundedRect
        
        addSubview(label)
        addSubview(inputField)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            inputField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
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
