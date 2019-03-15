//
//  ModelController.swift
//  Alarm
//
//  Created by Colin Smith on 3/11/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation

import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(alarmToCancel: Alarm)
}

class AlarmController: AlarmScheduler {
    
    //Singleton
    static let shared = AlarmController()
    
    // Source of Truth
    var alarms: [Alarm] = []
    
    // Create
    func addAlarm(fireTime: Date, name: String) {
        let newAlarm = Alarm(fireTime: fireTime, name: name)
        alarms.append(newAlarm)
        scheduleUserNotifications(for: newAlarm)
        // Save to Persistent Store
        saveToPersistentStore()
    }
    
    //Update
    func updateAlarm(alarm: Alarm, fireTime: Date, name: String, enabled: Bool) {
        cancelUserNotifications(alarmToCancel: alarm)
        
        alarm.name = name
        alarm.fireTime = fireTime
        alarm.enabled = enabled
        
        scheduleUserNotifications(for: alarm)
        saveToPersistentStore()
        
    }
    
    //Delete
    func delete(alarm: Alarm){
        guard let index = alarms.index(of: alarm) else {return}
        //remove it from the SOT
        alarms.remove(at: index)
        //Cancel the notification
        cancelUserNotifications(alarmToCancel: alarm)
        // Save
        saveToPersistentStore()
    }
    func toggleIsSet(for alarm: Alarm){
        alarm.enabled = !alarm.enabled
    }
    
    //Persistence
    func fileURL() -> URL {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirect = filePath[0]
        
        let fileName = "alarms.json"
        
        let fullURL = docDirect.appendingPathComponent(fileName)
        return fullURL
    }
    
    func saveToPersistentStore(){
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        }catch{
            print("There was an error loading the array \(error) \(error.localizedDescription) ")
            return
        }
    }
    
    func loadFromPersistentStore(){
        let decoder = JSONDecoder()
        do{
            let data = try Data(contentsOf: fileURL())
            let loadedAlarms = try decoder.decode([Alarm].self, from: data)
            self.alarms = loadedAlarms
        }catch{
            print("error in loading from persistent store \(error)")
        }
    }
}
extension AlarmScheduler {
    
    func scheduleUserNotifications(for alarm: Alarm){
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = alarm.name
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.minute, .second], from: alarm.fireTime )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let alarmError = error {
                print("Hey!! Could not deliver notification to user \(alarmError.localizedDescription)")
            }
        }
    }
    
    func cancelUserNotifications(alarmToCancel: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarmToCancel.uuid])
    }
}
