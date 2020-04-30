//
//  UITableViewControllerExtensions.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 29/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

extension UITableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary),
              UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditorImageCell,
              let newImage = info[.editedImage] as? UIImage else { dismiss(animated: true); return }
        imageCell.cellImageView.image = newImage
        imageCell.cellImageView.contentMode = .scaleAspectFit
        FileManager.default.clearTmpFolder()
        dismiss(animated: true)
    }
    
}

extension UITableViewController {
    
    func calculateRowHeight(occupiedFractionOfTableHeight: CGFloat) -> CGFloat {
        guard occupiedFractionOfTableHeight >= 0.0 && occupiedFractionOfTableHeight <= 1.0 else { return 60 }
        let tableHeight = self.tableView.bounds.height
        return tableHeight * occupiedFractionOfTableHeight
    }
 
}

extension UITableViewController {

    func showEmptyNameAlert() {
        let ac = UIAlertController(title: "Can't save", message: "Name should be filled", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true)
    }
    
    func showPhotoSourceActionSheet() {
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
    }
    
    func showDeleteAlert(_ indexPath: IndexPath, confirmCompletion: ((UIAlertAction) -> Void)? ) {
        let ac = UIAlertController(title: "Warning", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler: confirmCompletion)
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true)
    }

}

extension UITableViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
}
