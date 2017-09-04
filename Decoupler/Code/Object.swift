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

