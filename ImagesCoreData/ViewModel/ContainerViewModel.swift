//
//  ContainerViewModel.swift
//  ImagesCoreData
//
//  Created by Kanishk Vijaywargiya on 31/01/23.
//

import SwiftUI
import CoreData

class ContainerViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    @Published var imagesEntity: [MyImage] = []
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchData()
    }
}

extension ContainerViewModel {
    /// - fetching data from files directory & coredata
    private func fetchData() {
        let request: NSFetchRequest<MyImage> = MyImage.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MyImage.name, ascending: true)]
        
        do {
            imagesEntity = try viewContext.fetch(request)
        } catch let error {
            print("Error fetching categories. \(error.localizedDescription)🔴")
        }
    }
    
    
    func saveData() {
        if viewContext.hasChanges {
            try? viewContext.save()
            fetchData()
        }
    }
    
    
    func createNewObject(name: String, image: UIImage) {
        let newImage = MyImage(context: viewContext)
        newImage.id = UUID().uuidString
        newImage.name = name
        saveData()
        FileManager().saveImage(with: newImage.imageID, image: image)
    }
    
    
    func deleteObject(_ selectedObject: MyImage) {
        viewContext.delete(selectedObject)
        saveData()
    }
}
