//
//  HomeStore.swift
//  HomeKitTest
//
//  Created by Marco Carmona on 6/22/23.
//

import HomeKit

class HomeStore: NSObject, ObservableObject, HMHomeManagerDelegate {
    
    @Published var availableOutlets: [Outlet] = []
    
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
    
    private func loadAvailableOutlets(homes: [HMHome]) {
        var found: [Outlet] = []

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
                    }
                }
            }
        }
        
        availableOutlets = found
    }
    
}
