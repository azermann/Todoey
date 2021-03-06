//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Korhan Sönmezsoy on 27.02.2018.
//  Copyright © 2018 Korhan Sönmezsoy. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
 
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }
    
    // MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1 // categories? optinal olduğundan nil olabilir nil olursa ?? operatörü ondan sonraki değeri alsın demek. Yani 1 tableview cell getirsin. Nil değilse zaten değerini alsın.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
    }
    
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row] 
        }
        
    }
    
    
    
    // MARK - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData() // eklenen datayı anında göstermek için
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
     tableView.reloadData()
        
    }
    
    // MARK - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category ", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once the user clicks the Add Item Button on our UIAlert
            
        let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        
    }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
            
        }
        
        present(alert, animated: true, completion: nil)
    
    }
    
    
    
    
    
    
    
    
    
}
