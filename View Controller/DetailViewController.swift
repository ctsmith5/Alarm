//
//  DetailViewController.swift
//  Alarm
//
//  Created by Colin Smith on 3/11/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var alarm : Alarm? {
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        alarmNameTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    private func updateViews(){
        if let unwrappedAlarm = alarm {
            alarmNameTextField.text = unwrappedAlarm.name
            datePicker.date = unwrappedAlarm.fireTime
            if unwrappedAlarm.enabled{
                alarmButton.setTitle("Save Alarm", for: .normal)
                alarmButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            }
            else if !unwrappedAlarm.enabled{
                alarmButton.setTitle("Save Alarm", for: .normal)
                alarmButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                alarmButton.setTitleColor(.black, for: .normal)
            }
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        alarmNameTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func setAlarmButtonPressed(_ sender: UIButton) {
        print("ButtonSaveTapped")
        
        guard let alarmText = alarmNameTextField.text else { return }
        let alarmFireTime = datePicker.date
        
        if let unwrappedAlarm = alarm {
    
            AlarmController.shared.updateAlarm(alarm: unwrappedAlarm, fireTime: alarmFireTime, name: alarmText, enabled: true)
        }else{
            let newAlarm = Alarm(fireTime: alarmFireTime, name: alarmText)
            AlarmController.shared.addAlarm(fireTime: newAlarm.fireTime , name: newAlarm.name )
        }
        navigationController?.popViewController(animated: true)
    }
}
