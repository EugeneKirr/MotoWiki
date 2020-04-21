//
//  BikeViewerViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BikeViewerViewController: UITableViewController {
    
    var chosenBike = Bike.defaultBike
    var chosenBikeIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Navigation bar
    
    func configureNavigationBar() {
        let navEditButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEditButton) )
        self.navigationItem.rightBarButtonItem = navEditButton
        self.navigationItem.title = "Bike Details"
    }
    
    @objc func tapEditButton(_ sender: UIBarButtonItem) {
        guard let bikeEditorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "BikeEditorVC") as? BikeEditorViewController else { return }
        bikeEditorVC.editableBike = chosenBike
        bikeEditorVC.delegate = self
        self.navigationController?.pushViewController(bikeEditorVC, animated: true)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Bike.propertyCounter + 1)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BikeViewerImageCell", for: indexPath) as? BikeViewerImageCell else { return UITableViewCell() }
            cell.bikeImage.image = chosenBike.bikeImage
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BikeViewerCell", for: indexPath) as? BikeViewerCell else { return UITableViewCell() }
            cell.loadView(bike: chosenBike, index: (indexPath.row - 1) )
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200
        default:
            return 85
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - BikeEditorViewController Delegate

extension BikeViewerViewController: BikeEditorViewControllerDelegate {
    
    func saveChanges(_ savedBike: Bike) {
        guard let index = chosenBikeIndex else { return }
        chosenBike = savedBike
        BikeList.content[index] = savedBike
    }
    
}


