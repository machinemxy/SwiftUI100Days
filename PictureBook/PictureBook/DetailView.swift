//
//  DetailView.swift
//  PictureBook
//
//  Created by Ma Xueyuan on 2019/12/24.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var imageInfo: ImageInfo
    var uiImageDic: Dictionary<String, UIImage>
    
    var body: some View {
        VStack {
            Image(uiImage: uiImageDic[imageInfo.name]!)
                .resizable()
                .scaledToFit()
            MapView(imageInfo: imageInfo)
        }
        .navigationBarTitle(Text(imageInfo.name), displayMode: .inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(imageInfo: ImageInfo(name: "sample", latitude: 0, longitude: 0), uiImageDic: ["sample": UIImage(named: "sample")!])
    }
}
