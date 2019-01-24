//
//  CategoryViewController.swift
//  Todolist
//
//  Created by Derek on 2019/1/24.
//  Copyright © 2019 Derek. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let actionBtn = UIAlertAction(title: "Add category", style: .default) { (action) in
            
             let category = Category(context: self.context)
            category.name = textField.text!
            self.categoryArray.append(category)
            
            self.saveCategory()
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
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    // MARK: - Table view delegate
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategory(){
        do{
          try context.save()
        }catch{
          print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        do{
            let request:NSFetchRequest<Category> = Category.fetchRequest()
           categoryArray = try context.fetch(request)
        }catch{
            print("Error fetching request \(error)")
        }
        tableView.reloadData()
    }
}
