//
//  SyncDataSource.swift
//  Decoupler
//
//  Created by Jan Nash on 9/4/17.
//  Copyright © 2017 JanNash. All rights reserved.
//


// MARK: // Public
// MARK: Protocol Declaration
protocol SyncDataSource: AbstractDataSource {
    func loadObjectsSync(withIDs ids: [ObjectID]) -> [Identifiable]
    func loadObjectsSync(ofType type: Object.Type, with filters: [Filter]) -> [Object]
    func reloadObjectsSync(_ objects: [Object]) -> ReloadResult
    func saveObjectsSync(_ objects: [Object]) -> SaveResult
    func deleteObjectsSync(_ objects: [Object]) -> DeleteResult
}
