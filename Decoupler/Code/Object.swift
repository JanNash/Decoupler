//
//  Object.swift
//  Decoupler
//
//  Created by Jan Nash on 5/1/17.
//  Copyright © 2017 JanNash. All rights reserved.
//

import SignificantSpices
import WeakRefCollections




protocol MappedData {}

typealias Minutes = Float



protocol DataSourceClient {
    func shouldLoad<D: DataSource>(_ objects: [Object], from dataSource: D) -> Bool
    func shouldSave<D: DataSource>(_ objects: [Object], to dataSource: D) -> Bool
    func shouldDelete<D: DataSource>(_ objects: [Object], from dataSource: D) -> Bool
}


protocol AsyncDataSourceClient: DataSourceClient {
    func didLoad<AD: AsyncDataSource>(_ objects: [Object], from dataSource: AD)
    func didSave<AD: AsyncDataSource>(_ objects: [Object], to dataSource: AD)
    func didDelete<AD: AsyncDataSource>(_ objecs: [Object], from dataSource: AD)
}


extension Array {
    func shouldLoad<D: DataSource>(_ objects: [Object], from dataSource: D) -> Bool where Element: DataSourceClient {
        return self.all(fulfill: { $0.shouldLoad(objects, from: dataSource) })
    }
    
    func shouldSave<D: DataSource>(_ objects: [Object], to dataSource: D) -> Bool where Element: DataSourceClient {
        return self.all(fulfill: { $0.shouldSave(objects, to: dataSource) })
    }
    
    func shouldDelete<D: DataSource>(_ objects: [Object], from dataSource: D) -> Bool where Element: DataSourceClient {
        return self.all(fulfill: { $0.shouldDelete(objects, from: dataSource) })
    }
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
    var clients: DataSourceClient { get }
}


protocol SyncDataSource: DataSource {
    func loadObjectsSync(withIDs ids: [ObjectID]) -> [Identifiable]
    func loadObjectsSync<F: Filter>(ofType type: Object.Type, with filters: [F]) -> [Object]
    func reloadObjectsSync(_ objects: [Object]) -> ReloadResult
    func saveObjectsSync(_ objects: [Object]) -> SaveResult
    func deleteObjectsSync(_ objects: [Object]) -> DeleteResult
}

protocol AsyncDataSource: DataSource {
    var clients: [AsyncDataSourceClient] { get }
    
    func loadObjectsAsync(withIDs ids: [ObjectID])
    func loadObjectsAsync<F: Filter>(ofType type: Object.Type, with filters: [F])
    func reloadObjectsAsync(_ objects: [Object])
    func saveObjectsAsync(_ objects: [Object])
    func deleteObjectsAsync(_ objects: [Object])
}



protocol DataController {
    func loadObject<SD: SyncDataSource>(with id: ObjectID, from syncDataSource: SD) -> Identifiable?
    func loadObjects<SD: SyncDataSource>(with ids: [ObjectID], from syncDataSource: SD) -> [Identifiable]
    func loadObjects<SD: SyncDataSource, F: Filter>(with filters: [F], from syncDataSource: SD) -> [Object]
    func reloadObjects<Ob: Object, SD: SyncDataSource>(_ object: [Ob], from syncDataSource: SD) -> ReloadResult
    func saveObjects<Ob: Object, SD: SyncDataSource>(_ objects: [Ob], to syncDataSource: SD) -> SaveResult
    func deleteObjects<Ob: Object, SD: SyncDataSource>(_ objects: [Ob], from syncDataSource: SD) -> DeleteResult
}




protocol Filter {}


protocol Object {
    var controller: DataController { get }
}

protocol ObjectID {}

protocol Identifiable: Object {
    var objectID: ObjectID { get }
}


class Pet: Object {
    init(with controller: DataController) {
        self.controller = controller
    }
    
    var controller: DataController
}






