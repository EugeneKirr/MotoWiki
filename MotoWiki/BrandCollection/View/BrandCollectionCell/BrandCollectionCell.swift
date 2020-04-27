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

}

extension BrandCollectionCell {
    
    func loadView(brand: Brand) {
        brandImageView.image = brand.image
    }
    
}
