//
//  CategoryViewController.swift
//  todolist
//
//  Created by user154652 on 7/17/19.
//  Copyright © 2019 lefleur. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categoryResults : Results<Category>?
    
// MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

// MARK: - TableView Datasource Methods, to display all categories inside persisten container
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryResults?.count ?? 1
        
    }
    
// MARK: - tableView cellforaRow at IndexPath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryResults?[indexPath.row] {
            cell.textLabel?.text = category.name
        
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
        return cell

    }

    
//MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryResults?[indexPath.row]
        }
    }
    
//MARK: - Data Manipulation Methods, save and load data
    func save(category : Category) {

        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context\(error)")
        }

        tableView.reloadData()

    }

    

    func loadCategories() {

        categoryResults = realm.objects(Category.self)

        tableView.reloadData()

    }

//MARK: - Delete data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        // Updates data model
        if let categoryForDeletion = self.categoryResults?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error saving item status \(error)")
            }
        }
    }
    
    
//MARK: - Add New Categories, setting button pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()

            let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)

            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                // what happens when user clicks the button on UIAlert
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colour = UIColor.randomFlat.hexValue()
                self.save(category : newCategory)
            }
        
        
            // adding textfieldbb
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new Category"

                textField = alertTextField

            }
        
            alert.addAction(action)

            present(alert, animated: true, completion: nil)
        
    }
    
}


    
    
    
    

    


