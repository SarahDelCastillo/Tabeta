//
//  AddTaskViewController.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 02/05/2023.
//

import UIKit
import OSLog

class AddTaskViewController: UIViewController {

    private var taskNameInput = InputWithLabel()
    private var submitButton = UIButton(configuration: .bordered())
    private var titleLabel = UILabel()
    
    var taskManager: TabeTaskManager?
    
    private var logger = Logger(subsystem: "com.raahs.Tabeta", category: "AddTaskViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        setupSubviews()
    }
    
    private func setupSubviews() {
        //MARK: Label -
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Add Tabetask"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        //MARK: Input -
        taskNameInput.translatesAutoresizingMaskIntoConstraints = false
        taskNameInput.configure { field, label in
            label.text = "Task name"
            field.delegate = self
            field.placeholder = "Feed the dog"
        }
        
        
        //MARK: Submit -
        submitButton.setTitle("Add task!", for: .normal)
        submitButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        //MARK: Constraints -
        view.addSubview(titleLabel)
        view.addSubview(taskNameInput)
        view.addSubview(submitButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskNameInput.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            taskNameInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            taskNameInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            submitButton.topAnchor.constraint(equalTo: taskNameInput.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: taskNameInput.centerXAnchor)
        ])
    }
    
    @objc private func addTask() {
        guard let taskManager = taskManager else {
            logger.warning("Task manager not found.")
            return
        }
        Task {
            do {
                let taskName = taskNameInput.getTextField().text ?? "No name"
                let task = TabeTask(done: false, name: taskName, notifTimes: [])
                try await taskManager.create(task: task)
                dismiss(animated: true)
            } catch {
                logger.error("Create task failed with error: \(error)")
            }
        }
    }
}

extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
