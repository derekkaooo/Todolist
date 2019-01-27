//
//  CategoryViewController.swift
//  Todolist
//
//  Created by Derek on 2019/1/24.
//  Copyright © 2019 Derek. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categoryArray:Results<Category>?
    var todoItems:Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let actionBtn = UIAlertAction(title: "Add category", style: .default) { (action) in
            
             let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category."
            textField = alertTextField
        }
        alert.addAction(actionBtn)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No Categories Added yet"
        
        //MARK: test
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    // MARK: - Table view delegate
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let category = categoryArray?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(category)
                    //MARK: 一併刪除子類別
                    if todoItems != nil{
                        realm.delete(todoItems!)
                    }else{
                        print("todoItems has no value")
                    }
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
    }
     //MARK: test
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        var textField = UITextField()
       let alert = UIAlertController(title: "Changed title", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Change", style: .default) { (action) in
            
            if let catagory = self.categoryArray?[indexPath.row] {
                do{
                    try self.realm.write {
                        if textField.text != "" {
                            catagory.name = textField.text!
                        }else{
                            self.alertController(for: "Please insert data!!!")
                        }
                    }
                }catch{
                    print("Error saving status, \(error)")
                }
            }
            tableView.reloadData()
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    // MARK: - Data Manipulation Methods
    
    func save(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
          print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}

extension CategoryViewController{
    func alertController(for message:String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
