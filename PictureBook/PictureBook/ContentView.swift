//
//  ContentView.swift
//  PictureBook
//
//  Created by Ma Xueyuan on 2019/12/23.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var imageInfos = [ImageInfo]()
    @State private var uiImageDic = Dictionary<String, UIImage>()
    @State private var uiImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingSaveImageView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(imageInfos) { imageInfo in
                    NavigationLink(destination: DetailView(imageInfo: imageInfo, uiImageDic: self.uiImageDic)) {
                        Image(uiImage: self.uiImageDic[imageInfo.name]!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        Text(imageInfo.name)
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
                    SaveImageView(imageInfos: self.$imageInfos, uiImageDic: self.$uiImageDic, uiImage: self.$uiImage)
            }
        }
    }
    
    func loadData() {
        // load imageInfos
        if let imageInfos: [ImageInfo] = FileManager.default.loadJson(from: "imageInfos.json") {
            self.imageInfos = imageInfos
        }
        
        // load images
        var dic = Dictionary<String, UIImage>()
        for imageInfo in imageInfos {
            if let image = FileManager.default.loadImage(from: "\(imageInfo.name).dat") {
                dic[imageInfo.name] = image
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
            FileManager.default.deleteData("\(imageInfos[index].name).dat")
        }
        
        // update saved names
        imageInfos.remove(atOffsets: indexSet)
        FileManager.default.saveJson(imageInfos, to: "imageInfos.json")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
