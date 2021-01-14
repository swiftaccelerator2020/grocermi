//
//  HomeViewController.swift
//  grocermi
//
//  Created by Joshua Lim on 7/1/21.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    var refreshControl = UIRefreshControl()
    var arrayOfItems:[Grocery] = []
    var categories:[String] = []
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        
        print("test for run")
        
        if indexPath.row == 0 {
            cell.nameLabel.text = "Alerts"
            
            var arrayOfFilteredItems:[Grocery] = []
            
            for i in 0...arrayOfItems.count - 1 {
                if arrayOfItems[i].isAlert {
                    arrayOfFilteredItems.append(arrayOfItems[i])
                }
            }
            
            cell.items = arrayOfFilteredItems
            
        } else {
            cell.nameLabel.text = categories[indexPath.row - 1]
            
            var arrayOfFilteredItems:[Grocery] = []
            
            for i in 0...arrayOfItems.count - 1 {
                if arrayOfItems[i].groceryCat == categories[indexPath.row - 1] {
                    arrayOfFilteredItems.append(arrayOfItems[i])
                    print("category is \(categories[indexPath.row - 1])")
                    print("arrayOfItems is \(arrayOfItems[i].groceryCat)\n")
                }
            }
            
            print(arrayOfFilteredItems)
            
            cell.items = arrayOfFilteredItems
        }
                
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let loadedCategories = CategoriesAndGroceries.loadFromCategoryFile() {
                print("Found file! Loading friends!")
                categories = loadedCategories
            } else {
                print("No Categories 😢 Making some up")
                categories = CategoriesAndGroceries.loadSampleCategoryData()
            }
        
        if let loadedGroceries = Grocery.loadFromFile() {
                print("Found file! Loading friends!")
                arrayOfItems = loadedGroceries
            } else {
                print("No Groceries 😢 Making some up")
                arrayOfItems = Grocery.loadSampleData()
                print("sample data is \(Grocery.loadSampleData())")
            }
        
        print("ViewWillAppear Ran")
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let loadedCategories = CategoriesAndGroceries.loadFromCategoryFile() {
                print("Found file! Loading friends!")
                categories = loadedCategories
            } else {
                print("No Categories 😢 Making some up")
                categories = CategoriesAndGroceries.loadSampleCategoryData()
            }
        
        if let loadedGroceries = Grocery.loadFromFile() {
                print("Found file! Loading friends!")
                arrayOfItems = loadedGroceries
            } else {
                print("No Groceries 😢 Making some up")
                arrayOfItems = Grocery.loadSampleData()
                print("sample data is \(Grocery.loadSampleData())")
            }
            
        
        print(arrayOfItems)
        
        let currentDate = Date()
        
        for i in 0...arrayOfItems.count - 1 {
            if arrayOfItems[i].alerts == true {
                if arrayOfItems[i].existingStock <= 3 {
                    arrayOfItems[i].isAlert = true
                } else {
                                        
                        if let expiryDate = arrayOfItems[i].expiryDate {
                            
                            let correctedDate = Calendar.current.date(byAdding: .day, value: -4, to: expiryDate)
                            
                            if let correctedDate2 = correctedDate {
                                if currentDate > correctedDate2 {
                                    arrayOfItems[i].isAlert = true
                                } else {
                                    arrayOfItems[i].isAlert = false
                                }
                            }
                        } else {
                            arrayOfItems[i].isAlert = false
                        
                    }
                }
            } else {
                arrayOfItems[i].isAlert = false
            }
        }
        
        print("this be running yo")
        
        Grocery.saveToFile(groceries: arrayOfItems)
            
            
        tableView.reloadData()
                
    }
    
    @IBAction func addObject(_ sender: Any) {
        
        performSegue(withIdentifier: "add Object", sender: nil)
        
    }
    
    @IBAction func unwind(_ sender: Any) {
        
        let currentDate = Date()
        
        print("Unwound")
        if let loadedCategories = CategoriesAndGroceries.loadFromCategoryFile() {
                print("Found file! Loading friends!")
                categories = loadedCategories
            } else {
                print("No Categories 😢 Making some up")
                categories = CategoriesAndGroceries.loadSampleCategoryData()
            }
        
        if let loadedGroceries = Grocery.loadFromFile() {
                print("Found file! Loading friends!")
                arrayOfItems = loadedGroceries
            } else {
                print("No Groceries 😢 Making some up")
                arrayOfItems = Grocery.loadSampleData()
                print("sample data is \(Grocery.loadSampleData())")
            }
                
        for i in 0...arrayOfItems.count - 1 {
            if arrayOfItems[i].alerts == true {
                if arrayOfItems[i].existingStock <= 3 {
                    arrayOfItems[i].isAlert = true
                } else {
                                        
                        if let expiryDate = arrayOfItems[i].expiryDate {
                            
                            let correctedDate = Calendar.current.date(byAdding: .day, value: -4, to: expiryDate)
                            
                            if let correctedDate2 = correctedDate {
                                if currentDate > correctedDate2 {
                                    arrayOfItems[i].isAlert = true
                                } else {
                                    arrayOfItems[i].isAlert = false
                                }
                            }
                        } else {
                            arrayOfItems[i].isAlert = false
                        
                    }
                }
            } else {
                arrayOfItems[i].isAlert = false
            }
        }
        Grocery.saveToFile(groceries: arrayOfItems)

        
        tableView.reloadData()
    }
    
    
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    
    */
}
