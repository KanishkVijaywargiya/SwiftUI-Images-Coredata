//
//  ImageFormView.swift
//  ImagesCoreData
//
//  Created by Kanishk Vijaywargiya on 31/01/23.
//

import SwiftUI

struct ImageFormView: View {
    @EnvironmentObject private var containerVM: ContainerViewModel
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var formVM: FormViewModel
    
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(uiImage: formVM.uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 400)
                TextField("Image Name", text: $formVM.name).textFieldStyle(.roundedBorder)
                
                HStack {
                    if formVM.isUpdating {
                        Button {
                            self.showPicker.toggle()
                        } label: {
                            Text("Update Image").font(.footnote.bold()).foregroundColor(.blue)
                        }
                        .padding(8)
                        .background(Color.blue.opacity(0.3))
                        .clipShape(Capsule())
                        .shadow(color: Color.blue.opacity(0.6), radius: 5, x: 0, y: 5)
                    }
                    
                    Button {
                        if formVM.isUpdating {
                            if let id = formVM.id,
                               let selectedObject = containerVM.imagesEntity.first(where: {$0.id == id}) {
                                selectedObject.name = formVM.name
                                FileManager().saveImage(with: id, image: formVM.uiImage)
                                containerVM.saveData()
                            }
                        } else {
                            containerVM.createNewObject(name: formVM.name, image: formVM.uiImage)
                        }
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .disabled(formVM.incomplete)
                }
                Spacer()
            }
            .padding()
            .navigationTitle(formVM.isUpdating ? "Update Image" : "New Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }
                if formVM.isUpdating {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            if let selectedObject = containerVM.imagesEntity.first(where: {$0.id == formVM.id}) {
                                FileManager().deleteImage(with: selectedObject.imageID)
                                containerVM.deleteObject(selectedObject)
                            }
                            dismiss()
                        } label: {
                            Image(systemName: "trash").foregroundColor(.red)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.3))
                    }
                }
            }
        }
        .cropImagePicker(
            options: [.circle, .rectangle, .square, .custom(.init(width: 200, height: 200))],
            show: $showPicker,
            croppedImage: $croppedImage)
        .onChange(of: croppedImage) { newImage in
            if let newImage {
                formVM.uiImage = newImage
            }
        }
    }
}

struct ImageFormView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.shared.container.viewContext
        ImageFormView(formVM: FormViewModel(UIImage(systemName: "photo")!))
            .environmentObject(ContainerViewModel(context: persistenceController))
    }
}
