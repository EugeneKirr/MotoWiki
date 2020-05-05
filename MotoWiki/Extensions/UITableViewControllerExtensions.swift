//
//  UITableViewControllerExtensions.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 29/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

extension UITableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    func calculateGalleryCellSize(galleryView: UICollectionView, occupiedFractionOfGalleryHeight: CGFloat, cellWidthMultiplier: CGFloat) -> CGSize {
        guard occupiedFractionOfGalleryHeight >= 0.0 && occupiedFractionOfGalleryHeight <= 1.0 else {
            return CGSize(width: galleryView.bounds.height, height: galleryView.bounds.height)
        }
        let cellHeight = galleryView.bounds.height * occupiedFractionOfGalleryHeight
        let cellWidth = cellHeight * cellWidthMultiplier
        return CGSize(width: cellWidth, height: cellHeight)
    }
 
}

extension UITableViewController {

    func showEmptyNameAlert() {
        let ac = UIAlertController(title: "Can't save", message: "Name should be filled", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true)
    }

}

extension UITableViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
}
