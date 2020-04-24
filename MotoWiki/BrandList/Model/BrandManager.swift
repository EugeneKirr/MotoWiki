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
    
    private let defaultBrands: [Brand] = [
        Brand(id: 1, brandImageName: "Aprilia", brandName: "Aprilia", brandOrigin: "Italy"),
        Brand(id: 2, brandImageName: "BMW", brandName: "BMW", brandOrigin: "Germany"),
        Brand(id: 3, brandImageName: "Ducati", brandName: "Ducati", brandOrigin: "Italy"),
        Brand(id: 4, brandImageName: "Triumph", brandName: "Triumph", brandOrigin: "UK")
    ]
    
    func fetchDefaultBrandList() -> BrandList {
        return BrandList(brands: defaultBrands)
    }
    
}

extension BrandManager {
    
    func fetchBrandListFromDB(sortBy: SortByProperty) -> BrandList {
        var fetchedBrands = [Brand]()
        realmManager.fetchFromDB { (brandObjects: Results<RealmObjectBrand>) in
            for object in brandObjects {
                let brand = Brand(id: object.id,
                                  brandImageName: object.brandImageName,
                                  brandName: object.brandName,
                                  brandOrigin: object.brandOrigin)
                fetchedBrands.append(brand)
            }
        }
        fetchedBrands.sort { (firstBrand, secondBrand) -> Bool in
            switch sortBy {
            case .id: return firstBrand.id < secondBrand.id
            case .name: return firstBrand.brandName < secondBrand.brandName
            case .origin: return firstBrand.brandOrigin < secondBrand.brandOrigin
            }
            
        }
//        realmManager.printRealmURL()
        return BrandList(brands: fetchedBrands)
    }
    
    func performDBActionWith(_ brand: Brand, action: DBActions) {
        let realmObject = RealmObjectBrand()
        realmObject.id = brand.id
        realmObject.brandImageName = brand.brandImageName
        realmObject.brandName = brand.brandName
        realmObject.brandOrigin = brand.brandOrigin
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
        let updatedBrand = Brand(id: brand.id, propertyValues: updatedPropertyValues)
        return updatedBrand
    }
    
    func updateBrandWithNewID(_ brand: Brand) -> Brand {
        let brandList = fetchBrandListFromDB(sortBy: .id)
        let newID = (brandList.brands.last?.id ?? 0) + 1
        let updatedBrand = Brand(id: newID, propertyValues: brand.propertyValues)
        return updatedBrand
    }
 
}
