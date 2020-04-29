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
    
    private var currentBikeList: BikeList {
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
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard currentBikeList.bikes.count == 0 else { return }
        showEmptyAlert()
    }
    
    func showEmptyAlert() {
        let ac = UIAlertController(title: "Empty", message: "Please add new models", preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .default) { (_) in
            self.tapAddButton()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        ac.addAction(add)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
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
        return currentBikeList.bikes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.bikeListCell.cellIdentifier, for: indexPath) as? BikeListCell else { return UITableViewCell() }
        cell.loadView(bike: currentBikeList.bikes[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let numberOfRowsInTableView: CGFloat = 8.5
        return (tableView.bounds.height / numberOfRowsInTableView)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        initializeAndPush(viewController: .bikeViewerVC) { [weak self] (vc) in
            guard let self = self, let bikeViewerVC = vc as? BikeViewerViewController else { return }
            bikeViewerVC.bikeID = self.currentBikeList.bikes[indexPath.row].id
        }
    }
    
    // MARK: - Swipe actions
        
        override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
                self.initializeAndPush(viewController: .bikeEditorVC) { [weak self] (vc) in
                    guard let self = self, let bikeEditorVC = vc as? BikeEditorViewController else { return }
                    bikeEditorVC.editableBike = self.currentBikeList.bikes[indexPath.row]
                }
            }
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
                self.showDeleteAlert(indexPath)
            }
            return UISwipeActionsConfiguration(actions: [edit, delete])
        }
        
        func showDeleteAlert(_ indexPath: IndexPath) {
            let ac = UIAlertController(title: "Warning", message: "Delete this bike?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .destructive) { [weak self] (_) in
                guard let self = self else { return }
                let deletedBike = self.currentBikeList.bikes[indexPath.row]
                self.bikeManager.performDBActionWith(deletedBike, action: .deleteFromDB)
                FileManager.default.deleteImageFile(in: .bikes, imageName: "\(deletedBike.id).png")
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let no = UIAlertAction(title: "No", style: .default, handler: nil)
            ac.addAction(yes)
            ac.addAction(no)
            present(ac, animated: true)
        }
    }

