//
//  FMPaths.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum FMPaths {
    case brands
    case bikes
}

extension FMPaths {
    
    var folderSubpath: String {
        switch self {
        case .brands: return "Images/Brands"
        case .bikes: return "Images/Bikes"
        }
    }
    
}
