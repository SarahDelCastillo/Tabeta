//
//  EditTaskViewController.swift
//  Tabeta
//
//  Created by Sarah Del Castillo on 02/05/2023.
//

import UIKit
import OSLog

final class EditTaskViewController: UIViewController {

    private var taskNameInput = InputWithLabel()
    private var submitButton = UIButton(configuration: .bordered())
    var titleLabel = UILabel()
    private var timeLabel = UILabel()
    private var datePicker = UIDatePicker()
    
    var tabeTask: TabeTask?
    /// The action to be executed on submit.
    var handleSubmit: ((TabeTask) async throws -> ())?
    
    private var logger = Logger(subsystem: "com.raahs.Tabeta", category: "EditTaskViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        setupSubviews()
    }
    
    private func setupSubviews() {
        //MARK: Label -
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        //MARK: Input -
        taskNameInput.translatesAutoresizingMaskIntoConstraints = false
        taskNameInput.configure { field, label in
            label.text = "Task name"
            field.delegate = self
            field.text = tabeTask?.name
            field.placeholder = "Feed the dog"
        }
        
        //MARK: Date picker -
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = "Schedule"
        timeLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.timeZone = TimeZone.current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 30
        setDate()
        
        //MARK: Submit -
        submitButton.setTitle("Submit!", for: .normal)
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: Constraints -
        view.addSubview(titleLabel)
        view.addSubview(taskNameInput)
        view.addSubview(timeLabel)
        view.addSubview(datePicker)
        view.addSubview(submitButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskNameInput.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            taskNameInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            taskNameInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            timeLabel.topAnchor.constraint(equalTo: taskNameInput.bottomAnchor, constant: 30),
            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            timeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            datePicker.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            
            submitButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: taskNameInput.centerXAnchor)
        ])
        
        taskNameInput.getTextField().becomeFirstResponder()
    }
    
    /// Handles the submit action.
    @objc private func submit() {
        guard let handleSubmit = handleSubmit else {
            logger.warning("handleSubmit() not found.")
            return
        }
        
        Task {
            let taskName = taskNameInput.getTextField().text ?? "No name"
            let date = extractDate()
            var taskToSend: TabeTask
            
            if let tabeTask = tabeTask {
                taskToSend = tabeTask
                taskToSend.name = taskName
                taskToSend.notifTimes = [date]
            } else {
                taskToSend = TabeTask(done: false, name: taskName, notifTimes: [date])
            }
            
            do {
                try await handleSubmit(taskToSend)
                NotificationCenter.taskUpdated()
                dismiss(animated: true)
            } catch {
                logger.error("handleSubmit task failed with error: \(error)")
            }
        }
    }
    
    /// Extracts the date from the datePicker.
    /// - Returns: The hour component of the datePicker.
    private func extractDate() -> Int {
        let formatStyle = Date.FormatStyle().hour(.defaultDigits(amPM: .omitted))
        let date = datePicker.date.formatted(formatStyle)
        return Int(date)! // There is no way this date can't be cast to Int
    }
    
    /// Sets the datePicker date from the tabeTask, if there is one.
    private func setDate() {
        if tabeTask != nil, let hour = tabeTask!.notifTimes.first {
            datePicker.setDate(Date.getDate(for: hour), animated: true)
        }
    }
}

extension EditTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
