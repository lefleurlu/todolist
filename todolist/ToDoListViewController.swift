//
//  ViewController.swift
//  todolist
//
//  Created by user154652 on 7/9/19.
//  Copyright © 2019 lefleur. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    var itemResults : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
            
            //print(Realm.Configuration.defaultConfiguration.fileURL!)
              }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name

        guard let colourHex = selectedCategory?.colour else { fatalError() }
        
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
//MARK : - Nav bar setup methods
    func updateNavBar(withHexCode colourHexCode : String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controler does not exist.")}
        
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        //separatorStyle
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = navBarColour.cgColor
        searchBar.barTintColor = navBarColour
        
    }
    
    
 // tableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let currentItem = itemResults?[indexPath.row] {
            cell.textLabel?.text = currentItem.itemName
            
            let categoryColour = UIColor(hexString: selectedCategory?.colour ?? "#FFFFFF")
            if let itemColour = categoryColour?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemResults!.count)) {
                cell.backgroundColor = itemColour
                    cell.textLabel?.textColor = ContrastColorOf(itemColour, returnFlat: true)
            }
            
            
            
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
        
    }
    
    
    
    func loadItems(){
        
        itemResults = selectedCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
       
        tableView.reloadData()
    }
    
//MARK: - Delete data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        // Updates data model
        if let categoryForDeletion = self.itemResults?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error saving item status \(error)")
            }
        }
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
