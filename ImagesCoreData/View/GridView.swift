//
//  ContentView.swift
//  ImagesCoreData
//
//  Created by Kanishk Vijaywargiya on 31/01/23.
//

import SwiftUI

struct GridView: View {
    @EnvironmentObject private var containerVM: ContainerViewModel
    
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    @State private var formType: FormType?
    
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        NavigationStack {
            Group {
                if !containerVM.imagesEntity.isEmpty {
                    ScrollView {
                        LazyVGrid (columns: columns, spacing: 20) {
                            ForEach(containerVM.imagesEntity) { myImage in
                                Button {
                                    formType = .update(myImage)
                                } label: {
                                    VStack {
                                        Image(uiImage: myImage.uiimage)
                                            .resizable().scaledToFill()
                                            .frame(width: 100, height: 100).clipped()
                                            .shadow(radius: 5)
                                        
                                        Text(myImage.nameView)
                                    }
                                }
                                
                            }
                        }
                    }.padding()
                } else {
                    Text("Select your first image!")
                }
            }
            .navigationTitle("My Images 🌅")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showPicker.toggle()
                    } label: {
                        Text("New Image").font(.footnote.bold()).foregroundColor(.blue)
                    }
                    .padding(8)
                    .background(Color.blue.opacity(0.3))
                    .clipShape(Capsule())
                    .shadow(color: Color.blue.opacity(0.6), radius: 5, x: 0, y: 5)
                }
            }
            .cropImagePicker(
                options: [.circle, .rectangle, .square, .custom(.init(width: 200, height: 200))],
                show: $showPicker,
                croppedImage: $croppedImage)
            .onChange(of: croppedImage) { newImage in
                if let newImage {
                    formType = .new(newImage)
                }
            }
            .sheet(item: $formType) { $0 }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.shared.container.viewContext
        GridView()
            .environmentObject(ContainerViewModel(context: persistenceController))
    }
}
