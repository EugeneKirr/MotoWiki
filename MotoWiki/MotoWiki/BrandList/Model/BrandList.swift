//
//  BrandList.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BrandList {
    
    static var content: [Brand] = [
        Brand(brandLogo: UIImage(named: "Aprilia"), brandName: "Aprilia", countryOfOrigin: "Italy"),
        Brand(brandLogo: UIImage(named: "BMW"), brandName: "BMW", countryOfOrigin: "Germany"),
        Brand(brandLogo: UIImage(named: "Ducati"), brandName: "Ducati", countryOfOrigin: "Italy"),
        Brand(brandLogo: UIImage(named: "Triumph"), brandName: "Triumph", countryOfOrigin: "UK"),
        Brand(brandLogo: UIImage(named: "Yamaha"), brandName: "Yamaha", countryOfOrigin: "Japan")
    ]
    
    static func sortByName() {
        BrandList.content.sort { (firstBrand: Brand, secondBrand: Brand) -> Bool in
            return firstBrand.propertyValues[0] < secondBrand.propertyValues[0]
        }
    }
    
}


