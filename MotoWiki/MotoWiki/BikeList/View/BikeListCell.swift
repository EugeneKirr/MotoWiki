//
//  BikeListCell.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BikeListCell: UITableViewCell {

    @IBOutlet weak var bikeImage: UIImageView!
    @IBOutlet weak var bikeName: UILabel!

}

extension BikeListCell {
    
    func loadView(bike: Bike) {
        bikeImage.image = bike.bikeImage
        bikeName.text = "\(bike.propertyValues[0]) \(bike.propertyValues[1])"
    }
    
}
