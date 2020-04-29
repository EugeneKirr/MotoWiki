//
//  BikeListCell.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BikeListCell: UITableViewCell {

    @IBOutlet weak var bikeImageView: UIImageView!
    @IBOutlet weak var bikeNameLabel: UILabel!
    @IBOutlet weak var yearOfProductionLabel: UILabel!
}

extension BikeListCell {
    
    func loadView(bike: Bike) {
        bikeImageView.image = bike.image
        bikeNameLabel.text = bike.propertyValues[2]
        yearOfProductionLabel.text = bike.propertyValues[4]
    }
    
}
