//
//  SaveImageView.swift
//  PictureBook
//
//  Created by Ma Xueyuan on 2019/12/23.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct SaveImageView: View {
    @Binding var imageInfos: [ImageInfo]
    @Binding var uiImageDic: Dictionary<String, UIImage>
    @Binding var uiImage: UIImage?
    @State private var name = ""
    @State private var message = ""
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    // something to get your location
    let locationFetcher = LocationFetcher()
    
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
            .onAppear(perform: startTrackingLocation)
        }
    }
    
    func save() {
        if name == "" {
            message = "Please enter a name for the image."
            showingAlert = true
            return
        }
        
        if imageInfos.contains(where: { $0.name == name }) {
            message = "There is still a image with this name. Please enter a different name."
            showingAlert = true
            return
        }
        
        //get location
        if let location = locationFetcher.lastKnownLocation {
            imageInfos.append(ImageInfo(name: name, latitude: location.latitude, longitude: location.longitude))
        } else {
            imageInfos.append(ImageInfo(name: name, latitude: 0, longitude: 0))
        }
        
        // save imageInfos
        FileManager.default.saveJson(imageInfos, to: "imageInfos.json")
        
        // save image
        FileManager.default.saveImage(uiImage!, to: "\(name).dat")
        
        // update dic
        if let loadedImage = FileManager.default.loadImage(from: "\(name).dat") {
            uiImageDic[name] = loadedImage
        }
        
        // dismiss
        presentationMode.wrappedValue.dismiss()
    }
    
    func startTrackingLocation() {
        locationFetcher.start()
    }
}

struct SaveImageView_Previews: PreviewProvider {
    static var previews: some View {
        SaveImageView(imageInfos: .constant([ImageInfo(name: "sample", latitude: 0, longitude: 0)]), uiImageDic: .constant(["sample": UIImage(named: "sample")!]), uiImage: .constant(UIImage(named: "sample")))
    }
}
