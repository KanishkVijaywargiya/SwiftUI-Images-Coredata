//
//  ImagesCoreDataApp.swift
//  ImagesCoreData
//
//  Created by Kanishk Vijaywargiya on 31/01/23.
//

import SwiftUI

@main
struct ImagesCoreDataApp: App {
    let persistenceController = PersistenceController.shared.container.viewContext
    
    var body: some Scene {
        WindowGroup {
            GridView()
                .environmentObject(ContainerViewModel(context: persistenceController))
                .onAppear {
                    print(URL.documentsDirectory.path(percentEncoded: true))
                }
        }
    }
}
