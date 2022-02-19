//
//  ViewController.swift
//  Notes-Realm
//
//  Created by Maheshwaran on 19/02/22.
//

import UIKit
import RealmSwift

class NotesViewController: UITableViewController {

    var NotesItems: Results<Item>? // =[Item]()
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
 
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Items"
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      
    }

//MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for: indexPath)
        if let item = NotesItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //ternary operator:> value = condition? valueIFTrue: valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // Mark: - User InterAction
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = NotesItems?[indexPath.row] {
            do {
                try realm.write({
                    //realm.delete(item)
                    item.done = !item.done
                })
            } catch {
                print("Error saving done satus, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // textfield
        var textField = UITextField()
       
        let alert = UIAlertController(title: "Add New Remainder", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // When your Tap Add item button
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                                   
                    }
                    
                }
                catch {
                    print("Error in saving ,\(error)")
                }
            }
            self.tableView.reloadData()
            }
           
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create a New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
 
    func loadItems() {
        
        NotesItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    
}

//MARK: - SearchBar Delegate
extension NotesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        NotesItems = NotesItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath:  "dateCreated", ascending: true)
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


