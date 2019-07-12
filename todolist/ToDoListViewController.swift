//
//  ViewController.swift
//  todolist
//
//  Created by user154652 on 7/9/19.
//  Copyright © 2019 lefleur. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dataFilePath)
        
        loadItems()
        
    }
    
    
    // tableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
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
        //print(itemArray[indexPath.row])

        itemArray[indexPath.row].flag = !itemArray[indexPath.row].flag
//      same funcionality
//        if itemArray[indexPath.row].flag == false {
//            itemArray[indexPath.row].flag = true
//        } else {
//            itemArray[indexPath.row].flag = false
//        }
        
        saveItems()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    // Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoList item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happens when user clicks the button on UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            
            // forced unwrapped because the text property of a textfield will never be null
            //self.itemArray.append(textField.text!)
            
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
        let encoder = PropertyListEncoder()
        
        do{
            let data =  try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()
        
        
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array: \(error)")
            }
        }
        
        
    }
}

