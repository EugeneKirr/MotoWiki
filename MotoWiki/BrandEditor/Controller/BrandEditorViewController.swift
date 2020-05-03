//
//  BrandEditorViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BrandEditorViewController: UITableViewController {
    
    private let brandManager = BrandManager()
    
    var editableBrand = Brand()
    
    private var selectedCellIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(title: "Edit Brand Details") {
            let navSaveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.tapSaveButton))
            self.navigationItem.rightBarButtonItem = navSaveButton
        }
        registerCells([.editorImageCell, .editorPropertyCell])
        guard editableBrand.id == 0 else { return }
        editableBrand = brandManager.updateBrandWithNewID(editableBrand)
    }
    
    // MARK: - Navigation bar action
    
    @objc func tapSaveButton() {
        guard editableBrand.propertyValues[0] != "" else { showEmptyNameAlert(); return }
        brandManager.performDBActionWith(editableBrand, action: .addToDB)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editableBrand.propertyLabels.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorImageCell.cellIdentifier, for: indexPath) as? EditorImageCell else { return UITableViewCell() }
            cell.cellImageView.image = editableBrand.image
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorPropertyCell.cellIdentifier, for: indexPath) as? EditorPropertyCell else { return UITableViewCell() }
            
            let propertyName = editableBrand.propertyLabels[indexPath.row - 1]
            let propertyLabel = editableBrand.propertyValues[indexPath.row - 1]
            cell.loadView(propertyName, propertyLabel)
            cell.propertyValueTextField.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return calculateRowHeight(occupiedFractionOfTableHeight: 0.33)
        default: return calculateRowHeight(occupiedFractionOfTableHeight: 0.125)
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        switch indexPath.row {
        case 0: showPhotoSourceActionSheet()
        default: return
        }
    }
    
}

// MARK: - UITextField Delegate

extension BrandEditorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let tfContentView = textField.superview,
              let tfCell = tfContentView.superview as? EditorPropertyCell,
              let cellIndex = tableView.indexPath(for: tfCell) else { return }
        selectedCellIndex = (cellIndex.row - 1)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editableBrand = brandManager.updateBrandProperty(brand: editableBrand, forIndex: selectedCellIndex, byValue: textField.text ?? "")
    }

}

//MARK: -  UIImagePicker Delegate

extension BrandEditorViewController {
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        super.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        guard let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditorImageCell,
              let newImage = info[.editedImage] as? UIImage else { return }
        imageCell.cellImageView.image = newImage
        imageCell.cellImageView.contentMode = .scaleAspectFit
        editableBrand = brandManager.updateBrandImage(brand: editableBrand, newImage)
    }
    
}


