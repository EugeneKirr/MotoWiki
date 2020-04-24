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
    dynamic var brandImageName = ""
    dynamic var brandName = ""
    dynamic var brandOrigin = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

