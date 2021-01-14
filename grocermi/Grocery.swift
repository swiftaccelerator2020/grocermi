//
//  grocery.swift
//  grocermi
//
//  Created by Joshua Lim on 11/12/20.
//

import Foundation
import UIKit

class Grocery: Codable  {
    
    var name: String
    var grocery: String
    var existingStock: Int
    var alerts: Bool?
    var expiryDate: Date?
    var groceryCat: String
    var imageOfItem: String?
    var ID: String
    var isAlert: Bool
    
    init(name: String, grocery: String, existingStock: Int, alerts: Bool?, expiryDate: Date?, groceryCat: String, imageOfItem: String?, ID: String, isAlert: Bool) {
        self.name = name
        self.grocery = grocery
        self.existingStock = existingStock
        self.alerts = alerts
        self.expiryDate = expiryDate
        self.groceryCat = groceryCat
        self.imageOfItem = imageOfItem
        self.ID = ID
        self.isAlert = isAlert
    }
    
    
    
    static func loadSampleData() -> [Grocery]{
        
        let sampleGroceries = [Grocery(name: "Test", grocery: "NTUC", existingStock: 10, alerts: false, expiryDate: nil, groceryCat: "Dairy", imageOfItem: nil, ID: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F", isAlert: false)]
        
        return sampleGroceries
    }
    
    static func generateUUID() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    static func getArchiveURL() -> URL {
        let plistName = "groceries"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("loaction? \(documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist"))")
        return documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist")
    }

    static func saveToFile(groceries: [Grocery]) {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedGroceries = try? propertyListEncoder.encode(groceries)
        try? encodedGroceries?.write(to: archiveURL, options: .noFileProtection)
    }

    static func loadFromFile() -> [Grocery]? {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedGroceriesData = try? Data(contentsOf: archiveURL) else { return nil }
        guard let decodedGroceries = try? propertyListDecoder.decode(Array<Grocery>.self, from: retrievedGroceriesData) else { return nil }
        return decodedGroceries
    }

}

