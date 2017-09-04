//
//  AsyncDataSourceClient.swift
//  Decoupler
//
//  Created by Jan Nash on 9/4/17.
//  Copyright © 2017 JanNash. All rights reserved.
//


// MARK: // Public
// MARK: Protocol Declaration
protocol AsyncDataSourceClient: DataSourceClient {
    func didLoad(_ objects: [Object], from dataSource: AsyncDataSource)
    func didSave(_ objects: [Object], to dataSource: AsyncDataSource)
    func didDelete(_ objects: [Object], from dataSource: AsyncDataSource)
}


// MARK: // Private
// MARK: - Collection Extension
private extension Collection where Iterator.Element: AsyncDataSourceClient {
    func _didLoad(_ objects: [Object], from dataSource: AsyncDataSource) {
        self.forEach({ $0.didLoad(objects, from: dataSource) })
    }
    
    func _didSave(_ objects: [Object], to dataSource: AsyncDataSource) {
        self.forEach({ $0.didSave(objects, to: dataSource) })
    }
    
    func _didDelete(_ objects: [Object], from dataSource: AsyncDataSource) {
        self.forEach({ $0.didDelete(objects, from: dataSource) })
    }
}
