//
//  BrandEditorViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

protocol BrandEditorViewControllerDelegate: AnyObject {
    func saveChanges(_ savedBrand: Brand)
}

class BrandEditorViewController: UITableViewController {
    
    unowned var editableBrand = Brand.defaultBrand
    
    private var savedBrand = Brand(brandLogo: nil, brandName: "", countryOfOrigin: "")
    
    weak var delegate: BrandEditorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(title: "Edit Brand Info") {
            let navSaveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.tapSaveButton))
            self.navigationItem.rightBarButtonItem = navSaveButton
        }
        registerCells([.editorImageCell, .editorPropertyCell])
        
        savedBrand.brandLogo = editableBrand.brandLogo
        savedBrand.propertyValues = editableBrand.propertyValues
    }
    
    // MARK: - Navigation bar action
    
    @objc func tapSaveButton() {
        guard savedBrand.propertyValues[0] != "" else { showEmptyNameAlert(); return }
        delegate?.saveChanges(savedBrand)
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
        return (Brand.propertyCounter + 1)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorImageCell.cellIdentifier, for: indexPath) as? EditorImageCell else { return UITableViewCell() }
            cell.cellImageView.image = editableBrand.brandLogo
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorPropertyCell.cellIdentifier, for: indexPath) as? EditorPropertyCell else { return UITableViewCell() }
            //todo cell.loadView()
            cell.propertyValueTextField.delegate = self
            cell.propertyValueTextField.tag = (indexPath.row - 1)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 200
        default: return 85
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
        savedBrand.propertyValues[textField.tag] = textField.text ?? "-"
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
        guard let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditorImageCell else { return }
//        imageCell.brandImage.image = info[.editedImage] as? UIImage
//        imageCell.brandImage.contentMode = .scaleAspectFill
        
//        savedBrand.brandLogo = imageCell.brandImage.image
        dismiss(animated: true)
    }
}


