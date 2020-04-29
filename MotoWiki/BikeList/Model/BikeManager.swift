//
//  BikeManager.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 28/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation
import RealmSwift

class BikeManager {
    
    private let realmManager = RealmManager()
    
    enum SortByProperty {
        case id
        case name
        case year
    }
    
    func fetchBikeListFromDB(with brand: Brand? = nil, sortBy: SortByProperty) -> BikeList {
        var fetchedBikes = [Bike]()
        realmManager.fetchFromDB { (bikeObjects: Results<RealmObjectBike>) in
            if let brand = brand {
                for object in bikeObjects {
                    guard object.brandID == brand.id else { continue }
                    let bike = Bike(brand, object)
                    fetchedBikes.append(bike)
                }
            } else {
                for object in bikeObjects {
                    let bike = Bike(Brand(), object)
                    fetchedBikes.append(bike)
                }
            }
        }
        fetchedBikes.sort { (firstBike, secondBike) -> Bool in
            switch sortBy {
            case .id: return firstBike.id < secondBike.id
            case .name: return firstBike.propertyValues[2] < secondBike.propertyValues[2]
            case .year: return firstBike.propertyValues[4] < secondBike.propertyValues[4]
            }
        }
        return BikeList(bikes: fetchedBikes)
    }
    
    func fetchBikeFromDB(with id: Int) -> Bike {
        var fetchedBike = Bike(Brand())
        realmManager.fetchFromDB { (bikeObjects: Results<RealmObjectBike>) in
            for bikeObject in bikeObjects {
                guard bikeObject.id == id else { continue }
                realmManager.fetchFromDB { (brandObjects: Results<RealmObjectBrand>) in
                    for brandObject in brandObjects {
                        guard brandObject.id == bikeObject.brandID else { continue }
                        let brand = Brand(brandObject)
                        fetchedBike = Bike(brand, bikeObject)
                    }
                }
            }
        }
        return fetchedBike
    }
    
    func performDBActionWith(_ bike: Bike, action: DBActions) {
        let realmObject = RealmObjectBike()
        realmObject.id = bike.id
        realmObject.brandID = bike.brandID
        realmObject.imageName = "\(bike.id).png"
        realmObject.name = bike.propertyValues[2]
        realmObject.bikeType = bike.propertyValues[3]
        realmObject.yearOfProduction = Int(bike.propertyValues[4]) ?? 0
        realmObject.horsePower = Int(bike.propertyValues[5]) ?? 0
        realmObject.torque = Int(bike.propertyValues[6]) ?? 0
        realmObject.engineType = bike.propertyValues[7]
        realmObject.engineDispacement = Int(bike.propertyValues[8]) ?? 0
        realmObject.maximumSpeed = Int(bike.propertyValues[9]) ?? 0
        realmObject.acceleration = Float(bike.propertyValues[10]) ?? 0.0
        realmObject.tankCapacity = Float(bike.propertyValues[11]) ?? 0.0
        realmObject.fuelConsumption = Float(bike.propertyValues[12]) ?? 0.0
        realmObject.dryWeight = Int(bike.propertyValues[13]) ?? 0
        realmObject.curbWeight = Int(bike.propertyValues[14]) ?? 0
        realmObject.seatHeight = Int(bike.propertyValues[15]) ?? 0
        switch action {
        case .addToDB: realmManager.addToDB(realmObject)
        case .deleteFromDB: realmManager.deleteFromDB(realmObject)
        }
    }
    
}

extension BikeManager {
    
    func updateBikeProperty(bike: Bike, forIndex propertyIndex: Int, byValue propertyValue: String) -> Bike {
        var updatedPropertyValues = bike.propertyValues
        updatedPropertyValues[propertyIndex] = propertyValue
        let updatedBike = Bike(id: bike.id, brandID: bike.brandID, image: bike.image, propertyValues: updatedPropertyValues)
        return updatedBike
    }
    
    func updateBikeWithNewID(_ bike: Bike) -> Bike {
        let bikeList = fetchBikeListFromDB(sortBy: .id)
        let newID = (bikeList.bikes.last?.id ?? 0) + 1
        let updatedBike = Bike(id: newID, brandID: bike.brandID, image: bike.image, propertyValues: bike.propertyValues)
        return updatedBike
    }
    
    func updateBikeImage(bike: Bike, _ newImage: UIImage) -> Bike {
        return Bike(id: bike.id, brandID: bike.brandID, image: newImage, propertyValues: bike.propertyValues)
    }
 
}
