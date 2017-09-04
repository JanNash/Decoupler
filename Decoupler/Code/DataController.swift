//
//  DataController.swift
//  Decoupler
//
//  Created by Jan Nash on 9/4/17.
//  Copyright © 2017 JanNash. All rights reserved.
//


// MARK: // Public
// MARK: Result Enums
// MARK: - SaveResult
enum SaveResult {
    enum SaveError: Error {
        case unknown
        case unauthorized
        case failedValidation
    }
    
    case success(objects: [Object])
    case failure(error: SaveError, objects: [Object])
}


// MARK: - ReloadResult
enum ReloadResult {
    enum ReloadError: Error {
        case unknown
        case unauthorized
    }
    
    case success(objects: [Object])
    case failure(error: ReloadError, objects: [Object])
}


// MARK: - DeleteResult
enum DeleteResult {
    enum DeleteError {
        case unknown
        case unauthorized
        case failedValidation
    }
    
    case success(objects: [Object])
    case failure(error: DeleteError, objects: [Object])
}


// MARK: - DataController
// MARK: Protocol Declaration
protocol DataController {
    func loadObject(with id: ObjectID, from syncDataSource: SyncDataSource) -> Identifiable?
    func loadObjects(with ids: [ObjectID], from syncDataSource: SyncDataSource) -> [Identifiable]
    func loadObjects(with filters: [Filter], from syncDataSource: SyncDataSource) -> [Object]
    func reloadObjects(_ object: [Object], from syncDataSource: SyncDataSource) -> ReloadResult
    func saveObjects(_ objects: [Object], to syncDataSource: SyncDataSource) -> SaveResult
    func deleteObjects(_ objects: [Object], from syncDataSource: SyncDataSource) -> DeleteResult
}
