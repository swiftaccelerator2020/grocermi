//
//  SelectionTableViewController.swift
//  grocermi
//
//  Created by Joshua Lim on 10/12/20.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var arrayOfItems:[Grocery] = []
    
    @IBAction func stepperStepped(_ sender: Any) {
        numberLabel.text = "\(Int(stepper.value))"
        for i in 0...arrayOfItems.count - 1 {
            if arrayOfItems[i].name == titleLabel.text! {
                arrayOfItems[i].existingStock = Int(stepper.value)
            }
        }
        
        Grocery.saveToFile(groceries: arrayOfItems)
    }
    
    override func didMoveToSuperview() {
        if let loadedGroceries = Grocery.loadFromFile() {
            arrayOfItems = loadedGroceries
        } else {
            arrayOfItems = Grocery.loadSampleData()
        }
    }
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}

class SelectionTableViewController: UITableViewController {

    var selectedCategory = ""
    var names: [String] = []
    var arrayOfItems: [Grocery] = []
    var values: [Int] = []
    
    var noStuff = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = selectedCategory
        
        if let loadedGroceries = Grocery.loadFromFile() {
                print("Found file! Loading friends!")
                arrayOfItems = loadedGroceries
            } else {
                print("No Groceries 😢 Making some up")
                arrayOfItems = Grocery.loadSampleData()
                print("sample data is \(Grocery.loadSampleData())")
            }

        print(arrayOfItems)
    }
    
    override func viewDidAppear(_ animated: Bool) {
            
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
        
        Grocery.saveToFile(groceries: arrayOfItems)
        
        for i in 1...arrayOfItems.count {
            if arrayOfItems[i - 1].groceryCat == selectedCategory && arrayOfItems[i - 1].isAlert == true {
                names.append(arrayOfItems[i - 1].name)
                values.append(arrayOfItems[i - 1].existingStock)
            }
        }
        
        if names.count == 0 {
            noStuff = true
        }
        
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        /*
        for i in 1...names.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath(row: i, section: 0)) as! SelectionTableViewCell
            
            print("stepper value on disappear is \(cell.stepper.value)")
            
            if values[i - 1] != Int(cell.stepper.value) {
                values[i - 1] = Int(cell.stepper.value)
                print("value changed to \(Int(cell.stepper.value))")
            }
        }
        */
        /*
        for i in 0...arrayOfItems.count - 1 {
            for o in 0...names.count - 1 {
                if names[o] == arrayOfItems[i].name {
                    arrayOfItems[i].existingStock = values[o]
                    
                    print("Changed \(arrayOfItems[i].name) value to \(values[o])")
                    
                    break
                }
            }
        }
        
        Grocery.saveToFile(groceries: arrayOfItems)
        
        print("function ran")
        */
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if noStuff == true {
            return 1
        } else {
            return names.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectionTableViewCell

        // Configure the cell...
        
        
        if noStuff {
            cell.titleLabel.text = "No Items Found"
            cell.numberLabel.isHidden = true
            cell.stepper.isHidden = true
        } else {
            cell.stepper.value = Double(values[indexPath.row])
            cell.titleLabel?.text = names[indexPath.row]
            cell.numberLabel?.text = "\(Int(cell.stepper.value))"
            print("Stepper Value on Start is \(cell.stepper.value)")
        }
        
        return cell
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
