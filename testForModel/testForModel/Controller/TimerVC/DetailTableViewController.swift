//
//  TimerViewController+Tableview.swift
//  testForModel
//
//  Created by 박형석 on 2021/03/07.
//

import UIKit

class DetailTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let timeManager = TimeManager.shared
    
    @IBOutlet weak var timeTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeManager.times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath)
        let time = timeManager.secondToMinuteSecond(wholeSecond: Int(timeManager.times[indexPath.row].time))
        let timeString = timeManager.makeTimeString(minute: time.0, second: time.1)
        cell.textLabel?.text = timeString
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let times = timeManager.times
        guard !times.isEmpty else { return UISwipeActionsConfiguration(actions: [])}
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            let time = times[indexPath.row]
            self.timeManager.deleteTime(time: time)
            self.timeManager.readTimes()
            DispatchQueue.main.async {
                self.timeTableView.reloadData()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func scrollToBottom(){
       guard timeManager.times.count > 0 else { return }
        let lastRowInLastSection = timeManager.times.count - 1
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: lastRowInLastSection, section: 0)
            self.timeTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    
    
    
}
