//
//  GalleryCollectionCell.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 30/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

protocol CellButtonActionDelegate: AnyObject {
    
    func buttonAction(_ cell: UICollectionViewCell)
    
}

import UIKit

class GalleryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellActionButton: UIButton!
    
    weak var delegate: CellButtonActionDelegate?
    
    @IBAction func tapCellButton(_ sender: UIButton) {
        delegate?.buttonAction(self)
    }
    
}
