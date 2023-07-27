//
//  AutoSwitcherApp.swift
//  AutoSwitcher
//
//  Created by Marco Carmona on 7/6/23.
//

import SwiftUI

@main
struct AutoSwitcherApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var storageManager = StorageManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                pickedOutlet: $storageManager.outlet,
                model: .init(),
                saveAction: {
                    Task {
                        do {
                            if let outlet = storageManager.outlet {
                                try await storageManager.save(data: outlet)
                            }
                        } catch {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
            )
                .task {
                    do {
                        try await storageManager.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
        }
    }
}
