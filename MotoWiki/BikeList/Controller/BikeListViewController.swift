//
//  BikeListViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BikeListViewController: UITableViewController {
    
    private let bikeManager = BikeManager()
    
    var brandOfInterest = Brand()
    
    private var currentBikeList: [Bike] {
        return bikeManager.fetchBikeListFromDB(with: brandOfInterest, sortBy: .name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar(title: brandOfInterest.propertyValues[0]) {
            let navAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.tapAddButton) )
            self.navigationItem.rightBarButtonItem = navAddButton
        }
        registerCells([.bikeListCell])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard currentBikeList.count == 0 else { return }
        showEmptyViewAlert { [weak self] (_) in
            self?.tapAddButton()
        }
    }
    
    // MARK: - Navigation bar actions
    
    @objc func tapAddButton() {
        initializeAndPush(viewController: .bikeEditorVC) { [weak self] (vc) in
            guard let self = self, let bikeEditorVC = vc as? BikeEditorViewController else { return }
            bikeEditorVC.editableBike = Bike(self.brandOfInterest)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentBikeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.bikeListCell.cellIdentifier, for: indexPath) as? BikeListCell else { return UITableViewCell() }
        cell.loadView(bike: currentBikeList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateRowHeight(occupiedFractionOfTableHeight: 0.125)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        initializeAndPush(viewController: .bikeViewerVC) { [weak self] (vc) in
            guard let self = self, let bikeViewerVC = vc as? BikeViewerViewController else { return }
            bikeViewerVC.bikeID = self.currentBikeList[indexPath.row].id
        }
    }
    
    // MARK: - Swipe actions
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            self.initializeAndPush(viewController: .bikeEditorVC) { [weak self] (vc) in
                guard let self = self, let bikeEditorVC = vc as? BikeEditorViewController else { return }
                bikeEditorVC.editableBike = self.currentBikeList[indexPath.row]
            }
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.showDeleteAlert(indexPath) { [weak self] (_) in
                guard let self = self else { return }
                let deletedBike = self.currentBikeList[indexPath.row]
                self.bikeManager.performDBActionWith(deletedBike, action: .deleteFromDB)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        return UISwipeActionsConfiguration(actions: [edit, delete])
    }
        
}

