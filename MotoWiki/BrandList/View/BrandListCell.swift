//
//  BrandListCell.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BrandListCell: UITableViewCell {
    
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var brandOriginLabel: UILabel!
    
}

extension BrandListCell {
    
    func loadView(brand: Brand) {
        brandImage.image = brand.brandLogo
        brandNameLabel.text = "\(brand.propertyValues[0])"
        brandOriginLabel.text = "\(brand.propertyValues[1])"
    }
    
}
