//
//  Bike.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class Bike {
    
    var bikeImage: UIImage?
    let propertyLabels: [String] = ["Brand", "Name", "Class", "Engine type", "Tank capacity", "Dry weight"]
    var propertyValues: [String] = []
    
    init(bikeImage: UIImage?, bikeBrand: String, bikeName: String) {
        self.bikeImage = bikeImage
        self.propertyValues.append(contentsOf: [bikeBrand, bikeName])
        for _ in 3...propertyLabels.count {
            self.propertyValues.append("")
        }
    }

}

extension Bike {
    
    static let defaultBike = Bike(bikeImage: UIImage(named: "motorcycle"), bikeBrand: "", bikeName: "")
    
    static var propertyCounter: Int {
        return defaultBike.propertyLabels.count
    }
    
}
