//
//  Outlet.swift
//  AutoSwitcher
//
//  Created by Marco Carmona on 7/21/23.
//

import Foundation
import HomeKit

struct Outlet: Identifiable, Codable {
    var id = UUID()

    let homeName: String
    let homeIdentifier: UUID
    
    let accessoryName: String
    let accessoryIdentifier: UUID
    let characteristicIdentifier: UUID
    
    init(home: HMHome, accessory: HMAccessory, characteristic: HMCharacteristic) {
        self.homeName = home.name
        self.homeIdentifier = home.uniqueIdentifier
        self.accessoryName = accessory.name
        self.accessoryIdentifier = accessory.uniqueIdentifier
        self.characteristicIdentifier = characteristic.uniqueIdentifier
    }
}
