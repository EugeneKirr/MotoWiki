//
//  BikeViewerViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BikeViewerViewController: UITableViewController {
    
    private let bikeManager = BikeManager()
    
    var bikeID = 0
    
    private var bikeOfInterest: Bike {
        return bikeManager.fetchBikeFromDB(with: bikeID)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(title: "Bike Details") {
            let navAddButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.tapEditButton) )
            self.navigationItem.rightBarButtonItem = navAddButton
        }
        registerCells([.editorGalleryCell, .editorPropertyCell])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Navigation bar actions

    @objc func tapEditButton(_ sender: UIBarButtonItem) {
        initializeAndPush(viewController: .bikeEditorVC) { [weak self] (vc) in
            guard let self = self, let bikeEditorVC = vc as? BikeEditorViewController else { return }
            bikeEditorVC.editableBike = self.bikeOfInterest
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bikeOfInterest.propertyLabels.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorGalleryCell.cellIdentifier, for: indexPath) as? EditorGalleryCell else { return UITableViewCell() }
            
            cell.editorGalleryCollectionView.delegate = self
            cell.editorGalleryCollectionView.dataSource = self
            cell.editorGalleryCollectionView.register(UINib(nibName: ProjectViews.galleryCollectionCell.xibName, bundle: nil), forCellWithReuseIdentifier: ProjectViews.galleryCollectionCell.cellIdentifier)
            cell.editorGalleryCollectionView.reloadData()
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorPropertyCell.cellIdentifier, for: indexPath) as? EditorPropertyCell else { return UITableViewCell() }
            
            let propertyName = bikeOfInterest.propertyLabels[indexPath.row - 1]
            let propertyLabel = bikeOfInterest.propertyValues[indexPath.row - 1]
            cell.loadView(propertyName, propertyLabel)
            cell.propertyValueTextField.isUserInteractionEnabled = false
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
    }
    
}

extension BikeViewerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bikeOfInterest.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectViews.galleryCollectionCell.cellIdentifier, for: indexPath) as? GalleryCollectionCell else { return UICollectionViewCell() }
        cell.cellImageView.image = bikeOfInterest.images[indexPath.row]
        cell.cellActionButton.alpha = 0.0
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInColumn: Int = 1
        let cellHeight = (collectionView.bounds.height / CGFloat(numberOfCellsInColumn))
        let cellWidth = 4 * cellHeight / 3
        return CGSize(width: cellWidth, height: cellHeight)
    }
      
}
