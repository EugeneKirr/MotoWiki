//
//  BrandListViewController.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 27/03/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class BrandListViewController: UITableViewController {
    
    var editableBrandIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editableBrandIndex = nil
        tableView.reloadData()
    }
    
    // MARK: - Navigation bar
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .darkText
        self.navigationController?.navigationBar.barTintColor = .systemYellow
        
        let navAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton) )
        self.navigationItem.rightBarButtonItem = navAddButton
        self.navigationItem.title = "Brand List"
    }
    
    @objc func tapAddButton() {
        guard let brandEditorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrandEditorVC") as? BrandEditorViewController else { return }
        brandEditorVC.delegate = self
        self.navigationController?.pushViewController(brandEditorVC, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BrandList.content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrandListCell", for: indexPath) as? BrandListCell else { return UITableViewCell() }
        cell.loadView(brand: BrandList.content[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bikeListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BikeListVC") as? BikeListViewController else { return }
        bikeListVC.brandOfInterest = BrandList.content[indexPath.row]
        self.navigationController?.pushViewController(bikeListVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Swipe actions
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            guard let brandEditorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrandEditorVC") as? BrandEditorViewController else { return }
            brandEditorVC.editableBrand = BrandList.content[indexPath.row]
            brandEditorVC.delegate = self
            
            self.editableBrandIndex = indexPath.row
            self.navigationController?.pushViewController(brandEditorVC, animated: true)
        }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.showDeleteAlert(indexPath)
        }
        return UISwipeActionsConfiguration(actions: [edit, delete])
    }
    
    func showDeleteAlert(_ indexPath: IndexPath) {
        let ac = UIAlertController(title: "Warning", message: "Delete this brand?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            BrandList.content.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true)
    }
}

// MARK: - BrandEditorViewController Delegate

extension BrandListViewController: BrandEditorViewControllerDelegate {
    
    func saveChanges(_ savedBrand: Brand) {
        guard let index = editableBrandIndex else {
            BrandList.content.append(savedBrand)
            BrandList.sortByName()
            return
        }
        BrandList.content[index] = savedBrand
        BrandList.sortByName()
    }
    
}

