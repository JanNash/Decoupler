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






protocol AsyncDataSourceClient: DataSourceClient {
    func didLoad(_ objects: [Object], from dataSource: AsyncDataSource)
    func didSave(_ objects: [Object], to dataSource: AsyncDataSource)
    func didDelete(_ objects: [Object], from dataSource: AsyncDataSource)
}





extension Collection where Iterator.Element: AsyncDataSourceClient {
    func didLoad(_ objects: [Object], from dataSource: AsyncDataSource) {
        self.forEach({ $0.didLoad(objects, from: dataSource) })
    }
    
    func didSave(_ objects: [Object], to dataSource: AsyncDataSource) {
        self.forEach({ $0.didSave(objects, to: dataSource) })
    }
    
    func didDelete(_ objects: [Object], from dataSource: AsyncDataSource) {
        self.forEach({ $0.didDelete(objects, from: dataSource) })
    }
}


enum SaveResult {
    enum SaveError: Error {
        case unknown
        case unauthorized
        case failedValidation
    }
    
    case success(objects: [Object])
    case failure(error: SaveError, objects: [Object])
}

enum ReloadResult {
    enum ReloadError: Error {
        case unknown
        case unauthorized
    }
    
    case success(objects: [Object])
    case failure(error: ReloadError, objects: [Object])
}

enum DeleteResult {
    enum DeleteError {
        case unknown
        case unauthorized
        case failedValidation
    }
    
    case success(objects: [Object])
    case failure(error: DeleteError, objects: [Object])
}


protocol DataSource {
    var clients: DataSourceClient { get }
}


protocol SyncDataSource: DataSource {
    func loadObjectsSync(withIDs ids: [ObjectID]) -> [Identifiable]
    func loadObjectsSync(ofType type: Object.Type, with filters: [Filter]) -> [Object]
    func reloadObjectsSync(_ objects: [Object]) -> ReloadResult
    func saveObjectsSync(_ objects: [Object]) -> SaveResult
    func deleteObjectsSync(_ objects: [Object]) -> DeleteResult
}

protocol AsyncDataSource: DataSource {
    var clients: [AsyncDataSourceClient] { get }
    
    func loadObjectsAsync(withIDs ids: [ObjectID])
    func loadObjectsAsync(ofType type: Object.Type, with filters: [Filter])
    func reloadObjectsAsync(_ objects: [Object])
    func saveObjectsAsync(_ objects: [Object])
    func deleteObjectsAsync(_ objects: [Object])
}



protocol DataController {
    func loadObject(with id: ObjectID, from syncDataSource: SyncDataSource) -> Identifiable?
    func loadObjects(with ids: [ObjectID], from syncDataSource: SyncDataSource) -> [Identifiable]
    func loadObjects(with filters: [Filter], from syncDataSource: SyncDataSource) -> [Object]
    func reloadObjects(_ object: [Object], from syncDataSource: SyncDataSource) -> ReloadResult
    func saveObjects(_ objects: [Object], to syncDataSource: SyncDataSource) -> SaveResult
    func deleteObjects(_ objects: [Object], from syncDataSource: SyncDataSource) -> DeleteResult
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






