//
//  Alarm.swift
//  Alarm
//
//  Created by Colin Smith on 3/11/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation

class Alarm: Codable {
    var fireTime: Date
    var name: String
    var enabled: Bool
    var uuid: String
    
    var timeRemaining: TimeInterval?
    var alarm: Alarm?
    
    var timeAsString: String {
        let timeString = DateFormatter()
        timeString.dateStyle = .none
        timeString.timeStyle = .short
        return timeString.string(from: fireTime)
    }
    
    init(fireTime: Date, enabled: Bool = true, name: String, uuid: String = UUID().uuidString){
        self.fireTime = fireTime
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
}

extension Alarm: Equatable{
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    
}
