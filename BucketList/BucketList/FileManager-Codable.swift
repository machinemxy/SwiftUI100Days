//
//  FileManager-Codable.swift
//  BucketList
//
//  Created by Ma Xueyuan on 2019/12/14.
//  Copyright © 2019 Ma Xueyuan. All rights reserved.
//

import Foundation

extension FileManager {
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func load<T: Codable>(from file: String) -> T {
        let url = getDocumentsDirectory().appendingPathComponent(file)

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file).")
        }
        
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file).")
        }
        
        return loaded
    }
    
    func save<T: Codable>(_ t: T, to file: String) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(t) else {
            fatalError("Encoding failed.")
        }
        
        let url = getDocumentsDirectory().appendingPathComponent(file)
        do {
            try encoded.write(to: url, options: .atomic)
        } catch {
            fatalError("Failed to write \(file).")
        }
    }
}
