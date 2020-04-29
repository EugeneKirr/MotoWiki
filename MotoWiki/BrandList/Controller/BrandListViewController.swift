//
//  BrandListViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BrandListViewController: UITableViewController {
    
    private let brandManager = BrandManager()
    
    var currentBrandList: BrandList {
        return brandManager.fetchBrandListFromDB(sortBy: .name)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(title: "Brand List") {
            let navSwitchViewButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.tapSwitchViewButton))
            let navAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.tapAddButton) )
            self.navigationItem.leftBarButtonItem = navSwitchViewButton
            self.navigationItem.rightBarButtonItem = navAddButton
        }
        registerCells([.brandListCell])
        setInitial(viewController: .brandListVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Navigation bar actions
    
    @objc func tapSwitchViewButton() {
        guard self.navigationController?.children.count == 1 else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        initializeAndPush(viewController: .brandCollectionVC)
    }
    
    @objc func tapAddButton() {
        initializeAndPush(viewController: .brandEditorVC)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentBrandList.brands.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.brandListCell.cellIdentifier, for: indexPath) as? BrandListCell else { return UITableViewCell() }
        cell.loadView(brand: currentBrandList.brands[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let numberOfRowsInTableView: CGFloat = 8.5
        return (tableView.bounds.height / numberOfRowsInTableView)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        initializeAndPush(viewController: .bikeListVC) { [weak self] (vc) in
            guard let self = self, let bikeListVC = vc as? BikeListViewController else { return }
            bikeListVC.brandOfInterest = self.currentBrandList.brands[indexPath.row]
        }
    }
    
    // MARK: - Swipe actions
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            self.initializeAndPush(viewController: .brandEditorVC) { [weak self] (vc) in
                guard let self = self, let brandEditorVC = vc as? BrandEditorViewController else { return }
                brandEditorVC.editableBrand = self.currentBrandList.brands[indexPath.row]
            }
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.showDeleteAlert(indexPath)
        }
        return UISwipeActionsConfiguration(actions: [edit, delete])
    }
    
    func showDeleteAlert(_ indexPath: IndexPath) {
        let ac = UIAlertController(title: "Warning", message: "Delete this brand?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { [weak self] (_) in
            guard let self = self else { return }
            let deletedBrand = self.currentBrandList.brands[indexPath.row]
            self.brandManager.performDBActionWith(deletedBrand, action: .deleteFromDB)
            FileManager.default.deleteImageFile(in: .brands, imageName: "\(deletedBrand.id).png")
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true)
    }
}
