//
//  ProjectViewControllers.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 22/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum ProjectViewControllers: String {
    
    case brandListVC
    case brandCollectionVC
    case brandEditorVC
    case bikeListVC
    case bikeEditorVC
    case bikeViewerVC
    
}

extension ProjectViewControllers {
    
    var storyboardName: String {
        switch self {
        case .brandListVC: return "BrandList"
        case .brandCollectionVC: return "BrandCollection"
        case .brandEditorVC: return "BrandEditor"
        case .bikeListVC: return "BikeList"
        case .bikeEditorVC: return "BikeEditor"
        case .bikeViewerVC: return "BikeViewer"
        }
    }
    
    var vcIdentifier: String {
        switch self {
        case .brandListVC: return "brandListVC"
        case .brandCollectionVC: return "brandCollectionVC"
        case .brandEditorVC: return "brandEditorVC"
        case .bikeListVC: return "bikeListVC"
        case .bikeEditorVC: return "bikeEditorVC"
        case .bikeViewerVC: return "bikeViewerVC"
        }
    }
    
}


