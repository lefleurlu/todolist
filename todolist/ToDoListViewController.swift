//
//  ViewController.swift
//  todolist
//
//  Created by user154652 on 7/9/19.
//  Copyright © 2019 lefleur. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            //loadItems()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // tableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let item = itemArray[indexPath.row]
        
   //     cell.textLabel?.text = itemArray[indexPath.row].title
        
        // Ternary operators ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.flag ? .checkmark : .none
//        same functionality
//        if itemArray[indexPath.row].flag == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    // TableView Delegate Methods for cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if itemArray[indexPath.row].flag == true {
//            context.delete(itemArray[indexPath.row])
//            itemArray.remove(at: indexPath.row)
//        } else {
//            itemArray[indexPath.row].flag = !itemArray[indexPath.row].flag
//        }
//
//        saveItems()
//
//        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    // Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoList item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happens when user clicks the button on UIAlert
            
            //accesing the appdelegate as object
          
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.flag = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//
//
            // forced unwrapped because the text property of a textfield will never be null

            
            self.saveItems()
   
        }
        
            // adding textfieldbb
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"

            textField = alertTextField
            
        }
        
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        do{
            try context.save()
        } catch {
            print("Error saving context\(error)")
        }
        
        tableView.reloadData()
        
        
    }
    
    //          external internal parameter names       default value
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        //let request : NSFetchRequest<Item> = Item.fetchRequest()
//        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//   
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
////
////        request.predicate = compoundPredicate
//        
//        do {
//           itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//        
//        tableView.reloadData()
//    }
    

}

////MARK: - Searchbar methods
//extension ToDoListViewController: UISearchBarDelegate {
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        loadItems(with: request, predicate:  predicate)
//        
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//            
//            
//            
//        }
//    }
//    
//    
//}
