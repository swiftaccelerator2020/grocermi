//
//  DetailsViewController.swift
//  grocermi
//
//  Created by Joshua Lim on 8/12/20.
//

import UIKit

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var alertSwitch: UISwitch!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var expiryDatePicker: UIDatePicker!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var groceryButton: UIButton!
    
    var arrayOfItems: [Grocery] = []
    var categories: [String] = []
    var groceries: [String] = []
    var details: Grocery?
    
    var selectedGrocery: String?
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        
        if let loadedData = CategoriesAndGroceries.loadFromDetailFile() {
            details = loadedData
        }
        
        if let details = details {
            
            self.title = details.name
            nameTextField.text = details.name
            stockTextField.text = String(details.existingStock)
            if let imageOfItem = details.imageOfItem {
                imageView.image = UIImage(named: imageOfItem)
            }
            if let alerts = details.alerts {
                alertSwitch.isOn = alerts
            } else {
                alertSwitch.isOn = false
            }
            categoryButton.setTitle(details.groceryCat, for: .normal)
            groceryButton.setTitle(details.grocery, for: .normal)
        
        }
        
        if let loadedGroceries = Grocery.loadFromFile(){
            arrayOfItems = loadedGroceries
        } else {
            arrayOfItems = Grocery.loadSampleData()
        }
        
        if let loadedGroceries = CategoriesAndGroceries.loadFromGroceryFile(){
            groceries = loadedGroceries
        } else {
            groceries = CategoriesAndGroceries.loadSampleGroceryData()
        }
        
        if let loadedCategories = CategoriesAndGroceries.loadFromCategoryFile(){
            categories = loadedCategories
        } else {
            categories = CategoriesAndGroceries.loadSampleCategoryData()
        }
        
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are You Sure?", message: "This item will be permanently Deleted", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .destructive, handler: { action in
            if let loadedData = CategoriesAndGroceries.loadFromDetailFile() {
                for i in 0...self.arrayOfItems.count - 1 {
                    if self.arrayOfItems[i].ID == loadedData.ID {
                        self.arrayOfItems.remove(at: i)
                            break
                        }
                    }
                }
            
            Grocery.saveToFile(groceries: self.arrayOfItems)
            self.performSegue(withIdentifier: "unwind", sender: nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        nameTextField.delegate = self
        stockTextField.delegate = self
        nameTextField.tag = 1
        stockTextField.tag = 2
        
        setupToolbar()
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupToolbar(){
        //Create a toolbar
        let bar = UIToolbar()
        
        //Create a done button with an action to trigger our function to dismiss the keyboard
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        
        //Create a felxible space item so that we can add it around in toolbar to position our done button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //Add the created button items in the toobar
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        
        //Add the toolbar to our textfield
        stockTextField.inputAccessoryView = bar
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            //Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes → then move the cursor to that next text-field. If No → Dismiss the keyboard
            if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            return false
        }
    
    @IBAction func groceryButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Preset Grocery", message: "Please Select an Grocery", preferredStyle: .actionSheet)
        
        for i in 0...(groceries.count - 1) {
            alert.addAction(UIAlertAction(title: groceries[i], style: .default, handler: { (_) in
                self.groceryButton.setTitle(self.groceries[i], for: .normal)
                self.selectedGrocery = self.groceries[i]
                
                for i in 0...self.arrayOfItems.count - 1 {
                    if self.arrayOfItems[i].ID == self.details!.ID {
                        self.arrayOfItems[i].grocery = self.selectedGrocery!
                        Grocery.saveToFile(groceries: self.arrayOfItems)
                        break
                    }
                }
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
                
                for i in 0...self.arrayOfItems.count - 1 {
                    if self.arrayOfItems[i].ID == self.details!.ID {
                        self.arrayOfItems[i].groceryCat = self.selectedCategory!
                        Grocery.saveToFile(groceries: self.arrayOfItems)
                        break
                    }
                }

            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func nameEditingEnd(_ sender: Any) {
        for i in 0...arrayOfItems.count - 1 {
            if arrayOfItems[i].ID == details!.ID {
                if let name = nameTextField.text {
                    arrayOfItems[i].name = name
                }
                Grocery.saveToFile(groceries: arrayOfItems)
                break
            }
        }
    }
    
    @IBAction func stockEditingEnd(_ sender: Any) {
        for i in 0...arrayOfItems.count - 1 {
            if arrayOfItems[i].ID == details!.ID {
                if let stock = stockTextField.text {
                    arrayOfItems[i].existingStock = Int(stock)!
                }
                Grocery.saveToFile(groceries: arrayOfItems)
                break
            }
        }
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        for i in 0...arrayOfItems.count - 1 {
            if arrayOfItems[i].ID == details!.ID {
                arrayOfItems[i].expiryDate = expiryDatePicker.date
                Grocery.saveToFile(groceries: arrayOfItems)
                break
            }
        }
    }
    
    @IBAction func alertChanged(_ sender: Any) {
        for i in 0...arrayOfItems.count - 1 {
            if arrayOfItems[i].ID == details!.ID {
                    arrayOfItems[i].alerts = alertSwitch.isOn
                Grocery.saveToFile(groceries: arrayOfItems)
                break
            }
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
        
        for i in 0...arrayOfItems.count - 1 {
            if arrayOfItems[i].ID == details!.ID {
                arrayOfItems[i].imageOfItem = imagePath.path
                Grocery.saveToFile(groceries: arrayOfItems)
                break
            }
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
