//
//  AddObjectFromShoppingViewController.swift
//  grocermi
//
//  Created by Joshua Lim on 8/12/20.
//

import UIKit

class AddObjectFromShoppingViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var existingStockNumber: UITextField!
    @IBOutlet weak var presetButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
        
    var categories: [String] = []
    var groceries: [String] = []
    
    var arrayOfItems: [Grocery] = []
    var selectedGrocery: String?
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let loadedGroceries = Grocery.loadFromFile(){
            arrayOfItems = loadedGroceries
        } else {
            arrayOfItems = Grocery.loadSampleData()
        }
        
        if let loadedGroceries = CategoriesAndGroceries.loadFromGroceryFile() {
                print("Found file! Loading friends!")
                groceries = loadedGroceries
            } else {
                print("No Groceries 😢 Making some up")
                groceries = CategoriesAndGroceries.loadSampleGroceryData()
            }
        
        if let loadedCategories = CategoriesAndGroceries.loadFromCategoryFile() {
                print("Found file! Loading friends!")
                categories = loadedCategories
            } else {
                print("No Categories 😢 Making some up")
                categories = CategoriesAndGroceries.loadSampleCategoryData()
            }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwind", sender: nil)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        /*
         if let nameTextField = nameTextField.text {
         if let selectedGrocery = selectedGrocery {
         if let selectedCategory = selectedCategory {
         if let existingStockNumber = existingStockNumber.text {
         if (Int(existingStockNumber) != nil) {
         if arrayOfItems != nil {
         
         arrayOfItems.append(Grocery(name: nameTextField, grocery: selectedGrocery, existingStock: Int(existingStockNumber) ?? 0, alerts: true, expiryDate: nil, groceryCat: selectedCategory))
         
         let encoder = JSONEncoder()
         if let encoded = try? encoder.encode(arrayOfItems) {
         UserDefaults.standard.set(encoded, forKey: "ArrayOfItems")
         
         print("works")
         
         }
         
         print("hello?")
         
         performSegue(withIdentifier: "unwind", sender: nil)
         }
         } else {
         let alert = UIAlertController(title: "Empty Fields", message: "Please check you have filled every fields", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "NTUC", style: .default, handler: { (_) in }))
         }
         }
         }
         }
         }
         */
        print("Button is pressed")
        
        
        if let nameTextField = nameTextField.text, let selectedGrocery = selectedGrocery, let existingStockNumber = existingStockNumber.text, let selectedCategory = selectedCategory{
            
            if let existingStockInt = Int(existingStockNumber) {
                arrayOfItems.append(Grocery(name: nameTextField, grocery: selectedGrocery, existingStock: existingStockInt, alerts: false, expiryDate: nil, groceryCat: selectedCategory, imageOfItem: nil, ID: Grocery.generateUUID(), isAlert: false))
                
                Grocery.saveToFile(groceries: arrayOfItems)
                
                print("if statement passed")
                performSegue(withIdentifier: "unwind", sender: nil)
            } else {
                
                let alert = UIAlertController(title: "Invalid Field", message: "This should only be an easter egg cause im using the number keypad", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in }))
        
                self.present(alert, animated: true) {
                    print("Ok Pressed")
                }
                
                print("if statement failed")
            }
            
        } else {
            
            let alert = UIAlertController(title: "Empty Fields", message: "Please check you have filled every field", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in }))
    
            self.present(alert, animated: true) {
                print("Ok Pressed")
            }
            
            print("if statement failed")
        }
        
        if let nameTextField = nameTextField.text {
            print("\nname: \(nameTextField)")
        } else {
            print("name failed")
        }
        
        if let selectedGrocery = selectedGrocery {
            print("grocery: \(selectedGrocery)")
        } else {
            print("grocery failed")
        }
        
        if let existingStock = existingStockNumber.text {
            if let existingStock = Int(existingStock) {
                print("existingStock: \(existingStock)")
            } else {
                print("Stock failed")
            }
        } else {
            print("Stock failed")
        }
        
        if let selectedCategory = selectedCategory {
            print("groceryCategory: \(selectedCategory)\n")
        }  else {
            print("category failed")
        }
    }
    
    @IBAction func groceryButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Preset Grocery", message: "Please Select an Grocery", preferredStyle: .actionSheet)
        
        for i in 0...(groceries.count - 1) {
            alert.addAction(UIAlertAction(title: groceries[i], style: .default, handler: { (_) in
                self.presetButton.setTitle(self.groceries[i], for: .normal)
                self.selectedGrocery = self.groceries[i]
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func categoryButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Category", message: "Please Select an Category", preferredStyle: .actionSheet)
        
        for i in 0...(categories.count - 1) {
            alert.addAction(UIAlertAction(title: categories[i], style: .default, handler: { (_) in
                self.categoryButton.setTitle(self.categories[i], for: .normal)
                self.selectedCategory = self.categories[i]
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
