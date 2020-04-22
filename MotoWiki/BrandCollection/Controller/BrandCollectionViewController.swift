//
//  BrandCollectionViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 22/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BrandCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(title: "Brand Collection") {
            let navSwitchViewButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.tapSwitchViewButton))
            let navAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.tapAddButton) )
            self.navigationItem.leftBarButtonItem = navSwitchViewButton
            self.navigationItem.rightBarButtonItem = navAddButton
        }
        self.navigationItem.title = "Brand Collection"
        registerCell(xibName: "BrandCollectionCell", cellIdentifier: "brandCollectionCell", viewController: .brandCollectionVC)
        setInitial(viewController: .brandCollectionVC)
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
        initializeAndPush(viewController: .brandEditorVC) { (vc) in
            guard let brandEditorVC = vc as? BrandEditorViewController else { return }
            brandEditorVC.delegate = self
        }
    }
    

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 21
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandCollectionCell", for: indexPath) as? BrandCollectionCell else { return UICollectionViewCell() }
    
        cell.backgroundColor = .systemYellow
    
        return cell
    }
    
    

    // MARK: - UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

// MARK: - Adaptive Cell Size

extension BrandCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInRow = 3
        let cellSize = (collectionView.bounds.width / CGFloat(numberOfCellsInRow))
        return CGSize(width: cellSize, height: cellSize)
    }
    
}

// MARK: - BrandEditorViewController Delegate

extension BrandCollectionViewController: BrandEditorViewControllerDelegate {
    
    func saveChanges(_ savedBrand: Brand) {
//        guard let index = editableBrandIndex else {
//            BrandList.content.append(savedBrand)
//            BrandList.sortByName()
//            return
//        }
//        BrandList.content[index] = savedBrand
//        BrandList.sortByName()
    }
    
}
