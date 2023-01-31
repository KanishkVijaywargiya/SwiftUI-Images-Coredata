//
//  MyImagesContainer.swift
//  ImagesCoreData
//
//  Created by Kanishk Vijaywargiya on 31/01/23.
//

import SwiftUI
import CoreData

/// - Setting up the persistence class
class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyImagesDataModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Error loading core data: \(error), \(error.userInfo), \(error.localizedDescription) 🔴")
                return
            } else {
                print("Successfully loaded Container Core Data ✅")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
