//
//  Bike.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

struct Bike {
    
    let id: Int
    let brandID: Int
    let image: UIImage
    let propertyLabels: [String] = ["Brand Name", "Country of Origin", "Name", "Type", "Year of Production", "Horse Power, hp", "Torque, Nm", "Engine Type", "Engine Dispacement, cc", "Maximum Speed, km/h", "0-100 Acceleration, sec", "Tank Capacity, l", "Fuel Consumption, l/100 km", "Dry Weight, kg", "Curb Weight, kg", "Seat Height, mm"]
    let propertyValues: [String]

}

extension Bike {
    
    init(_ brand: Brand, _ realmBike: RealmObjectBike) {
        self.id = realmBike.id
        self.brandID = brand.id
        self.image = {
            let imagePath = FileManager.default.getImagePath(in: .bikes, imageName: realmBike.imageName)
            return UIImage(contentsOfFile: imagePath) ?? UIImage(named: "DefaultBike")!
        }()
        self.propertyValues = {
            var values = [String]()
            values.append(contentsOf: [brand.propertyValues[0], brand.propertyValues[1]])
            values.append(contentsOf: [realmBike.name, realmBike.bikeType, "\(realmBike.yearOfProduction)", "\(realmBike.horsePower)", "\(realmBike.torque)", realmBike.engineType, "\(realmBike.engineDispacement)", "\(realmBike.maximumSpeed)", "\(realmBike.acceleration)", "\(realmBike.tankCapacity)", "\(realmBike.fuelConsumption)", "\(realmBike.dryWeight)", "\(realmBike.curbWeight)", "\(realmBike.seatHeight)"])
            for index in 0...(values.count - 1) {
                guard values[index] == "0" || values[index] == "0.0" else { continue }
                values[index] = ""
            }
            return values
        }()
    }
    
}

// init empty Bike: bike = Bike(Brand())
extension Bike {
    
    init(_ brand: Brand) {
        self.id = 0
        self.brandID = brand.id
        self.image = UIImage(named: "DefaultBike")!
        self.propertyValues = {
            var values = [String]()
            values.append(contentsOf: [brand.propertyValues[0], brand.propertyValues[1]])
            values.append(contentsOf: [String](repeating: "", count: 14))
            return values
        }()
    }
    
}

