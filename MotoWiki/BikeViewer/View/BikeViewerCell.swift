//
//  BikeViewerCell.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BikeViewerCell: UITableViewCell {
    
    @IBOutlet weak var bikePropertyLabel: UILabel!
    @IBOutlet weak var bikePropValueLabel: UILabel!
    
}

extension BikeViewerCell {
    
    func loadView(bike: Bike, index: Int) {
        bikePropertyLabel.text = bike.propertyLabels[index] + ":"
        bikePropValueLabel.text = bike.propertyValues[index]
    }
    
}
