//
//  BrandEditorCell.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BrandEditorCell: UITableViewCell { 
   
    @IBOutlet weak var brandPropertyLabel: UILabel!
    @IBOutlet weak var brandPropertyText: UITextField!
    
}

extension BrandEditorCell {
    
    func loadView(brand: Brand, index: Int) {
        brandPropertyLabel.text = brand.propertyLabels[index] + ":"
        brandPropertyText.text = brand.propertyValues[index]
    }
    
}
