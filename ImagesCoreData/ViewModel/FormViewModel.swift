//
//  FormViewModel.swift
//  ImagesCoreData
//
//  Created by Kanishk Vijaywargiya on 31/01/23.
//

import SwiftUI

class FormViewModel: ObservableObject {
    /// - when we r creating a new object we don't have the id but when we r updating we do have one
    var id: String?
    var isUpdating: Bool { id != nil } /// - to check if we r updating when id is not nil
    
    @Published var name = "" /// - use for text field
    @Published var uiImage: UIImage /// - UiImage, we r creating a new one or updating an existing one
    
    /// - for adding new image
    init(_ uiImage: UIImage) {
        self.uiImage = uiImage
    }
    
    /// - for updating, so whole object a core data entity
    init(_ myImage: MyImage) {
        id = myImage.imageID
        name = myImage.nameView
        uiImage = UIImage(systemName: "photo")!
    }
    
    var incomplete: Bool {
        name.isEmpty || uiImage == UIImage(systemName: "photo")!
    } /// - not allowing any saving or updating if name field is empty or if UIImage is placeholder image
}
