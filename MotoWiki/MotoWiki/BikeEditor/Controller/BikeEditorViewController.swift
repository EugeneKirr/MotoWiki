//
//  BikeEditorViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

protocol BikeEditorViewControllerDelegate: AnyObject {
    func saveChanges(_ savedBike: Bike)
}

class BikeEditorViewController: UITableViewController {
    
    unowned var editableBike = Bike.defaultBike
    
    private var savedBike = Bike(bikeImage: nil, bikeBrand: "", bikeName: "")
    
    weak var delegate: BikeEditorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        savedBike.bikeImage = editableBike.bikeImage
        savedBike.propertyValues = editableBike.propertyValues
    }
    
    // MARK: - Navigation
    
    func configureNavigationBar() {
        let navSaveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapSaveButton) )
        self.navigationItem.rightBarButtonItem = navSaveButton
        self.navigationItem.title = "Edit Bike Details"
    }
    
    @objc func tapSaveButton() {
        guard savedBike.propertyValues[0] != "", savedBike.propertyValues[1] != "" else { showEmptyPropsAlert(); return }
        delegate?.saveChanges(savedBike)
        self.navigationController?.popViewController(animated: true)
    }
    
    func showEmptyPropsAlert() {
        let ac = UIAlertController(title: "Can't save", message: "Brand and Name should be filled", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Bike.propertyCounter + 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BikeImageCell", for: indexPath) as? BikeImageCell else { return UITableViewCell() }
            cell.bikeImage.image = editableBike.bikeImage
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BikeEditorCell", for: indexPath) as? BikeEditorCell else { return UITableViewCell() }
            cell.loadView(bike: editableBike, index: (indexPath.row-1) )
            cell.bikePropertyText.delegate = self
            cell.bikePropertyText.tag = (indexPath.row-1)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200
        default:
            return 85
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
            return
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
        savedBike.propertyValues[textField.tag] = textField.text ?? "-"
    }
    
}

//MARK: -  UIImagePicker Delegate

extension BikeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BikeImageCell else { return }
        imageCell.bikeImage.image = info[.editedImage] as? UIImage
        imageCell.bikeImage.contentMode = .scaleAspectFill
        
        savedBike.bikeImage = imageCell.bikeImage.image
        dismiss(animated: true)
    }
}

