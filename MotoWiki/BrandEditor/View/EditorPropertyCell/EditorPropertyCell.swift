//
//  EditorPropertyCell.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 22/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class EditorPropertyCell: UITableViewCell {
    
    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var propertyValueTextField: UITextField!
    
}

extension EditorPropertyCell {
    
    func loadView(_ propertyName: String, _ propertyValue: String) {
        propertyNameLabel.text = propertyName
        propertyValueTextField.text = propertyValue
        propertyValueTextField.autocapitalizationType = .words
    }
    
}
