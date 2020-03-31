//
//  Brand.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class Brand {
    
    var brandLogo: UIImage?
    let propertyLabels: [String] = ["Brand name", "Country of origin"]
    var propertyValues: [String] = []
    
    init(brandLogo: UIImage?, brandName: String, countryOfOrigin: String) {
        self.brandLogo = brandLogo
        self.propertyValues.append(contentsOf: [brandName, countryOfOrigin])
    }

}

extension Brand {
    
    static let defaultBrand = Brand(brandLogo: UIImage(named: "Default"), brandName: "", countryOfOrigin: "")
    
    static var propertyCounter: Int {
        return defaultBrand.propertyLabels.count
    }
    
}


