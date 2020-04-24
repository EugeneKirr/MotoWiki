//
//  BikeList.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 29/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BikeList {
    
    static var content: [Bike] = [
        Bike(bikeImage: UIImage(named: "Aprilia Tuono"), bikeBrand: "Aprilia", bikeName: "Tuono"),
        Bike(bikeImage: UIImage(named: "BMW RnineT"), bikeBrand: "BMW", bikeName: "RnineT"),
        Bike(bikeImage: UIImage(named: "BMW S1000RR"), bikeBrand: "BMW", bikeName: "S1000RR"),
        Bike(bikeImage: UIImage(named: "Ducati Panigale V4"), bikeBrand: "Ducati", bikeName: "Panigale V4"),
        Bike(bikeImage: UIImage(named: "Triumph Street Triple RS"), bikeBrand: "Triumph", bikeName: "Street Triple RS")
    ]
    
    static func getBikes(for brandOfInterest: Brand) -> [Bike] {
        var chosenBikes = [Bike]()
        for bike in BikeList.content {
//            guard bike.propertyValues[0] == brandOfInterest.propertyValues[0] else { continue }
//            chosenBikes.append(bike)
        }
        return chosenBikes
    }
    
    static func remove(_ deletedBike: Bike) {
        for index in 0...(BikeList.content.count - 1) {
            guard BikeList.content[index] === deletedBike else { continue }
            BikeList.content.remove(at: index)
            break
        }
    }
    
    static func sortByName() {
        BikeList.content.sort { (firstBike: Bike, secondBike: Bike) -> Bool in
            return firstBike.propertyValues[1] < secondBike.propertyValues[1]
        }
    }
    
    static func getIndex(for bike: Bike) -> Int {
        var bikeIndex = -1
        for index in 0...(BikeList.content.count - 1) {
            guard BikeList.content[index] === bike else { continue }
            bikeIndex = index
            break
        }
        return bikeIndex
    }
    
}
