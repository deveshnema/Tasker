//
//  ViewController.swift
//  Tasker
//
//  Created by Devesh Nema on 6/12/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SwipeCellKit
import ChameleonFramework

class TaskerViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var taskArray = [Task]()
    let db = Firestore.firestore()

    var selectedCategory : Category? {
        didSet {
            loadTasks()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.separatorStyle = .none
    }
    
    func animateTable() {
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        guard let colorhex = selectedCategory?.color else {return}
        guard let navbarcolor = UIColor(hexString: colorhex) else {return}
        searchBar.barTintColor = navbarcolor
        navigationController?.navigationBar.barTintColor = navbarcolor
        navigationController?.navigationBar.tintColor = ContrastColorOf(navbarcolor, returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navbarcolor, returnFlat: true)]
        animateTable()  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6") else {return}
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : FlatWhite()]
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
        if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(taskArray.count)) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    
    //MARK:- Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskArray[indexPath.row].done = !taskArray[indexPath.row].done
        //saveTasksAndReloadTableData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK:- Add new tasks
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Add Task", style: UIAlertActionStyle.default) { (action) in
            //what will happen once the user clicks the add task button on our alert
            let task = Task(title: textField.text!, done: false, parentCategory: self.selectedCategory!)
            self.selectedCategory?.tasks.append(task)
            if let name = self.selectedCategory?.name {
                self.db.collection("categories").document("\(name)").setData((self.selectedCategory?.dictionary)!, merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:- load tasks
    func loadTasks() {
        taskArray = (selectedCategory?.tasks)!
        tableView.reloadData()
    }
}

//MARK:- Searchbar  methods
//extension TaskerViewController : UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Task> = Task.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadTasks(with: request, predicate: predicate)
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadTasks()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}

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























