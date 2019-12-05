//
//  FilterType.swift
//  CoreDataProject
//
//  Created by Ma Xueyuan on 2019/12/06.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import Foundation

enum FilterType: String {
    case beginsWith = "%K BEGINSWITH %@"
    case endsWith = "%K ENDSWITH %@"
    case contains = "%K CONTAINS %@"
}
