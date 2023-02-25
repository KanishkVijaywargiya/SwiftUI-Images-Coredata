//
//  FileManager+Extension.swift
//  ImagesCoreData
//
//  Created by Kanishk Vijaywargiya on 25/02/23.
//

import UIKit

enum FileType: String, CaseIterable {
    case JPG = "jpg"
    case JPEG = "jpeg"
    case PNG = "png"
}

extension FileManager {
    /// - Retrieve image from file manager
    func retrieveImage(with id: String) -> UIImage? {
        guard let validURL = getURL(with: id) else { return nil }
        do {
            let imageData = try Data(contentsOf: validURL)
            return UIImage(data: imageData)
        } catch {
            print("Error in retrieving image 🔴", error.localizedDescription)
            return nil
        }
    }
    
    /// - save image to file manager
    func saveImage(with id: String, image: UIImage) {
        let extn = imageFormat(image)
        guard let data = extn.1 else {
            print("Could not able to save image ⚠️")
            return
        }
        
        do {
            let url = URL.documentsDirectory.appendingPathComponent("\(id).\(extn.0)")
            try data.write(to: url)
        } catch {
            print("Error in saving image 🔴", error.localizedDescription)
        }
    }
    
    /// - delete image from file manager
    func deleteImage(with id: String) {
        guard let validURL = getURL(with: id) else {
            print("Image does not exists ⚠️")
            return
        }
        do {
            try removeItem(at: validURL)
        } catch {
            print("Error in removing item 🔴", error.localizedDescription)
        }
    }
}


/// - supporting functions
extension FileManager {
    private func getURL(with id: String) -> URL? {
        var fileTypesValues: [String] = []
        FileType.allCases.forEach { caseVal in
            fileTypesValues.append(caseVal.rawValue)
        }
        
        let documentsDir = URL.documentsDirectory
        let url = fileTypesValues.compactMap({documentsDir.appendingPathComponent("\(id).\($0)")})
            .first(where: {fileExists(atPath: $0.path())})
        
        return url
    }
    
    
    func imageFormat(_ image: UIImage) -> (String, Data?) {
        var imageData: Data?
        var fileExtension: String = FileType.JPG.rawValue
        
        if let pngData = image.pngData() {
            imageData = pngData
            fileExtension = FileType.PNG.rawValue
        } else if let jpegData = image.jpegData(compressionQuality: 0.6) {
            imageData = jpegData
            fileExtension = FileType.JPG.rawValue
        }
        
        return (fileExtension, imageData)
    }
}

