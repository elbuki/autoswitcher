//
//  ContentView.swift
//  AutoSwitcher
//
//  Created by Marco Carmona on 7/6/23.
//

import SwiftUI

struct ContentView: View {
    @Binding var pickedOutlet: Outlet?
    @ObservedObject var model: HomeStore
    let saveAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Select your preferred outlet")
            
            List {
                ForEach(model.availableOutlets, id: \.id) { outlet in
                    HStack {
                        Text(outlet.accessoryName)
                        
                        if let pickedOutlet, isSameOutlet(pickedOutlet, outlet) {
                            Spacer()
                            
                            Image(systemName: "checkmark")
                        }
                    }
                    .onTapGesture {
                        selectPreferredOutlet(outlet: outlet)
                    }
                }
            }
        }
        .padding()
    }
    
    private func isSameOutlet(_ a: Outlet, _ b: Outlet) -> Bool {
        return a.accessoryIdentifier == b.accessoryIdentifier
    }
    
    private func selectPreferredOutlet(outlet: Outlet) {
        pickedOutlet = outlet
        saveAction()
    }
}
