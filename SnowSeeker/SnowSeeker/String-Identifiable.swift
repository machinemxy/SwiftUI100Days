//
//  String-Identifiable.swift
//  SnowSeeker
//
//  Created by Ma Xueyuan on 2020/01/06.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import Foundation

extension String: Identifiable {
    public var id: String { self }
}
