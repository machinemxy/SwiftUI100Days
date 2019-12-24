//
//  SaveImageView.swift
//  PictureBook
//
//  Created by Ma Xueyuan on 2019/12/23.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct SaveImageView: View {
    @Binding var names: [String]
    @Binding var uiImageDic: Dictionary<String, UIImage>
    @Binding var uiImage: UIImage?
    @State private var name = ""
    @State private var message = ""
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter a name for the image", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                if uiImage != nil {
                    Image(uiImage: uiImage!)
                        .resizable()
                        .scaledToFit()
                }
                
                Spacer()
            }
            .navigationBarTitle("Save Image", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.save()
            }, label: {
                Text("Save")
            }))
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("error"), message: Text(message), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func save() {
        if name == "" {
            message = "Please enter a name for the image."
            showingAlert = true
            return
        }
        
        if names.contains(name) {
            message = "There is still a image with this name. Please enter a different name."
            showingAlert = true
            return
        }
        
        // save names
        names.append(name)
        FileManager.default.saveJson(names, to: "names.json")
        
        // save image
        FileManager.default.saveImage(uiImage!, to: "\(name).dat")
        
        // update dic
        if let loadedImage = FileManager.default.loadImage(from: "\(name).dat") {
            uiImageDic[name] = loadedImage
        }
        
        // dismiss
        presentationMode.wrappedValue.dismiss()
    }
}

struct SaveImageView_Previews: PreviewProvider {
    static var previews: some View {
        SaveImageView(names: .constant(["sample"]), uiImageDic: .constant(["sample": UIImage(named: "sample")!]), uiImage: .constant(UIImage(named: "sample")))
    }
}
