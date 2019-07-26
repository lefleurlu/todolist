//
//  CategoryViewController.swift
//  todolist
//
//  Created by user154652 on 7/17/19.
//  Copyright © 2019 lefleur. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
// MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        //loadCategories()
    }

// MARK: - TableView Datasource Methods, to display all categories inside persisten container
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
// MARK: - tableView cellforaRow at IndexPath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell

    }

//MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
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

    
//    //          external internal parameter names       cc
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//
//    }
    
    
//MARK: - Add New Categories, setting button pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()

            let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)

            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                // what happens when user clicks the button on UIAlert
                let newCategory = Category()
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)

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
    
 
    //MARK: - TableView Delegate Methods
    
    
    
    

    
}

