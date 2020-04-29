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
    let image: UIImage
    let propertyLabels: [String] = ["Brand Name", "Country of Origin"]
    let propertyValues: [String]
}

extension Brand {
    
    init(_ realmBrand: RealmObjectBrand) {
        self.id = realmBrand.id
        self.image = {
            let imagePath = FileManager.default.getImagePath(in: .brands, imageName: realmBrand.imageName)
            return UIImage(contentsOfFile: imagePath) ?? UIImage(named: "DefaultBrand")!
        }()
        self.propertyValues = {
            var values = [String]()
            values.append(contentsOf: [realmBrand.name, realmBrand.origin])
            return values
        }()
    }
    
}

extension Brand {
    
    init() {
        self.id = 0
        self.image = UIImage(named: "DefaultBrand")!
        self.propertyValues = [String](repeating: "", count: 2)
    }
    
}

