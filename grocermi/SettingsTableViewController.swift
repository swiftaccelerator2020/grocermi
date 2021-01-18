//
//  SettingsTableViewController.swift
//  grocermi
//
//  Created by Joshua Lim on 30/12/20.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var categories: [String] = []
    var groceries: [String] = []
    var arrayOfItems: [Grocery] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let loadedGroceries = CategoriesAndGroceries.loadFromGroceryFile(){
            if loadedGroceries.isEmpty {
                groceries = loadedGroceries
            } else {
                groceries = CategoriesAndGroceries.loadSampleGroceryData()
            }
        } else {
            groceries = CategoriesAndGroceries.loadSampleGroceryData()
        }
        
        if let loadedCategories = CategoriesAndGroceries.loadFromCategoryFile() {
                if loadedCategories.isEmpty {
                    print("Found file! Loading friends!")
                    categories = loadedCategories
                } else {
                    categories = CategoriesAndGroceries.loadSampleCategoryData()
                }
            } else {
                print("No Categories 😢 Making some up")
                categories = CategoriesAndGroceries.loadSampleCategoryData()
            }
        
        if let loadedGroceries = Grocery.loadFromFile(){
            if !loadedGroceries.isEmpty {
                arrayOfItems = loadedGroceries
            } else {
                arrayOfItems = Grocery.loadSampleData()
            }
        } else {
            arrayOfItems = Grocery.loadSampleData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        print(arrayOfItems)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return categories.count
        } else if section == 1 {
            return groceries.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Categories"
        } else if section == 1 {
            return "Grocery"
        } else {
            return "Title"
        }

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        if indexPath.section == 0 {
            cell.textLabel?.text = categories[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = groceries[indexPath.row]
        }
        return cell
    }
    
    @IBAction func createNewCategory(_ Sender: Any) {
        let alert = UIAlertController(title: "Category Or Grocery", message: "Choose whether to change your category or grocery", preferredStyle: .actionSheet)
        
        let groceryAdd = UIAlertAction(title: "Add Grocery", style: .default, handler: { (action) -> Void in
            let otherAlert = UIAlertController(title: "Add Grocery", message: "Type in the name of your grocery", preferredStyle: .alert)
            otherAlert.addTextField { (textField: UITextField) in
                textField.placeholder = "Name"
                textField.keyboardType = .default
            }
            let addButton = UIAlertAction(title: "Add", style: .default, handler: {(action) -> Void in
                let alertTextField = otherAlert.textFields![0]
                let unwrappedTextField = alertTextField.text ?? "Unnamed"
                
                if unwrappedTextField != "" {
                    self.groceries.append(unwrappedTextField)
                }
                
                self.tableView.reloadData()
                
                CategoriesAndGroceries.saveToGroceryFile(groceries: self.groceries)
            })
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: {(action) -> Void in })
            
            otherAlert.addAction(addButton)
            otherAlert.addAction(cancelButton)
            
            self.present(otherAlert, animated: true, completion: nil)
        })
        
        let categoryAdd = UIAlertAction(title: "Add Category", style: .default, handler: {(action) -> Void in
            let otherAlert = UIAlertController(title: "Add Category", message: "Type in the name of your category", preferredStyle: .alert)
            otherAlert.addTextField { (textField: UITextField) in
                textField.placeholder = "Name"
                textField.keyboardType = .default
            }
            let addButton = UIAlertAction(title: "Add", style: .default, handler: {(action) -> Void in
                let alertTextField = otherAlert.textFields![0]
                let unwrappedTextField = alertTextField.text ?? "Unnamed"
                
                if unwrappedTextField != "" {
                    self.categories.append(unwrappedTextField)
                }
                    
                self.tableView.reloadData()
                
                CategoriesAndGroceries.saveToCategoryFile(categories: self.categories)
            })
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: {(action) -> Void in })
            
            otherAlert.addAction(addButton)
            otherAlert.addAction(cancelButton)
            
            self.present(otherAlert, animated: true, completion: nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in })
        
        alert.addAction(groceryAdd)
        alert.addAction(categoryAdd)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 0 {
                
                var numberRemoved = 0
                
                for i in 0...arrayOfItems.count - 1 {
                    if arrayOfItems[i - numberRemoved].groceryCat == categories[indexPath.row] {
                        
                        arrayOfItems.remove(at: i - numberRemoved)
                        
                        print(i - numberRemoved)
                        
                        numberRemoved += 1
                    }
                }
                
                Grocery.saveToFile(groceries: arrayOfItems)

                categories.remove(at: indexPath.row)
                
            } else if indexPath.section == 1 {
                
                var numberRemoved = 0
                
                for i in 0...arrayOfItems.count - 1 {
                    if arrayOfItems[i - numberRemoved].grocery == groceries[indexPath.row] {
                        
                        arrayOfItems.remove(at: i - numberRemoved)
                        
                        print(i - numberRemoved)
                        
                        numberRemoved += 1
                    }
                }
                
                Grocery.saveToFile(groceries: arrayOfItems)

                
                groceries.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            CategoriesAndGroceries.saveToGroceryFile(groceries: groceries)
            CategoriesAndGroceries.saveToCategoryFile(categories: categories)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
