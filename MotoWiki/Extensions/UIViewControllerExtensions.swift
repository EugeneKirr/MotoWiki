//
//  UIViewControllerExtensions.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 22/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func registerCell(xibName: String, cellIdentifier: String, viewController: ProjectViewControllers) {
        let nib = UINib(nibName: xibName, bundle: nil)
        switch viewController {
        case .brandListVC, .brandEditorVC, .bikeListVC, .bikeEditorVC, .bikeViewerVC:
            guard let self = self as? UITableViewController else { return }
            self.tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        case .brandCollectionVC:
            guard let self = self as? UICollectionViewController else { return }
            self.collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        }
    }
    
    func registerCells(_ cells: [ProjectViews]) {
        for cell in cells {
            let nib = UINib(nibName: cell.xibName, bundle: nil)
            switch cell.superclassDescription {
            case "UITableViewCell":
                guard let self = self as? UITableViewController else { return }
                self.tableView.register(nib, forCellReuseIdentifier: cell.cellIdentifier)
            case "UICollectionViewCell":
                guard let self = self as? UICollectionViewController else { return }
                self.collectionView.register(nib, forCellWithReuseIdentifier: cell.cellIdentifier)
            default: return
            }
        }
    }
    
}

extension UIViewController {
    
    func setInitial(viewController: ProjectViewControllers) {
        let defaults = UserDefaults.standard
        defaults.set(viewController.rawValue, forKey: UDKeys.initialVC.key)
    }
    
}

extension UIViewController {
    
    func configureNavBar(title: String, completion: (() -> Void)? = nil) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .darkText
        self.navigationController?.navigationBar.barTintColor = UIColor.systemYellow
        self.navigationItem.title = title
        completion?()
    }
    
}

extension UIViewController {
    
    func initializeAndPush(viewController: ProjectViewControllers, completion: ((UIViewController) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: viewController.storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: viewController.vcIdentifier)
        self.navigationController?.pushViewController(viewController, animated: true)
        completion?(viewController)
    }
}

extension UIViewController {
    
    func showEmptyViewAlert(addCompletion: ((UIAlertAction) -> Void)?) {
        let ac = UIAlertController(title: "Empty", message: "Please add new items", preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .default, handler: addCompletion)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        ac.addAction(add)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    func showDeleteAlert(confirmCompletion: ((UIAlertAction) -> Void)? ) {
        let ac = UIAlertController(title: "Warning", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler: confirmCompletion)
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true)
    }
    
}
