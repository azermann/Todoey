//
//  ViewController.swift
//  Todoey
//
//  Created by Korhan Sönmezsoy on 15.02.2018.
//  Copyright © 2018 Korhan Sönmezsoy. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //appdelegate eerişmek için
   

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // yolu konsola yazdırıyoruz
        
        
        
        

        
    }

   // MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
//        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        return cell
        
    }
    
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(itemArray[indexPath.row])
       // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark // seçili olana checkmark koyuyor
        
          itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row]) //save etmeden güncellemez
//        itemArray.remove(at: indexPath.row) // delete den sonra yazmazsak patlıyor
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) // seçince gri arka ekran yanıp sönüyor(flash ediyor)
    }
    
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item Button on our UIAlert
            
           
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
           self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - Model Manupulation Methods
    
    func saveItems() {
        
        
        
        do {
          try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData() // eklenen datayı anında göstermek için
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { // with external parametre request internal parametre func içinde request dışında kullanırken with ile = default value koyduk = diyerek kullanırken parametre vermek zorunda değiliz
        
       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let catagorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catagorypredicate, additionalPredicate])
        } else {
            request.predicate = catagorypredicate
        }
        
        do {
          itemArray =  try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        
        
    }

    
    
    }

    //MARK - Search bar methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // cd koyunca büyük küçük harf farketmiyor
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // ascending true alfabetik sırada
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // klavye gitsin searchbar type imleci gitsin diye
            }
            
        }
    }
}

