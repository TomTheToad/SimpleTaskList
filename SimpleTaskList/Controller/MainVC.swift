//
//  MainVC.swift
//  SimpleTaskList
//
//  Created by Victor on 10/27/18.
//  Copyright © 2018 TomTheToad. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    // Fields
    let coreData = CoreDataController()
//    var fetchedRC: NSFetchedResultsController<Task>! {
//        didSet {
//            print("fetchedRC was set")
//        }
//    }
    var fetchedRCGroups: NSFetchedResultsController<TaskGroup>! {
        didSet {
            print("fetchedRCGroups was set")
        }
    }
    
    // Current task group for table section
    var currentTaskGroup: TaskGroup?
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTaskButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchedRC = coreData.getAllTasks()
        fetchedRCGroups = coreData.getAllTaskGroups()
        addTestItems()

        tableView.delegate = self
        tableView.dataSource = self
//        fetchedRC.delegate = self
        fetchedRCGroups.delegate = self
        
        newTaskButton.layer.cornerRadius = 5
//        updateFetchedResultsGroups()
    }
    
    // IBActions
    @IBAction func newTaskButton(_ sender: Any) {
//        let group = fetchedRC.fetchedObjects?.first!
//        coreData.newTask(name: "a new task", info: "test task", groupId: group?.id!)
    }
    
    // Helper Functions
//    func updateFetchedResults() {
//        do {
//            try fetchedRC.performFetch()
//        } catch {
//            print("problem with task fetch")
//        }
//        tableView.reloadData()
//    }
    
    func updateFetchedResultsGroups() {
        do {
            try fetchedRCGroups.performFetch()
        } catch {
            print("problem with group fetch")
        }
    }

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = fetchedRCGroups.fetchedObjects?.count ?? 0
//        print("number of sections: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedRCGroups.fetchedObjects?[section] else {
            return 0
        }
        
        print("using section: \(String(describing: section.name))")
        
        // MARK: test set current task group
        currentTaskGroup = section
        
        guard let numberTasks = section.hasTasks?.count else {
            return 0
        }
//        print("number of task in section: \(numberTasks)")
        return numberTasks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") else {
            return UITableViewCell()
        }
        
//        guard let taskGroup = currentTaskGroup else {
//            return cell
//        }
        
        guard let taskGroup = fetchedRCGroups.sections[]
        
        guard let task = taskGroup.hasTasks?.allObjects[indexPath.row] as? Task else {
            return cell
        }
        
        cell.textLabel?.text = task.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let rowHeight = (tableView.visibleCells.first?.frame.height) ?? tableView.sectionHeaderHeight
        return rowHeight * 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.sectionHeaderHeight)
        let view = UIView(frame: frame)
        let color = UIColor(red: 82/255, green: 174/255, blue: 1, alpha: 1)
        view.backgroundColor = color
        
        let label = UILabel()
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        guard let taskGroup = currentTaskGroup else {
            label.text = "Title Missing"
            return view
        }
        label.text = taskGroup.name!
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        cell.textLabel?.textColor = (cell.textLabel?.textColor == .lightGray) ? .black : .lightGray
    }
}

extension MainVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else {
            return
        }
        
        switch type {
        case .insert:
            tableView.insertRows(at: [cellIndex], with: .automatic)
            print("new object detected")
        case .delete:
            tableView.deleteRows(at: [cellIndex], with: .automatic)
        default:
            break
        }
    }
}

extension MainVC {
    // Test Functions
    func addTestItems() {
        // Test groups which hold tasks (aka group of tasks)
        let testGroup1 = coreData.newTaskGroup(name: "testGroup1", info: nil)
        let testGroup2 = coreData.newTaskGroup(name: "testGroup2", info: nil)
        
        // Tasks group 1
        let task1 = coreData.newTask(name: "task1", info: "do something", groupId: testGroup1.id)
        let task2 = coreData.newTask(name: "task2", info: "do another thing", groupId: testGroup1.id)
        
        // Tasks group 2
        let task3 = coreData.newTask(name: "task3", info: "do a bigger thing", groupId: testGroup2.id)
        let task4 = coreData.newTask(name: "task4", info: "do a small thing", groupId: testGroup2.id)
        
        // Add tasks to group 1
        testGroup1.addToHasTasks(task1)
        testGroup1.addToHasTasks(task2)
        
        // Add tasks to group 2
        testGroup2.addToHasTasks(task3)
        testGroup2.addToHasTasks(task4)
        
        coreData.saveContext()
    }
}
