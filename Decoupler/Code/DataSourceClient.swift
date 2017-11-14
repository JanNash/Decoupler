//
//  DataSourceClients.swift
//  Decoupler
//
//  Created by Jan Nash on 9/4/17.
//  Copyright © 2017 JanNash. All rights reserved.
//

import SignificantSpices


// MARK: // Public
// MARK: Protocol Declaration
public protocol DataSourceClient {
    func shouldLoad(_ objects: [Object], from dataSource: SyncDataSource) -> Bool
    func willLoad(_ objects: [Object], from dataSource: SyncDataSource) -> Bool
    func shouldSave(_ objects: [Object], to dataSource: SyncDataSource) -> Bool
    func willSave(_ objects: [Object], to dataSource: SyncDataSource) -> Bool
    func shouldDelete(_ objects: [Object], from dataSource: SyncDataSource) -> Bool
    func willDelete(_ objects: [Object], from dataSource: SyncDataSource) -> Bool
}


// MARK: // Private
// MARK: - Collection Extension
private extension Collection where Iterator.Element: DataSourceClient {
    func _shouldLoad(_ objects: [Object], from dataSource: SyncDataSource) -> Bool  {
        return self.all(fulfill: { $0.shouldLoad(objects, from: dataSource) })
    }
    
    func _shouldSave(_ objects: [Object], to dataSource: SyncDataSource) -> Bool {
        return self.all(fulfill: { $0.shouldSave(objects, to: dataSource) })
    }
    
    func _shouldDelete(_ objects: [Object], from dataSource: SyncDataSource) -> Bool {
        return self.all(fulfill: { $0.shouldDelete(objects, from: dataSource) })
    }
}
