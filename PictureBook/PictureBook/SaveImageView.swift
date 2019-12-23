//
//  SaveImageView.swift
//  PictureBook
//
//  Created by Ma Xueyuan on 2019/12/23.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct SaveImageView: View {
    var names: [String]
    @Binding var uiImage: UIImage?
    @State var name = ""
    
    var body: some View {
        VStack {
            Image(uiImage: uiImage!)
                .resizable()
                .scaledToFit()
            
            TextField("Input a name for the picture", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                print("save")
            }) {
                Text("Save")
                    .font(.title)
            }
        }
        
    }
}

struct SaveImageView_Previews: PreviewProvider {
    static var previews: some View {
        SaveImageView(names: ["a", "b"], uiImage: .constant(UIImage(named: "sample")))
    }
}
