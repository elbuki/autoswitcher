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

    @ObservedObject private var model = HomeStore()
    @StateObject private var storageManager = StorageManager()
    
    init() {
        self.model = _appDelegate.wrappedValue.model
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                pickedOutlet: $storageManager.outlet,
                model: model,
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
