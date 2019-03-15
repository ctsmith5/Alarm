//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Colin Smith on 3/11/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //AlarmController.shared.loadFromPersistentStore()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return AlarmController.shared.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as? AlarmTableViewCell
       let alarm = AlarmController.shared.alarms[indexPath.row]
        cell?.delegate = self
        cell?.alarm = alarm
        return cell ?? UITableViewCell()
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let specificAlarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: specificAlarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ToDetailView" {
            let destinationVC = segue.destination as? DetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let cellChoice = AlarmController.shared.alarms[indexPath.row]
                destinationVC?.alarm = cellChoice
        }
    }
}

extension AlarmListTableViewController: AlarmTableViewDelegate{
    func switchValueChanged(cell: AlarmTableViewCell, isSet: Bool) {
        guard let alarm = cell.alarm else {return}
        AlarmController.shared.toggleIsSet(for: alarm)
    }
}
