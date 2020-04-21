//
//  BikeEditorCell.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BikeEditorCell: UITableViewCell {
    
    @IBOutlet weak var bikePropertyLabel: UILabel!
    @IBOutlet weak var bikePropertyText: UITextField!
    
}

extension BikeEditorCell {
    
    func loadView(bike: Bike, index: Int) {
        bikePropertyLabel.text = bike.propertyLabels[index] + ":"
        bikePropertyText.text = bike.propertyValues[index]
    }
    
}
