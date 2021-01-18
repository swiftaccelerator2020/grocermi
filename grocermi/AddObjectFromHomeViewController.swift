//
//  AddObjectViewController.swift
//  grocermi
//
//  Created by Joshua Lim on 8/12/20.
//

import UIKit

class AddObjectFromHomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        imageView.isUserInteractionEnabled = true
        
        nameTextField.delegate = self
        existingStockNumber.delegate = self
        
        // Do any additional setup after loading the view.
        
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
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
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
        
        if !groceries.isEmpty {
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
        } else {
            let otherAlert = UIAlertController(title: "No Grocery Found", message: "Go to preferences to add groceries", preferredStyle: .alert)
            otherAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in }))
            self.present(otherAlert, animated: true, completion: {})
        }
    }
    
    @IBAction func categoryButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Category", message: "Please Select an Category", preferredStyle: .actionSheet)
        
        if !categories.isEmpty {
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
        } else {
            let otherAlert = UIAlertController(title: "No Categories Found", message: "Go to preferences to add categories", preferredStyle: .alert)
            otherAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in }))
            self.present(otherAlert, animated: true, completion: {})
        }
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
