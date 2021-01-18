//
//  ItemCollectionViewCell.swift
//  grocermi
//
//  Created by Joshua Lim on 9/1/21.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var yeetButton: UIButton!
    @IBOutlet weak var alertIcon: UIImageView!
    
    var data: Grocery?
    var arrayOfItems: [Grocery] = []
        
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        
        if let loadedGroceries = Grocery.loadFromFile(){
            if !loadedGroceries.isEmpty {
                arrayOfItems = loadedGroceries
            } else {
                arrayOfItems = Grocery.loadSampleData()
            }
        } else {
            arrayOfItems = Grocery.loadSampleData()
        }
        
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func plusPressed(_ sender: Any) {
        
        data?.existingStock += 1
        stockLabel.text = String(data!.existingStock)
        
        for i in 0...arrayOfItems.count - 1 {
            if arrayOfItems[i].ID == data!.ID {
                    arrayOfItems[i].existingStock = data!.existingStock
                    print("Stock Changed")
                
            }
        }
        
        Grocery.saveToFile(groceries: arrayOfItems)
    }
    
    @IBAction func minusPressed(_ sender: Any) {
                    
        
        
        if data!.existingStock > 0 {
        
            data?.existingStock -= 1
            stockLabel.text = String(data!.existingStock)
            
            for i in 0...arrayOfItems.count - 1 {
                if arrayOfItems[i].ID == data!.ID {
                    arrayOfItems[i].existingStock = data!.existingStock
                    print("Stock Changed")
                }
            }
        }

        
        Grocery.saveToFile(groceries: arrayOfItems)
        
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        CategoriesAndGroceries.saveToDetailFile(details: data!)
    }
    
}
