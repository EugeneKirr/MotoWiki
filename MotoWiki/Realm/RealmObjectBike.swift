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
    dynamic var imageName = ""
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
