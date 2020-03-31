//
//  Purpose.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum Purpose {
    case sportbike
    case naked
    case classic
    case cruiser
    case tourer
    case adventurer
}
 
extension Purpose {
    var purposeText: String {
        switch self {
        case .adventurer: return "Adventure Bike"
        case .classic:    return "Classic Bike"
        case .cruiser:    return "Cruiser"
        case .naked:      return "Naked Bike"
        case .sportbike:  return "Sportbike"
        case .tourer:     return "Tourer"
        }
    }
}

