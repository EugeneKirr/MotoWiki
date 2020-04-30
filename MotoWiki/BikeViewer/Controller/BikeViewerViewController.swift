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
        registerCells([.editorImageCell, .editorPropertyCell])
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.editorImageCell.cellIdentifier, for: indexPath) as? EditorImageCell else { return UITableViewCell() }
            cell.cellImageView.image = bikeOfInterest.image
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
