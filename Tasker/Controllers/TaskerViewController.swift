//
//  ViewController.swift
//  Tasker
//
//  Created by Devesh Nema on 6/12/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit

class TaskerViewController: UITableViewController {

    var taskArray = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    func fetchData() {
        let travelTask = Task(title: "travel", done: false)
        let groceriesTask = Task(title: "buy groceries", done: true)
        let gymTask = Task(title: "go to gym", done: true)
        
        taskArray.append(travelTask)
        taskArray.append(groceriesTask)
        taskArray.append(gymTask)

    }
    
    //MARK:- Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.done ? .checkmark : .none
        return cell
    }
    
    //MARK:- Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskArray[indexPath.row].done = !taskArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()

    }

    //MARK:- Add new tasks
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Add Task", style: UIAlertActionStyle.default) { (action) in
            //what will happen once the user clicks the add task button on our alert
            let task = Task(title: textField.text!, done: false)
            self.taskArray.append(task)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
}
























