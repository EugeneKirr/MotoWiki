//
//  BikeEditorViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BikeEditorViewController: UITableViewController {
    
    private let bikeManager = BikeManager()
    
    var editableBike = Bike(Brand())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(title: "Edit Bike Info") {
            let navSaveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.tapSaveButton))
            self.navigationItem.rightBarButtonItem = navSaveButton
        }
        registerCells([.editorImageCell, .editorPropertyCell])
        guard editableBike.id == 0 else { return }
        editableBike = bikeManager.updateBikeWithNewID(editableBike)
    }
    
    // MARK: - Navigation bar action
    
    @objc func tapSaveButton() {
        guard editableBike.propertyValues[2] != "" else { showEmptyNameAlert(); return }

        bikeManager.performDBActionWith(editableBike, action: .addToDB)
        FileManager.default.createNewImageFile(in: .bikes, image: editableBike.image, imageName: "\(editableBike.id).png")
        self.navigationController?.popViewController(animated: true)
    }
    
    func showEmptyNameAlert() {
        let ac = UIAlertController(title: "Can't save", message: "Bike name should be filled", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editableBike.propertyLabels.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorImageCell.cellIdentifier, for: indexPath) as? EditorImageCell else { return UITableViewCell() }
            cell.cellImageView.image = editableBike.image
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorPropertyCell.cellIdentifier, for: indexPath) as? EditorPropertyCell else { return UITableViewCell() }
            
            let propertyName = editableBike.propertyLabels[indexPath.row - 1]
            let propertyLabel = editableBike.propertyValues[indexPath.row - 1]
            cell.loadView(propertyName, propertyLabel)
            
            cell.propertyValueTextField.delegate = self
            cell.propertyValueTextField.tag = (indexPath.row - 1)
            if cell.propertyValueTextField.tag == 0 || cell.propertyValueTextField.tag == 1 {
                cell.propertyValueTextField.isUserInteractionEnabled = false
                cell.backgroundColor = .lightGray
            } else {
                cell.propertyValueTextField.isUserInteractionEnabled = true
                cell.backgroundColor = .systemBackground
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageCellHeight: CGFloat = (tableView.bounds.height / 3)
        let propertyCellHeight: CGFloat = (tableView.bounds.height - imageCellHeight) / 6.5
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
            let ac = UIAlertController(title: "Choose photo source", message: nil, preferredStyle: .actionSheet)
            let photo = UIAlertAction(title: "Photo gallery", style: .default) { [weak self] (_) in
                self?.showImagePicker(source: .photoLibrary)
            }
            let album = UIAlertAction(title: "Saved photos", style: .default) { [weak self] (_) in
                self?.showImagePicker(source: .savedPhotosAlbum)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(photo)
            ac.addAction(album)
            ac.addAction(cancel)
            present(ac, animated: true)
        default: return
        }
    }
}

// MARK: - UITextField Delegate

extension BikeEditorViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editableBike = bikeManager.updateBikeProperty(bike: editableBike, forIndex: textField.tag, byValue: textField.text ?? "")
    }
    
}

//MARK: -  UIImagePicker Delegate

extension BikeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary),
              UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditorImageCell,
              let newImage = info[.editedImage] as? UIImage else { dismiss(animated: true); return }
        imageCell.cellImageView.image = newImage
        imageCell.cellImageView.contentMode = .scaleAspectFit
        editableBike = bikeManager.updateBikeImage(bike: editableBike, newImage)
        FileManager.default.clearTmpFolder()
        dismiss(animated: true)
    }
}
