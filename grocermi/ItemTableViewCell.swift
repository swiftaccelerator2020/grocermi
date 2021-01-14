//
//  ItemTableViewCell.swift
//  grocermi
//
//  Created by Joshua Lim on 9/1/21.
//

import UIKit

class ItemTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items: [Grocery] = []
    var arrayOfItems: [Grocery] = []
    var stockValue: Int?
    var cellsCount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let loadedGroceries = Grocery.loadFromFile(){
            arrayOfItems = loadedGroceries
        } else {
            arrayOfItems = Grocery.loadSampleData()
        }
        
        print(items)
        stockValue = arrayOfItems.count
        
        cellsCount = 0
        
        collectionView.reloadData()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellsCount = 0
        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCollectionViewCell
        
            print("items recieved are \(items)")
            
            if let imageLocation = items[indexPath.row].imageOfItem {
                    cell.imageView.image = UIImage(named: imageLocation)
                } else {
                    cell.imageView.image = UIImage(named: "tempImage")
                }
            
            cell.nameLabel.text = items[indexPath.row].name
            cell.stockLabel.text = "\(items[indexPath.row].existingStock)"
            
            cell.data = items[indexPath.row]
            
            if cellsCount < items.count {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    
                    print("oi RELOAD")
                }
                
                cellsCount += 1
            }
            
            if items[indexPath.row].isAlert == true {
                cell.alertIcon.isHidden = false
            } else {
                cell.alertIcon.isHidden = true
            }
        
        return cell
    }
    
    
}
