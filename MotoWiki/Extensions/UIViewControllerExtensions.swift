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
        case .brandListVC, .bikeListVC:
            guard let self = self as? UITableViewController else { return }
            self.tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        case .brandCollectionVC:
            guard let self = self as? UICollectionViewController else { return }
            self.collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        default: return
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
