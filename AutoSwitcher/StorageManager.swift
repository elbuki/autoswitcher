//
//  StorageManager.swift
//  AutoSwitcher
//
//  Created by Marco Carmona on 7/21/23.
//

import Foundation
import SwiftUI

@MainActor
class StorageManager: ObservableObject {
    
    @Published var outlet: Outlet? = nil
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("outlet.data")
    }
    
    func load() async throws {
        let task = Task<Outlet?, Error> {
            let fileURL = try Self.fileURL()
            var parsed: Outlet
            
            guard let data = try? Data(contentsOf: fileURL) else {
                return nil
            }
            
            parsed = try JSONDecoder().decode(Outlet.self, from: data)
            
            return parsed
        }
        
        outlet = try await task.value
    }
    
    func save(data: Outlet) async throws {
        let task = Task {
            let encoded = try JSONEncoder().encode(data)
            let outfile = try Self.fileURL()

            try encoded.write(to: outfile)
        }
        
        try await task.value
    }
    
}
