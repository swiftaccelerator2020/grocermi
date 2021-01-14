//
//  AddObjectViewController.swift
//  grocermi
//
//  Created by Joshua Lim on 8/12/20.
//

import UIKit

class AddObjectFromHomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var existingStockNumber: UITextField!
    @IBOutlet weak var presetButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var alertsSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var imageChosen: String?
    
    var arrayOfItems: [Grocery] = []

    var categories: [String] = []
    var groceries: [String] = []
    
    var selectedGrocery: String?
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
        
        if let loadedGroceries = Grocery.loadFromFile() {
                print("Found file! Loading friends!")
                arrayOfItems = loadedGroceries
            } else {
                print("No Groceries 😢 Making some up")
                arrayOfItems = Grocery.loadSampleData()
                print("sample data is \(Grocery.loadSampleData())")
            }

        print(arrayOfItems)
        
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
    
    @IBAction func imagePressed(_ sender: Any) {
        print("imaged pressed")
        
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true,
                             completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwind", sender: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.originalImage] as? UIImage else { return }
        
        let generatedName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(generatedName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        dismiss(animated: true)
        
        imageView.image = UIImage(contentsOfFile: imagePath.path)
        
        print("contents of file: \(imagePath.path)")
        
        imageChosen = imagePath.path
        
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        
        if let nameTextField = nameTextField.text, let selectedGrocery = selectedGrocery, let existingStockNumber = existingStockNumber.text, let selectedCategory = selectedCategory {
            
            if let existingStockInt = Int(existingStockNumber) {
                if let imageLocation = imageChosen {
                    arrayOfItems.append(Grocery(name: nameTextField, grocery: selectedGrocery, existingStock: existingStockInt, alerts: alertsSwitch.isOn, expiryDate: datePicker.date, groceryCat: selectedCategory, imageOfItem: imageLocation, ID: Grocery.generateUUID(), isAlert: false))
                        
                    Grocery.saveToFile(groceries: arrayOfItems)
                    print("Saved to with custom image")
                } else {
                    arrayOfItems.append(Grocery(name: nameTextField, grocery: selectedGrocery, existingStock: existingStockInt, alerts: alertsSwitch.isOn, expiryDate: datePicker.date, groceryCat: selectedCategory, imageOfItem: nil, ID: Grocery.generateUUID(), isAlert: false))
                    
                    Grocery.saveToFile(groceries: arrayOfItems)
                    print("Saved to without custom image")
                }
                    
                print("if statement passed")
                performSegue(withIdentifier: "unwind", sender: nil)
            } else {
                
                let alert = UIAlertController(title: "Empty Fields", message: "Please check you have filled every field", preferredStyle: .alert)
                
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
