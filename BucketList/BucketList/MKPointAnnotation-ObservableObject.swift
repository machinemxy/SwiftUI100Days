//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Ma Xueyuan on 2019/12/18.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import Foundation
import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }

        set {
            title = newValue
        }
    }

    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }

        set {
            subtitle = newValue
        }
    }
}
