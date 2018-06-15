//
//  ViewController.swift
//  Tasker
//
//  Created by Devesh Nema on 6/12/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class TaskerViewController: UITableViewController {

    var taskArray = [Task]()
    
    var selectedCategory : Category? {
        didSet {
            loadTasks()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "TaskCell")
    }


    //MARK:- Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
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
            task.parentCategory = self.selectedCategory
            
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
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

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
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadTasks(with: request, predicate: predicate)
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

//MARK:- SwipeTableViewCellDelegate delegate
extension TaskerViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.taskArray.remove(at: indexPath.row)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

}























