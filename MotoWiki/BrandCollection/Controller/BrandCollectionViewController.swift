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
    
    var currentBrandList: BrandList {
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
        setInitial(viewController: .brandCollectionVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
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
        return currentBrandList.brands.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectViews.brandCollectionCell.cellIdentifier, for: indexPath) as? BrandCollectionCell else { return UICollectionViewCell() }
        cell.loadView(brand: currentBrandList.brands[indexPath.row])
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        initializeAndPush(viewController: .bikeListVC) { [weak self] (vc) in
            guard let self = self, let bikeListVC = vc as? BikeListViewController else { return }
            bikeListVC.brandOfInterest = self.currentBrandList.brands[indexPath.row]
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
