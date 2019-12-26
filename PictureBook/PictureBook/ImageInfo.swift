//
//  ImageInfo.swift
//  PictureBook
//
//  Created by Ma Xueyuan on 2019/12/27.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import Foundation

struct ImageInfo: Codable, Identifiable {
    var name: String
    var latitude: Double
    var longitude: Double
    var id: String {
        return name
    }
}
