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
    
    private var selectedCellIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(title: "Edit Bike Details") {
            let navSaveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.tapSaveButton))
            self.navigationItem.rightBarButtonItem = navSaveButton
        }
        registerCells([.editorGalleryCell, .editorPropertyCell])
        guard editableBike.id == 0 else { return }
        editableBike = bikeManager.updateBikeWithNewID(editableBike)
    }
    
    // MARK: - Navigation bar action
    
    @objc func tapSaveButton() {
        guard editableBike.propertyValues[2] != "" else { showEmptyNameAlert(); return }
        bikeManager.performDBActionWith(editableBike, action: .addToDB)
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editableBike.propertyLabels.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorGalleryCell.cellIdentifier, for: indexPath) as? EditorGalleryCell else { return UITableViewCell() }
            
            cell.editorGalleryCollectionView.delegate = self
            cell.editorGalleryCollectionView.dataSource = self
            cell.editorGalleryCollectionView.register(UINib(nibName: ProjectViews.galleryCollectionCell.xibName, bundle: nil), forCellWithReuseIdentifier: ProjectViews.galleryCollectionCell.cellIdentifier)
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorPropertyCell.cellIdentifier, for: indexPath) as? EditorPropertyCell else { return UITableViewCell() }
            
            let propertyName = editableBike.propertyLabels[indexPath.row - 1]
            let propertyLabel = editableBike.propertyValues[indexPath.row - 1]
            cell.loadView(propertyName, propertyLabel)
            cell.propertyValueTextField.delegate = self
            if indexPath.row == 1 || indexPath.row == 2 {
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
        switch indexPath.row {
        case 0: return calculateRowHeight(occupiedFractionOfTableHeight: 0.33)
        default: return calculateRowHeight(occupiedFractionOfTableHeight: 0.125)
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
    }
}

// MARK: - UITextField Delegate

extension BikeEditorViewController: UITextFieldDelegate {
    
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
        editableBike = bikeManager.updateBikeProperty(bike: editableBike, forIndex: selectedCellIndex, byValue: textField.text ?? "")
    }
    
}

extension BikeEditorViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editableBike.images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectViews.galleryCollectionCell.cellIdentifier, for: indexPath) as? GalleryCollectionCell else { return UICollectionViewCell() }
        cell.delegate = self
        switch indexPath.row {
        case 0:
            cell.cellImageView.image = editableBike.images[indexPath.row]
            cell.cellActionButton.alpha = 0.0
        case editableBike.images.count:
            cell.cellImageView.image = UIImage(systemName: "plus.circle")
            cell.cellActionButton.alpha = 0.0
        default:
            cell.cellImageView.image = editableBike.images[indexPath.row]
            cell.cellActionButton.alpha = 1.0
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        selectedCellIndex = indexPath.row
        showPhotoSourceActionSheet()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateGalleryCellSize(galleryView: collectionView, occupiedFractionOfGalleryHeight: 1.0, cellWidthMultiplier: (4/3))
    }
    
}

//MARK: -  UIImagePicker Delegate

extension BikeEditorViewController {
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        super.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        guard let editorGalleryCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditorGalleryCell,
              let newImage = info[.editedImage] as? UIImage else { return }
        editableBike = bikeManager.updateBikeImage(bike: editableBike, imageIndex: selectedCellIndex, with: newImage)
        editorGalleryCell.editorGalleryCollectionView.reloadData()
    }
    
}

//MARK: -  GalleryCollectionCell ButtonActionDelegate

extension BikeEditorViewController: CellButtonActionDelegate {
    
    func buttonAction(_ cell: UICollectionViewCell) {
        guard let editorGalleryCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditorGalleryCell else { return }
        guard let cellIndexPath = editorGalleryCell.editorGalleryCollectionView.indexPath(for: cell) else { print("no index"); return }
        editableBike = bikeManager.removeBikeImage(bike: editableBike, imageIndex: cellIndexPath.row)
        editorGalleryCell.editorGalleryCollectionView.deleteItems(at: [cellIndexPath])
    }
    
}
