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
    
    func fetchBrandListFromDB(sortBy: SortByProperty) -> BrandList {
        var fetchedBrands = [Brand]()
        realmManager.fetchFromDB { (brandObjects: Results<RealmObjectBrand>) in
            for object in brandObjects {
                let brand = Brand(id: object.id,
                                  imageName: object.imageName,
                                  name: object.name,
                                  origin: object.origin)
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
//        realmManager.printRealmURL()
        return BrandList(brands: fetchedBrands)
    }
    
    func performDBActionWith(_ brand: Brand, action: DBActions) {
        let realmObject = RealmObjectBrand()
        realmObject.id = brand.id
        realmObject.imageName = "\(brand.id).png"
        realmObject.name = brand.propertyValues[0]
        realmObject.origin = brand.propertyValues[1]
        switch action {
        case .addToDB: realmManager.addToDB(realmObject)
        case .deleteFromDB: realmManager.deleteFromDB(realmObject)
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
        let newID = (brandList.brands.last?.id ?? 0) + 1
        let updatedBrand = Brand(id: newID, image: brand.image, propertyValues: brand.propertyValues)
        return updatedBrand
    }
    
    func updateBrandImage(brand: Brand, _ newImage: UIImage) -> Brand {
        return Brand(id: brand.id, image: newImage, propertyValues: brand.propertyValues)
    }
 
}
