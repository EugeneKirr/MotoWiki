//
//  BrandManager.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 23/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation
import RealmSwift

class BrandManager {
    
    private let realmManager = RealmManager()
    
    init() {
        addInitialBrandToDB()
    }
    
    func addInitialBrandToDB() {
        let defaults = UserDefaults.standard
        guard defaults.object(forKey: UDKeys.initialBrand.key) == nil else { return }
        let initialRealmBrand = RealmObjectBrand()
        initialRealmBrand.getInitialValues()
        realmManager.addToDB(initialRealmBrand)
        defaults.set(true, forKey: UDKeys.initialBrand.key)
    }
    
    enum SortByProperty {
        case id
        case name
        case origin
    }
    
    func fetchBrandListFromDB(sortBy: SortByProperty) -> [Brand] {
        var fetchedBrands = [Brand]()
        realmManager.fetchFromDB { (brandObjects: Results<RealmObjectBrand>) in
            for object in brandObjects {
                let brand = Brand(object)
                fetchedBrands.append(brand)
            }
        }
        fetchedBrands.sort { (firstBrand, secondBrand) -> Bool in
            switch sortBy {
            case .id: return firstBrand.id < secondBrand.id
            case .name: return firstBrand.propertyValues[0] < secondBrand.propertyValues[0]
            case .origin: return firstBrand.propertyValues[1] < secondBrand.propertyValues[1]
            }
        }
        return fetchedBrands
    }
    
    func performDBActionWith(_ brand: Brand, action: DBActions) {
        let realmObject = RealmObjectBrand()
        realmObject.getValues(from: brand)
        switch action {
        case .addToDB:
            FileManager.default.createNewImageFile(in: .brands, image: brand.image, imageName: realmObject.imageName)
            realmManager.addToDB(realmObject)
        case .deleteFromDB:
            realmManager.fetchFromDB { (bikeObjects: Results<RealmObjectBike>) in
                for bikeObject in bikeObjects {
                    guard bikeObject.brandID == brand.id else { continue }
                    FileManager.default.deleteImageFile(in: .bikes, imageName: bikeObject.imageName)
                    realmManager.deleteFromDB(bikeObject)
                }
            }
            FileManager.default.deleteImageFile(in: .brands, imageName: realmObject.imageName)
            realmManager.deleteFromDB(realmObject)
        }
    }
    
}

extension BrandManager {
    
    func updateBrandProperty(brand: Brand, forIndex propertyIndex: Int, byValue propertyValue: String) -> Brand {
        var updatedPropertyValues = brand.propertyValues
        updatedPropertyValues[propertyIndex] = propertyValue
        let updatedBrand = Brand(id: brand.id, image: brand.image, propertyValues: updatedPropertyValues)
        return updatedBrand
    }
    
    func updateBrandWithNewID(_ brand: Brand) -> Brand {
        let brandList = fetchBrandListFromDB(sortBy: .id)
        let newID = (brandList.last?.id ?? 0) + 1
        let updatedBrand = Brand(id: newID, image: brand.image, propertyValues: brand.propertyValues)
        return updatedBrand
    }
    
    func updateBrandImage(brand: Brand, _ newImage: UIImage) -> Brand {
        return Brand(id: brand.id, image: newImage, propertyValues: brand.propertyValues)
    }
 
}
