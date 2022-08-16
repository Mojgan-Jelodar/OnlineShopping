//
//  File.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
import RealmSwift
// swiftlint:disable force_cast
/* Storage config options */
public enum ConfigurationType {
    case basic(url: String?)
    case inMemory(identifier: String?)

    var associated: String? {
        switch self {
        case .basic(let url): return url
        case .inMemory(let identifier): return identifier
        }
    }
}

class RealmStorageContext: StorageContext {
    var realm: Realm?

    required init(configuration: ConfigurationType = .basic(url: nil)) throws {
        var rmConfig = Realm.Configuration()
        rmConfig.readOnly = true
        switch configuration {
        case .basic:
            rmConfig = Realm.Configuration.defaultConfiguration
            if let url = configuration.associated {
                rmConfig.fileURL = NSURL(string: url) as URL?
            }
        case .inMemory:
            rmConfig = Realm.Configuration()
            if let identifier = configuration.associated {
                rmConfig.inMemoryIdentifier = identifier
            } else {
                throw NSError()
            }
        }
        try self.realm = Realm(configuration: rmConfig)
    }

    public func safeWrite(_ block: (() throws -> Void)) throws {
        guard let realm = self.realm else {
            throw NSError()
        }

        if realm.isInWriteTransaction {
            try block()
        } else {
            try realm.write(block)
        }
    }
}

extension RealmStorageContext {
    func create<T: Storable>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws {
        guard let realm = self.realm else {
            throw NSError()
        }

        try self.safeWrite {
            let newObject = realm.create(model as! Object.Type, value: [], update: .all) as! T
            completion(newObject)
        }
    }

    func save(object: Storable) throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        try self.safeWrite {
            realm.add(object as! Object,update: .all)
        }
    }

    func save(objects: [Storable]) throws {
        guard let realm = self.realm else { throw NSError() }
        try self.safeWrite {
            realm.add(objects as! [Object], update: .all)
        }
    }

    func update(block: @escaping () -> Void) throws {
        try self.safeWrite {
            block()
        }
    }
}

extension RealmStorageContext {
    func delete(object: Storable) throws {
        guard let realm = self.realm else {
            throw NSError()
        }

        try self.safeWrite {
            realm.delete(object as! Object)
        }
    }

    func deleteAll<T : Storable>(_ model: T.Type) throws {
        guard let realm = self.realm else {
            throw NSError()
        }

        try self.safeWrite {
            let objects = realm.objects(model as! Object.Type)

            for object in objects {
                realm.delete(object)
            }
        }
    }

    func reset() throws {
        guard let realm = self.realm else {
            throw NSError()
        }
        try self.safeWrite {
            realm.deleteAll()
        }
    }
}

extension RealmStorageContext {
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil) -> [T] {
        var objects = self.realm?.objects(model as! Object.Type)

        if let predicate = predicate {
            objects = objects?.filter(predicate)
        }

        if let sorted = sorted {
            objects = objects?.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }

        var accumulate: [T] = [T]()
        for object in objects! {
            accumulate.append(object as! T)
        }
        return accumulate
    }
}
