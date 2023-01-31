//
//  FormType.swift
//  ImagesCoreData
//
//  Created by Kanishk Vijaywargiya on 31/01/23.
//

import SwiftUI

enum FormType: Identifiable, View {
    case new(UIImage)
    case update(MyImage)
    
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }
    
    var body: some View {
        switch self {
        case .new(let uiImage):
            return ImageFormView(formVM: FormViewModel(uiImage))
        case .update(let myImage):
            return ImageFormView(formVM: FormViewModel(myImage))
        }
    }
}

