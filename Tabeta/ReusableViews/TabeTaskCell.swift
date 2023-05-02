//
//  TabeTaskCell.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 02/05/2023.
//

import UIKit

class TabeTaskCell: UITableViewCell {
    private let leadingTrailingPadding: CGFloat = 20
    
    private var insetView: UIView!
    private var titleLabel: UILabel!
    private var doneCheckBox: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "Background")
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureWith(title: String, done: Bool) {
        insetView = UIView()
        insetView.translatesAutoresizingMaskIntoConstraints = false
        insetView.backgroundColor = UIColor(named: "Background light")
        insetView.clipsToBounds = true
        insetView.layer.cornerRadius = 15
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        
        doneCheckBox = UIImageView()
        doneCheckBox.translatesAutoresizingMaskIntoConstraints = false
        doneCheckBox.image = done ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
        
        //MARK: Constraints -
        contentView.addSubview(insetView)
        insetView.addSubview(titleLabel)
        insetView.addSubview(doneCheckBox)
        
        NSLayoutConstraint.activate([
            insetView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            insetView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            insetView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingTrailingPadding),
            insetView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -leadingTrailingPadding),
            
            titleLabel.centerYAnchor.constraint(equalTo: insetView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: insetView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: doneCheckBox.leadingAnchor, constant: 20),
            
            doneCheckBox.centerYAnchor.constraint(equalTo: insetView.centerYAnchor),
            doneCheckBox.heightAnchor.constraint(equalToConstant: 30),
            doneCheckBox.widthAnchor.constraint(equalToConstant: 30),
            doneCheckBox.trailingAnchor.constraint(equalTo: insetView.trailingAnchor, constant: -10)
        ])
    }
}
