//
//  ViewController.swift
//  todolist
//
//  Created by user154652 on 7/9/19.
//  Copyright © 2019 lefleur. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var itemResults : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
            
            print(Realm.Configuration.defaultConfiguration.fileURL!)
              }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    // tableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        if let currentItem = itemResults?[indexPath.row] {
            cell.textLabel?.text = currentItem.itemName
        
            // Ternary operators ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = currentItem.flag ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
//        same functionality
//        if itemResults[indexPath.row].flag == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    
    // TableView Delegate Methods for cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let selectedItem = itemResults?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(selectedItem)
                    selectedItem.flag = !selectedItem.flag
                }
            } catch {
                print("Error saving item status \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    
    // Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoList item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
 
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.itemName = textField.text!
                        newItem.dateCreated = Date()
                       
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        
        
            // adding textfieldbb
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"

            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        //tableView.reloadData()
        
    }
    
    
    
    func loadItems(){
        
        itemResults = selectedCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
       
        tableView.reloadData()
    }
    

}

//MARK: - Searchbar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemResults = itemResults?.filter("itemName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "itemName", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
            
        }
    }
    
    
}
