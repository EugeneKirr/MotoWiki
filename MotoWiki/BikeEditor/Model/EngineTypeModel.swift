//
//  EngineType.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum EngineType {
    case singleCylinder
    case parallelTwin
    case oppositeTwin
    case vTwin
    case inlineTriple
    case inlineFour
    case vFour
    case inlineSix
}
 
extension EngineType {
    var engineTypeText: String {
        switch self {
        case .singleCylinder: return "Signle Cylinder"
        case .parallelTwin:   return "Parallel Twin"
        case .oppositeTwin:   return "Opposite Twin"
        case .vTwin:          return "V-Twin"
        case .inlineTriple:   return "Inline Triple"
        case .inlineFour:     return "Inline Four"
        case .vFour:          return "V-Four"
        case .inlineSix:      return "Inline Six"
        }
    }
}
