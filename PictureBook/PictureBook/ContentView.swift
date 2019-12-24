//
//  ContentView.swift
//  PictureBook
//
//  Created by Ma Xueyuan on 2019/12/23.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var names = [String]()
    @State private var uiImageDic = Dictionary<String, UIImage>()
    @State private var uiImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingSaveImageView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(names, id: \.self) { name in
                    NavigationLink(destination: DetailView(name: name, uiImageDic: self.uiImageDic)) {
                        Image(uiImage: self.uiImageDic[name]!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        Text(name)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("Pokemon Index")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingImagePicker = true
            }, label: {
                Text("Add")
                .sheet(isPresented: $showingImagePicker, onDismiss: afterPickingImage) {
                    ImagePicker(image: self.$uiImage)
                }
            }))
                .onAppear(perform: loadData)
                .sheet(isPresented: $showingSaveImageView, onDismiss: afterSavingImage) {
                    SaveImageView(names: self.$names, uiImageDic: self.$uiImageDic, uiImage: self.$uiImage)
            }
        }
    }
    
    func loadData() {
        // load names
        if let names: [String] = FileManager.default.loadJson(from: "names.json") {
            self.names = names
        }
        
        // load images
        var dic = Dictionary<String, UIImage>()
        for name in names {
            if let image = FileManager.default.loadImage(from: "\(name).dat") {
                dic[name] = image
            }
        }
        uiImageDic = dic
    }
    
    func afterPickingImage() {
        if uiImage == nil {
            return
        }
        
        showingSaveImageView = true
    }
    
    func afterSavingImage() {
        uiImage = nil
    }
    
    func delete(indexSet: IndexSet) {
        for index in indexSet {
            // delete stored image
            FileManager.default.deleteData("\(names[index]).dat")
        }
        
        // update saved names
        names.remove(atOffsets: indexSet)
        FileManager.default.saveJson(names, to: "names.json")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
