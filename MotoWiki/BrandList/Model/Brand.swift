//
//  Brand.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

struct Brand {
    
    let id: Int
    let brandImageName: String
    let brandName: String
    let brandOrigin: String
    
    let propertyLabels: [String] = ["Brand Image Name", "Brand Name", "Country of Origin"]
    let propertyValues: [String]
}

extension Brand {
    
    init(id: Int, brandImageName: String, brandName: String, brandOrigin: String) {
        self.id = id
        self.brandImageName = brandImageName
        self.brandName = brandName
        self.brandOrigin = brandOrigin
        self.propertyValues = {
            var values = [String]()
            values.append(contentsOf: [brandImageName, brandName, brandOrigin])
            return values
        }()
    }
    
}

extension Brand {
    
    init(id: Int, propertyValues: [String]) {
        self.id = id
        self.brandImageName = propertyValues[0]
        self.brandName = propertyValues[1]
        self.brandOrigin = propertyValues[2]
        self.propertyValues = propertyValues
    }
    
}
