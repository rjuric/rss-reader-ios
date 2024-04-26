//
//  DatabaseService.swift
//  RSS Reader
//
//  Created by rjuric on 26.04.2024..
//

import Foundation
import RealmSwift

protocol DatabaseServiceProtocol {
    func get<T: Object>(_ model: T.Type) throws -> [T]
    func store<T: Object>(_ object: T) throws
    func update<T: Object>(_ object: T) throws
    func delete<T: Object>(_ object: T) throws
}

struct DatabaseService: DatabaseServiceProtocol {
    let realm = try! Realm()
    
    func get<T: Object>(_ model: T.Type) throws -> [T] {
        let result = realm.objects(model)
        return Array(result)
    }
    
    func store<T: Object>(_ object: T) throws {
        try realm.write {
            realm.add(object)
        }
    }
    
    func update<T: Object>(_ object: T) throws {
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func delete<T: Object>(_ object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }
}
