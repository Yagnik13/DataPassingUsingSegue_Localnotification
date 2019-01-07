//
//  SecondVC.swift
//  DataPassingUsingSegue
//
//  Created by Yagnik Suthar on 02/01/19.
//  Copyright © 2019 ecosmob. All rights reserved.
//

import UIKit
import UserNotifications

class SecondVC: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge : UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    let datePicker = UIDatePicker()
    
    var rawDic           : DataModel?
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    var selectedDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.addTarget(self, action: #selector(SecondVC.datePickerValueChanged(_:)), for: .valueChanged)
        createDatePicker()
        createToolbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DESIGN UI COMPONENT
    func createDatePicker(){
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .white
        datePicker.minuteInterval = 1
        datePicker.setValue(UIColor.black, forKey: "textColor")
        txtDate.inputView = datePicker
    }
    
    func createToolbar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SecondVC.doneClick))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SecondVC.cancelClick))
        
        toolBar.setItems([cancelButton,spacer,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtDate.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        txtDate.text = dateFormatter.string(from: datePicker.date)
        txtDate.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        txtDate.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        print(sender.date)
        
        self.selectedDate = sender.date
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        //print("Selected value \(selectedDate)")
        txtDate.text = selectedDate
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        
        if let day = components.day, let month = components.month, let year = components.year ,let min = components.minute , let hr = components.hour {
            print("Day: \(day) Month: \(month) Year: \(year) min: \(min) hr: \(hr)")
        }
        
    }

    func isValid() -> Bool {
        if txtName.text == "" {
            print("Please enter name")
            return false
        }
        
        if txtAge.text == "" {
            print("Please enter age")
            return false
        }
        
        if txtDate.text == "" {
            print("Please Select date")
            return false
        }
        return true
    }
    
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        if isValid() {
            rawDic =  DataModel(dictionary:["name":txtName.text,
                                            "desc":txtAge.text,
                                            "date":txtDate.text
                ] as [String : Any?])
            scheduleNotification()
            self.performSegue(withIdentifier: "unwindToMainVCWithSegue", sender: nil)
        }
    }
    
    
    // MARK: - NOTIFICATION Methods
    
    func scheduleNotification(){
        // Request Notification Settings
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    
                    // Schedule Local Notification
                    self.scheduleLocalNotification()
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "YAGNIK SUTHAR"
        notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "Please check your notification"
        
        // Specific Time
        var dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: self.selectedDate!)
        if let min = dateComponents.minute , let hr = dateComponents.hour ,let sec = dateComponents.second{
            print("hr: \(hr) min: \(min) sec: \(sec)")
        }
        
        var timeInterval = 10.0
        
        if let date = self.selectedDate {
             timeInterval = date.timeIntervalSinceNow
            print(timeInterval)
        }
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval:timeInterval , repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }

}
