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
    @State private var uiImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingSaveImageView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(names, id: \.self) { name in
                    Text(name)
                }
            }
            .navigationBarTitle("Picture Book")
            .navigationBarItems(trailing: Button(action: {
                self.showingImagePicker = true
            }, label: {
                Text("Add")
                .sheet(isPresented: $showingImagePicker, onDismiss: afterPickingImage) {
                    ImagePicker(image: self.$uiImage)
                }
            }))
            .onAppear(perform: loadData)
                .sheet(isPresented: $showingSaveImageView) {
                    SaveImageView(names: self.names, uiImage: self.$uiImage)
            }
        }
    }
    
    func loadData() {
        names = ["A", "B"]
    }
    
    func afterPickingImage() {
        if uiImage == nil {
            return
        }
        
        showingSaveImageView = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
