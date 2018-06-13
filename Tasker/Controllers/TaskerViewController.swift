//
//  ViewController.swift
//  Tasker
//
//  Created by Devesh Nema on 6/12/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit
import CoreData

class TaskerViewController: UITableViewController {

    var taskArray = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
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
        saveTasksAndReloadTableData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK:- Add new tasks
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Add Task", style: UIAlertActionStyle.default) { (action) in
            //what will happen once the user clicks the add task button on our alert
            let task = Task(context: self.context)
            task.title = textField.text!
            task.done = false
            
            self.taskArray.append(task)
            self.saveTasksAndReloadTableData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- save tasks
    func saveTasksAndReloadTableData() {
        do {
            try context.save()
        } catch  {
            print("Error-101: Couldnt save context: \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK:- load tasks
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest()) {
        do {
            taskArray = try context.fetch(request)
        } catch  {
            print("Error-201: Couldnt fetch context: \(error)")
        }
        tableView.reloadData()
    }
}

//MARK:- Searchbar  methods
extension TaskerViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadTasks(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTasks()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
























