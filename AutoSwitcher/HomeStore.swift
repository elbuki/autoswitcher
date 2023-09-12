//
//  HomeStore.swift
//  HomeKitTest
//
//  Created by Marco Carmona on 6/22/23.
//

import HomeKit

class HomeStore: NSObject, ObservableObject, HMHomeManagerDelegate {
    
    @Published var availableOutlets: [Outlet] = []
    @Published var availableCharacteristics: [HMCharacteristic] = []
    
    let outletDescription = "Outlet"
    let powerStateDescription = "Power State"
    
    private var manager: HMHomeManager!
    
    override init() {
        super.init()
        
        if manager == nil {
            manager = .init()
            manager.delegate = self
        }
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        loadAvailableOutlets(homes: manager.homes)
    }
    
    func setPowerState(for characteristicIdentifier: UUID, to state: Bool) async throws {
        let task = Task<_, Error> {
            var found: HMCharacteristic?

            for characteristic in availableCharacteristics {
                if characteristic.uniqueIdentifier != characteristicIdentifier {
                    continue
                }
                
                if characteristic.localizedDescription != powerStateDescription {
                    continue
                }
                
                found = characteristic
                break
            }
            
            if let found {
                try await found.readValue()
                
                if let currentState = found.value as? Bool, currentState != state {
                    setCharacteristicValue(characteristic: found, value: state)
                }
            }
        }

        _ = try await task.value
    }
    
    private func setCharacteristicValue(characteristic: HMCharacteristic, value: Any) {
        characteristic.writeValue(value) { _ in
            print("Changing characteristic \(characteristic.uniqueIdentifier) value to: \(value)")
        }
    }
    
    private func loadAvailableOutlets(homes: [HMHome]) {
        var found: [Outlet] = []
        var characteristics: [HMCharacteristic] = []

        for home in homes {
            var outlet: Outlet
            
            for accessory in home.accessories {
                for service in accessory.services {
                    if service.localizedDescription != outletDescription {
                        continue
                    }
                    
                    for characteristic in service.characteristics {
                        if characteristic.localizedDescription != powerStateDescription {
                            continue
                        }
                        
                        outlet = Outlet(
                            home: home,
                            accessory: accessory,
                            characteristic: characteristic
                        )

                        found.append(outlet)
                        characteristics.append(characteristic)
                    }
                }
            }
        }
        
        availableOutlets = found
        availableCharacteristics = characteristics
    }

}
