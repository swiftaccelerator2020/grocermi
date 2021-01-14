//
//  Storage.swift
//  grocermi
//
//  Created by Joshua Lim on 2/1/21.
//

import Foundation

class Storage {
    static func loadSampleData() -> [Grocery]{
        let sampleGroceries = [Grocery(name: "Test", grocery: "NTUC", existingStock: 10, alerts: false, expiryDate: nil, groceryCat: "Dairy")]
        
        return sampleGroceries
    }
    
    static func getArchiveURL() -> URL {
        let plistName = "groceries"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
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

