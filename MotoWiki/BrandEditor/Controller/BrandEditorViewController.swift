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
    
    var editableBrand = Brand(id: 0, brandImageName: "Default", brandName: "", brandOrigin: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(title: "Edit Brand Info") {
            let navSaveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.tapSaveButton))
            self.navigationItem.rightBarButtonItem = navSaveButton
        }
        registerCells([.editorImageCell, .editorPropertyCell])
        guard editableBrand.id == 0 else { return }
        editableBrand = brandManager.updateBrandWithNewID(editableBrand)
        print(editableBrand.id)
    }
    
    // MARK: - Navigation bar action
    
    @objc func tapSaveButton() {
        guard editableBrand.brandName != "" else { showEmptyNameAlert(); return }
        brandManager.performDBActionWith(editableBrand, action: .addToDB)
        self.navigationController?.popViewController(animated: true)
    }
    
    func showEmptyNameAlert() {
        let ac = UIAlertController(title: "Can't save", message: "Brand name should be filled", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editableBrand.propertyLabels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorImageCell.cellIdentifier, for: indexPath) as? EditorImageCell else { return UITableViewCell() }
            cell.cellImageView.image = UIImage(named: editableBrand.brandImageName)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorPropertyCell.cellIdentifier, for: indexPath) as? EditorPropertyCell else { return UITableViewCell() }
            let propertyName = editableBrand.propertyLabels[indexPath.row]
            let propertyLabel = editableBrand.propertyValues[indexPath.row]
            cell.loadView(propertyName, propertyLabel)
            
            cell.propertyValueTextField.delegate = self
            cell.propertyValueTextField.tag = indexPath.row
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageCellHeight: CGFloat = (tableView.bounds.height / 3)
        let propertyCellHeight: CGFloat = (tableView.bounds.height - imageCellHeight) / 4
        switch indexPath.row {
        case 0: return imageCellHeight
        default: return propertyCellHeight
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        switch indexPath.row {
        case 0:
            let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let photo = UIAlertAction(title: "Photo gallery", style: .default) { (_) in
                self.showImagePicker(source: .photoLibrary)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(photo)
            ac.addAction(cancel)
            present(ac, animated: true)
        default: return
        }
    }
    
}

// MARK: - UITextField Delegate

extension BrandEditorViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editableBrand = brandManager.updateBrandProperty(brand: editableBrand, forIndex: textField.tag, byValue: textField.text ?? "")
    }

}

//MARK: -  UIImagePicker Delegate

extension BrandEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditorImageCell else { return }
//        imageCell.brandImage.image = info[.editedImage] as? UIImage
//        imageCell.brandImage.contentMode = .scaleAspectFill
        
//        savedBrand.brandLogo = imageCell.brandImage.image
        dismiss(animated: true)
    }
}


