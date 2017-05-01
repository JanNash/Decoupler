//
//  Object.swift
//  Decoupler
//
//  Created by Jan Nash on 5/1/17.
//  Copyright © 2017 JanNash. All rights reserved.
//

import Foundation



protocol MappedData {
    
}

typealias Minutes = Float





protocol WeakDataSourceClientArray {
    func cachePolicy<D: DataSource>(for objects: [Object], on dataSource: D) -> CachePolicy
    func didCache<D: DataSource>(_ objects: [Object], on dataSource: D, with cachePolicy: CachePolicy)
    func shouldLoad<D: DataSource>(_ objects: [Object], from dataSource: D)
    func didLoad<D: DataSource>(_ objects: [Object], from dataSource: D)
    func shouldSave<D: DataSource>(_ objects: [Object], to dataSource: D)
    func didSave<D: DataSource>(_ objects: [Object], to dataSource: D)
    func shouldDelete<D: DataSource>(_ objects: [Object], from dataSource: D)
    func didDelete<D: DataSource>(_ objecs: [Object], from dataSource: D)
}


enum CachePolicy {
    case dontCache
    case cacheFor(minutes: Float)
    case cachePermanently
}

enum SaveResult {
    enum SaveError: Error {
        case unknown
        case unauthorized
        case failedValidation
    }
    
    case success(Object)
    case failure(SaveError)
}

enum ReloadResult {
    enum ReloadError: Error {
        case unknown
        case unauthorized
    }
    
    case success(Object)
    case failure(ReloadError)
}

enum DeleteResult {
    enum DeleteError {
        case unknown
        case unauthorized
        case failedValidation
    }
    
    case success(Object)
    case failure(DeleteError)
}


protocol DataSource {
    // Of course, this will have to be a WeakRefDict...
    //    static var idCache: [ObjectID: Object] { get set }
    //    static var filterCache: [[Filter]: ObjectID] { get set }
    var defaultCachePolicy: CachePolicy { get }
    
    var clients: WeakDataSourceClientArray { get }
    
    func map(object: Object) -> MappedData
    func map(mappedData: MappedData) -> Object
    
    mutating func loadObjects(withIDs ids: [ObjectID], overrideCache: Bool) -> [Identifiable]
    mutating func loadObjects<F: Filter>(ofType type: Object.Type, with filters: [F], overrideCache: Bool) -> [Object]
    mutating func reloadObjects(_ objects: [Object]) -> ReloadResult
    mutating func persistObjects(_ objects: [Object]) -> SaveResult
    mutating func deleteObjects(_ objects: [Object]) -> DeleteResult
    
    mutating func flushIDCache()
    mutating func flushFilterCache()
    mutating func flushAllCashes()
}


protocol ObjectCache {
    var idCache: [ObjectID: Object] { get set }
}


extension DataSource {
    mutating func loadObjects(with ids: [ObjectID], cachePolicy: CachePolicy? = nil) -> [Identifiable] {
        return self._loadObjects(with: ids, cachePolicy: cachePolicy)
    }
    
    mutating func loadObjects<F: Filter>(ofType type: Object.Type, with filters: [F], cachePolicy: CachePolicy? = nil) -> [Object] {
        return self._loadObjects(ofType: type, with: filters, cachePolicy: cachePolicy)
    }
    
    mutating func cache(_ objects: [Identifiable], for minutes: Minutes) {
        self._cache(objects, for: minutes)
    }
}

private extension DataSource {
    mutating func _loadObjects(with ids: [ObjectID], cachePolicy: CachePolicy?) -> [Identifiable] {
        let objects: [Identifiable] = self.loadObjects(withIDs: ids, overrideCache: true)
        
        switch cachePolicy ?? self.defaultCachePolicy {
        case .cachePermanently:
            break
        case let .cacheFor(minutes):
            self.cache(objects, for: minutes)
//            self.clients.didCache(objects, on: self, with: cachePolicy)
        case .dontCache:
            break
        }
        
        self.clients.didLoad(objects, from: self)
        return objects
    }
    
    mutating func _loadObjects<F: Filter>(ofType type: Object.Type, with filters: [F], cachePolicy: CachePolicy?) -> [Object] {
        let objects: [Object] = self.loadObjects(ofType: type, with: filters, overrideCache: true)
        
        switch cachePolicy ?? self.defaultCachePolicy {
        case .cachePermanently:
            break
        case let .cacheFor(minutes):
//            self.cacheObjects(objects, for: minutes)
//            self.clients.didCache(objects, on: self, for: minutes)
            break
        case .dontCache:
            break
        }
        
//        self.clients.objectsWereLoaded(objects, from: self)
        return objects
        
        return []
    }
    
    mutating func _cache(_ objects: [Identifiable], for minutes: Minutes) {
//        objects.forEach({ self.idCache.updateValue($0, forKey: $0.objectID) })
    }
    
    //    mutating func _cacheObjects(_ objectDict: [Filter: Object], for minutes: Minutes) {
    //
    //    }
}




protocol DataController {
    func loadObject<D: DataSource>(with id: ObjectID, from dataSource: D, cachePolicy: CachePolicy) -> Identifiable?
    func loadObjects<D: DataSource>(with ids: [ObjectID], from dataSource: D) -> [Identifiable]
    func loadObjects<D: DataSource, F: Filter>(with filters: [F], from dataSource: D) -> [Object]
    func reloadObjects<Ob: Object, D: DataSource>(_ object: [Ob]) -> (ReloadResult, D)
    func persistObjects<Ob: Object, D: DataSource>(_ objects: [Ob]) -> (ReloadResult, D)
    func deleteObjects<Ob: Object, D: DataSource>(_ objects: [Ob]) -> (ReloadResult, D)
}




protocol Filter: Hashable {
    
}




protocol Object {
    var controller: DataController { get }
}

protocol Identifiable: Object {
    var IDValue: Int { get }
    var objectID: ObjectID { get }
}




class ObjectID {
    var registeredCopies: [Identifiable] = []
}

extension ObjectID {
    var value: Int {
        return self.registeredCopies.first!.IDValue
    }
}

extension ObjectID: Equatable {
    static func ==(_ lhs: ObjectID, _ rhs: ObjectID) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension ObjectID: Hashable {
    var hashValue: Int {
        return self.value
    }
}

