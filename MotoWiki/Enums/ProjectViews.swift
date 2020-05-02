//
//  ProjectViews.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 22/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

enum ProjectViews {
    
    case brandListCell
    case brandCollectionCell
    case bikeListCell
    case editorImageCell
    case editorPropertyCell
    case editorGalleryCell
    case galleryCollectionCell
    
}

extension ProjectViews {
    
    var xibName: String {
        switch self {
        case .brandListCell: return "BrandListCell"
        case .brandCollectionCell: return "BrandCollectionCell"
        case .bikeListCell: return "BikeListCell"
        case .editorImageCell: return "EditorImageCell"
        case .editorPropertyCell: return "EditorPropertyCell"
        case .editorGalleryCell: return "EditorGalleryCell"
        case .galleryCollectionCell: return "GalleryCollectionCell"
        }
    }
    
    var cellIdentifier: String {
        switch self {
        case .brandListCell: return "brandListCell"
        case .brandCollectionCell: return "brandCollectionCell"
        case .bikeListCell: return "bikeListCell"
        case .editorImageCell: return "editorImageCell"
        case .editorPropertyCell: return "editorPropertyCell"
        case .editorGalleryCell: return "editorGalleryCell"
        case .galleryCollectionCell: return "galleryCollectionCell"
        }
    }
    
    var superclassDescription: String {
        switch self {
        case .brandListCell, .bikeListCell, .editorImageCell, .editorPropertyCell, .editorGalleryCell: return "UITableViewCell"
        case .brandCollectionCell, .galleryCollectionCell: return "UICollectionViewCell"
        }
    }
    
}
