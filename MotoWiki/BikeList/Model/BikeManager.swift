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
    
    init() {
        addInitialBikeToDB()
    }
    
    func addInitialBikeToDB() {
        let defaults = UserDefaults.standard
        guard defaults.object(forKey: UDKeys.initialBike.key) == nil else { return }
        let initialRealmBike = RealmObjectBike()
        initialRealmBike.getInitialValues()
        realmManager.addToDB(initialRealmBike)
        defaults.set(true, forKey: UDKeys.initialBike.key)
    }
    
    enum SortByProperty {
        case id
        case name
        case year
    }
    
    func fetchBikeListFromDB(with brand: Brand? = nil, sortBy: SortByProperty) -> [Bike] {
        var fetchedBikes = [Bike]()
        realmManager.fetchFromDB { (bikeObjects: Results<RealmObjectBike>) in
            if let brand = brand {
                for object in bikeObjects {
                    guard object.brandID == brand.id else { continue }
                    let bike = Bike(brand, object)
                    fetchedBikes.append(bike)
                }
            } else {
                for bikeObject in bikeObjects {
                    realmManager.fetchFromDB { (brandObjects: Results<RealmObjectBrand>) in
                        for brandObject in brandObjects {
                            guard brandObject.id == bikeObject.brandID else { continue }
                            let brand = Brand(brandObject)
                            let bike = Bike(brand, bikeObject)
                            fetchedBikes.append(bike)
                        }
                    }
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
        return fetchedBikes
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
        realmObject.getValues(from: bike)
        switch action {
        case .addToDB:
            FileManager.default.createNewImageFile(in: .bikes, image: bike.image, imageName: realmObject.imageName)
            realmManager.addToDB(realmObject)
        case .deleteFromDB:
            FileManager.default.deleteImageFile(in: .bikes, imageName: realmObject.imageName)
            realmManager.deleteFromDB(realmObject)
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
        let newID = (bikeList.last?.id ?? 0) + 1
        let updatedBike = Bike(id: newID, brandID: bike.brandID, image: bike.image, propertyValues: bike.propertyValues)
        return updatedBike
    }
    
    func updateBikeImage(bike: Bike, _ newImage: UIImage) -> Bike {
        return Bike(id: bike.id, brandID: bike.brandID, image: newImage, propertyValues: bike.propertyValues)
    }
 
}
