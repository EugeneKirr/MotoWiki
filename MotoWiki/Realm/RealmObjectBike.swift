//
//  RealmObjectBike.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 28/04/2020.
//Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class RealmObjectBike: Object {
    
    dynamic var id = 0
    dynamic var brandID = 0
    let imageNames = List<String>()
    dynamic var name = ""
    dynamic var bikeType = ""
    dynamic var yearOfProduction = 0
    dynamic var horsePower = 0
    dynamic var torque = 0
    dynamic var engineType = ""
    dynamic var engineDispacement = 0
    dynamic var maximumSpeed = 0
    dynamic var acceleration: Float = 0.0
    dynamic var tankCapacity: Float = 0.0
    dynamic var fuelConsumption: Float = 0.0
    dynamic var dryWeight = 0
    dynamic var curbWeight = 0
    dynamic var seatHeight = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
     
}

extension RealmObjectBike {
    
    func getValues(from bike: Bike) {
        id = bike.id
        brandID = bike.brandID
        
        imageNames.removeAll()
        for index in 0...bike.images.count - 1 {
            imageNames.append("\(bike.id)_\(index).png")
        }
        
        name = bike.propertyValues[2]
        bikeType = bike.propertyValues[3]
        yearOfProduction = Int(bike.propertyValues[4]) ?? 0
        horsePower = Int(bike.propertyValues[5]) ?? 0
        torque = Int(bike.propertyValues[6]) ?? 0
        engineType = bike.propertyValues[7]
        engineDispacement = Int(bike.propertyValues[8]) ?? 0
        maximumSpeed = Int(bike.propertyValues[9]) ?? 0
        acceleration = Float(bike.propertyValues[10]) ?? 0.0
        tankCapacity = Float(bike.propertyValues[11]) ?? 0.0
        fuelConsumption = Float(bike.propertyValues[12]) ?? 0.0
        dryWeight = Int(bike.propertyValues[13]) ?? 0
        curbWeight = Int(bike.propertyValues[14]) ?? 0
        seatHeight = Int(bike.propertyValues[15]) ?? 0
    }
    
    func getInitialValues() {
        id = 1
        brandID = 1
        imageNames.append("1_0.png")
        name = "Your Bike"
    }
    
}
