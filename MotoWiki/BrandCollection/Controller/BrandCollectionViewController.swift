//
//  BrandCollectionViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 22/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BrandCollectionViewController: UICollectionViewController {
    
    private let brandManager = BrandManager()
    
    var currentBrandList: [Brand] {
        return brandManager.fetchBrandListFromDB(sortBy: .name)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(title: "Brand Collection") {
            let navSwitchViewButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.tapSwitchViewButton))
            let navAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.tapAddButton) )
            self.navigationItem.leftBarButtonItem = navSwitchViewButton
            self.navigationItem.rightBarButtonItem = navAddButton
        }
        registerCells([.brandCollectionCell])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInitial(viewController: .brandCollectionVC)
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard currentBrandList.count == 0 else { return }
        showEmptyViewAlert { [weak self] (_) in
            self?.tapAddButton()
        }
    }
    
    // MARK: - Navigation bar actions
    
    @objc func tapSwitchViewButton() {
        guard self.navigationController?.children.count == 1 else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        initializeAndPush(viewController: .brandListVC)
    }
    
    @objc func tapAddButton() {
        initializeAndPush(viewController: .brandEditorVC)
    }
    
    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentBrandList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectViews.brandCollectionCell.cellIdentifier, for: indexPath) as? BrandCollectionCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.loadView(brand: currentBrandList[indexPath.row])
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BrandCollectionCell else { return }
        switch cell.isInEditMode {
        case true:
            cell.setEditMode(false)
        case false:
            initializeAndPush(viewController: .bikeListVC) { [weak self] (vc) in
                guard let self = self, let bikeListVC = vc as? BikeListViewController else { return }
                bikeListVC.brandOfInterest = self.currentBrandList[indexPath.row]
            }
        }
    }
    
}

// MARK: - Adaptive Cell Size

extension BrandCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInRow: Int = 3
        let cellSize = (collectionView.bounds.width / CGFloat(numberOfCellsInRow))
        return CGSize(width: cellSize, height: cellSize)
    }
    
}

// MARK: - Long Press Actions

extension BrandCollectionViewController: BrandCellButtonActionsDelegate {
    
    func deleteButtonAction(_ cell: BrandCollectionCell) {
        showDeleteAlert() { [weak self] (_) in
            guard let self = self, let indexPath = self.collectionView.indexPath(for: cell) else { return }
            let deletedBrand = self.currentBrandList[indexPath.row]
            self.brandManager.performDBActionWith(deletedBrand, action: .deleteFromDB)
            self.collectionView.deleteItems(at: [indexPath])
        }
    }
    
    func editButtonAction(_ cell: BrandCollectionCell) {
        initializeAndPush(viewController: .brandEditorVC) { [weak self] (vc) in
            guard let self = self, let brandEditorVC = vc as? BrandEditorViewController,
                  let index = self.collectionView.indexPath(for: cell)?.row else { return }
            brandEditorVC.editableBrand = self.currentBrandList[index]
        }
    }
    
    
}
