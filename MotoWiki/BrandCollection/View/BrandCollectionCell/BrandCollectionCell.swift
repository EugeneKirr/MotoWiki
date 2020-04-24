//
//  BrandCollectionCell.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 22/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BrandCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!

}

extension BrandCollectionCell {
    
    func loadView(brand: Brand) {
        brandNameLabel.text = brand.brandName
        brandImageView.image = UIImage(named: brand.brandImageName)
    }
    
}
