//
//  BrandCollectionCell.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 22/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

protocol BrandCellButtonActionsDelegate: AnyObject {

    func deleteButtonAction(_ cell: BrandCollectionCell)
    func editButtonAction(_ cell: BrandCollectionCell)

}

class BrandCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    weak var delegate: BrandCellButtonActionsDelegate?
    
    var isInEditMode = false {
        didSet {
            switch isInEditMode {
            case true:
                brandImageView.alpha = 0.3
                deleteButton.alpha = 1.0
                editButton.alpha = 1.0
            case false:
                brandImageView.alpha = 1.0
                deleteButton.alpha = 0.0
                editButton.alpha = 0.0
            }
        }
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        delegate?.deleteButtonAction(self)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        delegate?.editButtonAction(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isInEditMode = false
        addLongPressGesture(duration: 1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isInEditMode = false
    }

}

extension BrandCollectionCell {
    
    func loadView(brand: Brand) {
        brandImageView.image = brand.image    
    }
    
}

extension BrandCollectionCell {
    
    func addLongPressGesture(duration: TimeInterval) {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(enableEditMode(sender:)))
        longPress.minimumPressDuration = duration
        addGestureRecognizer(longPress)
    }
    
    @objc func enableEditMode(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            setEditMode(true)
        }
    }
    
    func setEditMode(_ value: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.isInEditMode = value
        }
    }
    
}
