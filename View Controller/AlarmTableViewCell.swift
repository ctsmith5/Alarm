//
//  AlarmTableViewCell.swift
//  Alarm
//
//  Created by Colin Smith on 3/11/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

protocol AlarmTableViewDelegate: class {
    func switchValueChanged(cell: AlarmTableViewCell, isSet: Bool)
}

class AlarmTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var fireTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    var delegate: AlarmTableViewDelegate?
    
    var alarm: Alarm? {
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        guard let alarm = alarm else {return}
        fireTimeLabel.text = alarm.timeAsString
        nameLabel.text = alarm.name
        enabledSwitch.isOn = alarm.enabled
    }
    
    @IBAction func swithTogglePressed(_ sender: UISwitch) {
        delegate?.switchValueChanged(cell: self, isSet: enabledSwitch.isOn)
    }
    
}
