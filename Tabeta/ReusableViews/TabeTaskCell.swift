//
//  TabeTaskCell.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 02/05/2023.
//

import UIKit
import OSLog

class TabeTaskCell: UITableViewCell {
    private let leadingTrailingPadding: CGFloat = 20
    
    private var insetView = UIView()
    private var titleLabel = UILabel()
    private var doneCheckBox = UIImageView()
    private var done: Bool = false
    
    private var logger = Logger(subsystem: "com.raahs.Tabeta", category: "TabeTaskCell")
    
    /// The action to be executed on done toggle.
    var handleDoneToggle: ((_ newValue: Bool, _ sender: TabeTaskCell) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: "Background")
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Configures the cell with the given parameters.
    /// - Parameters:
    ///   - title: The name of the task.
    ///   - done: The state of the task.
    func configureWith(title: String, done: Bool) {
        self.done = done
        //MARK: Inset view -
        insetView.translatesAutoresizingMaskIntoConstraints = false
        insetView.backgroundColor = UIColor(named: "Background light")
        insetView.clipsToBounds = true
        insetView.layer.cornerRadius = 15
        
        //MARK: Title label -
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        
        //MARK: Done check box -
        doneCheckBox.translatesAutoresizingMaskIntoConstraints = false
        doneCheckBox.isUserInteractionEnabled = true
        setIconState()
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(toggleIconState))
        doneCheckBox.addGestureRecognizer(touchGesture)
        
        //MARK: Constraints -
        contentView.addSubview(insetView)
        insetView.addSubview(titleLabel)
        insetView.addSubview(doneCheckBox)
        
        NSLayoutConstraint.activate([
            insetView.heightAnchor.constraint(equalToConstant: 60),
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
    
    /// Sets the correct icon according to the state of the task.
    private func setIconState() {
        doneCheckBox.image = done ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
    }
    
    /// Handles the toggle action.
    @objc private func toggleIconState() {
        guard let handleDoneToggle = handleDoneToggle else {
            logger.warning("handleDoneToggle not found.")
            return
        }
        done.toggle()
        doneCheckBox.image = done ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "checkmark.circle")
        handleDoneToggle(done, self)
    }
}
