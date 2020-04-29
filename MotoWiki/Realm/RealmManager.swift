//
//  RealmManager.swift
//  MotoWiki
//
//  Created by Eugene Kireichev on 23/04/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    func printRealmURL() {
        guard let url = Realm.Configuration.defaultConfiguration.fileURL else { return }
        print(url)
    }
    
    func addToDB<R: Object>(_ realmObject: R) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(realmObject, update: .modified)
            }
        } catch {
            print("realm add/update error")
        }
    }
    
    func fetchFromDB<R: Object>(completion: (Results<R>) -> Void) {
        do {
            let realm = try Realm()
            let fetchedResults = realm.objects(R.self)
            completion(fetchedResults)
        } catch {
            print("realm fetch error")
        }
    }
    
    func deleteFromDB<R: Object>(_ realmObject: R) {
        do {
            let realm = try Realm()
            try realm.write {
                guard let primaryKey = R.primaryKey() else { print("realm object has no property as primary key"); return }
                guard let primatyKeyValue = realmObject.value(forKey: primaryKey) else { print ("no value for primary key"); return }
                guard let fetchedObject = realm.object(ofType: R.self, forPrimaryKey: primatyKeyValue) else { print("error"); return }
                realm.delete(fetchedObject)
            }
        } catch {
            print("realm delete error")
        }
    }
    
}
