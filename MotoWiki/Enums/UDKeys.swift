//
//  UDKeys.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 22/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum UDKeys {
    case initialVC
    case initialBrand
    case initialBike
}


extension UDKeys {
    
    var key: String {
        switch self {
        case .initialVC: return "Initial ViewController"
        case .initialBrand: return "Initial Brand"
        case .initialBike: return "Initial Bike"
        }
    }
    
}

