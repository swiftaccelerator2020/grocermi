//
//  ShoppingListViewController.swift
//  grocermi
//
//  Created by Joshua Lim on 8/12/20.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedCategory = ""
    var categories: [String] = []
    var isACategory = false
    
    @IBOutlet weak var tableView: UITableView!
        
    var arrayOfItems: [Grocery] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let loadedGroceries = Grocery.loadFromFile(){
            if !loadedGroceries.isEmpty {
                arrayOfItems = loadedGroceries
            } else {
                arrayOfItems = Grocery.loadSampleData()
            }
        } else {
            arrayOfItems = Grocery.loadSampleData()
        }

        print(arrayOfItems)
        
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
        
        tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /*
        for i in 1...arrayOfItems.count {
            
            isACategory = false
            
            if categories != [] {
                for o in 1...categories.count {
                    if arrayOfItems[i - 1].groceryCat == categories[o - 1] {
                        isACategory = true
                        break
                    }
                }
            } else {
                isACategory = false
            }
            
            if isACategory == false {
                categories.append(arrayOfItems[i - 1].groceryCat)
            }
        }
        */
        
        print(categories)
        
        tableView.reloadData()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row]
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCategory = categories[indexPath.row]
        
        performSegue(withIdentifier: "Selection", sender: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "addButton", sender: nil)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        performSegue(withIdentifier: "settings", sender: nil)
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {

        print("unwound")
        
        if let loadedGroceries = Grocery.loadFromFile() {
                print("Found file! Loading friends!")
                arrayOfItems = loadedGroceries
            } else {
                print("No Groceries 😢 Making some up")
                arrayOfItems = Grocery.loadSampleData()
            }

        print(arrayOfItems)
        
        tableView.reloadData()
        
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == "Selection" {
            let selectionTableViewController = segue.destination as! SelectionTableViewController
            
            selectionTableViewController.selectedCategory = selectedCategory
        }
    }
     
}
