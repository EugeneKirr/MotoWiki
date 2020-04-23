//
//  BikeListViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BikeListViewController: UITableViewController {
    
    var brandOfInterest = Brand.defaultBrand
    
    var chosenBikes = [Bike]() {
        didSet {
            guard chosenBikes.count == 0 else { return }
            showEmptyAlert()
        }
    }
    
    var editableBikeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        registerCells([.bikeListCell])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editableBikeIndex = nil
        BikeList.sortByName()
        chosenBikes = BikeList.getBikes(for: brandOfInterest)
        tableView.reloadData()
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
    
    // MARK: - Navigation bar
    
    func configureNavigationBar() {
        let navAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton) )
        self.navigationItem.rightBarButtonItem = navAddButton
        self.navigationItem.title = "Bike List"
    }
    
    @objc func tapAddButton() {
        guard let bikeEditorVC = UIStoryboard(name: "BikeEditor", bundle: nil).instantiateViewController(identifier: "bikeEditorVC") as? BikeEditorViewController else { return }
        bikeEditorVC.delegate = self
        self.navigationController?.pushViewController(bikeEditorVC, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chosenBikes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectViews.bikeListCell.cellIdentifier, for: indexPath) as? BikeListCell else { return UITableViewCell() }
        //cell.loadView(bike: chosenBikes[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bikeViewerVC = UIStoryboard(name: "BikeViewer", bundle: nil).instantiateViewController(withIdentifier: "bikeViewerVC") as? BikeViewerViewController else { return }
        bikeViewerVC.chosenBike = chosenBikes[indexPath.row]
        bikeViewerVC.chosenBikeIndex = BikeList.getIndex(for: chosenBikes[indexPath.row])
        
        self.navigationController?.pushViewController(bikeViewerVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Swipe Actions
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            guard let bikeEditorVC = UIStoryboard(name: "BikeEditor", bundle: nil).instantiateViewController(identifier: "bikeEditorVC") as? BikeEditorViewController else { return }
            bikeEditorVC.editableBike = self.chosenBikes[indexPath.row]
            bikeEditorVC.delegate = self
            
            self.editableBikeIndex = BikeList.getIndex(for: self.chosenBikes[indexPath.row])
            self.navigationController?.pushViewController(bikeEditorVC, animated: true)
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.showDeleteAlert(indexPath)
        }
        return UISwipeActionsConfiguration(actions: [edit, delete])
    }
    
    func showDeleteAlert(_ indexPath: IndexPath) {
        let ac = UIAlertController(title: "Warning", message: "Delete this bike?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            let deletedBike = self.chosenBikes.remove(at: indexPath.row)
            BikeList.remove(deletedBike)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true)
    }    
}


// MARK: - BikeEditorViewController Delegate

extension BikeListViewController: BikeEditorViewControllerDelegate {
    
    func saveChanges(_ savedBike: Bike) {
        guard let index = editableBikeIndex else {
            BikeList.content.append(savedBike)
            BikeList.sortByName()
            return
        }
        BikeList.content[index] = savedBike
    }

}
