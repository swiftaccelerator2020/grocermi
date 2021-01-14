//
//  Categories&Groceries.swift
//  grocermi
//
//  Created by Joshua Lim on 6/1/21.
//

import Foundation

class CategoriesAndGroceries: Codable {
    
    static func loadSampleGroceryData() -> [String]{
        
        let sampleGroceries = ["NTUC"]
        
        return sampleGroceries
    }
    
    static func getGroceryArchiveURL() -> URL {
        let plistName = "NameOfGroceries"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist")
    }

    static func saveToGroceryFile(groceries: [String]) {
        let archiveURL = getGroceryArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedGroceries = try? propertyListEncoder.encode(groceries)
        try? encodedGroceries?.write(to: archiveURL, options: .noFileProtection)
    }

    static func loadFromGroceryFile() -> [String]? {
        let archiveURL = getGroceryArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedGroceriesData = try? Data(contentsOf: archiveURL) else { return nil }
        guard let decodedGroceries = try? propertyListDecoder.decode(Array<String>.self, from: retrievedGroceriesData) else { return nil }
        return decodedGroceries
    }
    
    
    
    static func loadSampleCategoryData() -> [String]{
        
        let sampleCategories = ["Dairy"]
        
        return sampleCategories
    }
    
    static func getCategoryArchiveURL() -> URL {
        let plistName = "Categories"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist")
    }

    static func saveToCategoryFile(categories: [String]) {
        let archiveURL = getCategoryArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedCategories = try? propertyListEncoder.encode(categories)
        try? encodedCategories?.write(to: archiveURL, options: .noFileProtection)
    }

    static func loadFromCategoryFile() -> [String]? {
        let archiveURL = getCategoryArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedCategoriesData = try? Data(contentsOf: archiveURL) else { return nil }
        guard let decodedCategories = try? propertyListDecoder.decode(Array<String>.self, from: retrievedCategoriesData) else { return nil }
        return decodedCategories
    }
    
    static func getDetailsArchiveURL() -> URL {
        let plistName = "Details"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(plistName).appendingPathExtension("plist")
    }

    static func saveToDetailFile(details: Grocery) {
        let archiveURL = getCategoryArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedCategories = try? propertyListEncoder.encode(details)
        try? encodedCategories?.write(to: archiveURL, options: .noFileProtection)
    }

    static func loadFromDetailFile() -> Grocery? {
        let archiveURL = getCategoryArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedCategoriesData = try? Data(contentsOf: archiveURL) else { return nil }
        guard let decodedCategories = try? propertyListDecoder.decode(Grocery.self, from: retrievedCategoriesData) else { return nil }
        return decodedCategories
    }

}
