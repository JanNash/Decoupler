//
//  DataSourceClients.swift
//  Decoupler
//
//  Created by Jan Nash on 9/4/17.
//  Copyright © 2017 JanNash. All rights reserved.
//


// MARK: // Public
// MARK: Protocol Declaration
protocol DataSourceClient {
    func shouldLoad(_ objects: [Object], from dataSource: DataSource) -> Bool
    func willLoad(_ objects: [Object], from dataSource: DataSource) -> Bool
    func shouldSave(_ objects: [Object], to dataSource: DataSource) -> Bool
    func willSave(_ objects: [Object], to dataSource: DataSource) -> Bool
    func shouldDelete(_ objects: [Object], from dataSource: DataSource) -> Bool
    func willDelete(_ objects: [Object], from dataSource: DataSource) -> Bool
}


// MARK: // Private
// MARK: - Collection
private extension Collection where Iterator.Element: DataSourceClient {
    func _shouldLoad(_ objects: [Object], from dataSource: DataSource) -> Bool  {
        return self.all(fulfill: { $0.shouldLoad(objects, from: dataSource) })
    }
    
    func _shouldSave(_ objects: [Object], to dataSource: DataSource) -> Bool {
        return self.all(fulfill: { $0.shouldSave(objects, to: dataSource) })
    }
    
    func _shouldDelete(_ objects: [Object], from dataSource: DataSource) -> Bool {
        return self.all(fulfill: { $0.shouldDelete(objects, from: dataSource) })
    }
}
