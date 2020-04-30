//
//  RealmObjectBrand.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 23/04/2020.
//Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class RealmObjectBrand: Object {
    
    dynamic var id = 0
    dynamic var imageName = ""
    dynamic var name = ""
    dynamic var origin = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

extension RealmObjectBrand {
    
    func getValues(from brand: Brand) {
        id = brand.id
        imageName = "\(brand.id).png"
        name = brand.propertyValues[0]
        origin = brand.propertyValues[1]
    }
    
    func getInitialValues() {
        id = 1
        imageName = "1.png"
        name = "Your Brand"
    }
    
}

