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
    
    init(id: Int, imageName: String, name: String, origin: String) {
        self.id = id
        self.image = {
            let imagePath = FileManager.default.getImagePath(in: .brands, imageName: imageName)
            return UIImage(contentsOfFile: imagePath) ?? UIImage(named: "DefaultBrand")!
        }()
        self.propertyValues = {
            var values = [String]()
            values.append(contentsOf: [name, origin])
            return values
        }()
    }
    
}

