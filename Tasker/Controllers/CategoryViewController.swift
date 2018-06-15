//
//  CategoryViewController.swift
//  Tasker
//
//  Created by Devesh Nema on 6/13/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadCategories()
    }
 
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var  textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textfield.text
            newCategory.color = UIColor.randomFlat.hexValue()
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        if let color = categories[indexPath.row].color {
            cell.backgroundColor = UIColor(hexString: color)
        }
        return cell
    }
    
    
    //MARK:- TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TaskerViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK:- data manipulation methods
    func saveCategories() {
        do {
            try context.save()
        } catch  {
            print("ERROR-301: couldnt save context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch  {
            print("ERROR-401: couldnt load categories \(error)")
        }
        tableView.reloadData()
    }

}






















