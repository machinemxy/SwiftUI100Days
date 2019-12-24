//
//  DetailView.swift
//  PictureBook
//
//  Created by Ma Xueyuan on 2019/12/24.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var name: String
    var uiImageDic: Dictionary<String, UIImage>
    
    var body: some View {
        VStack {
            Image(uiImage: uiImageDic[name]!)
                .resizable()
                .scaledToFit()
        }
        .navigationBarTitle(Text(name), displayMode: .inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(name: "sample", uiImageDic: ["sample": UIImage(named: "sample")!])
    }
}
