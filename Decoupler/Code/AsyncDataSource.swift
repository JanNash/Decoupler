//
//  AsyncDataSource.swift
//  Decoupler
//
//  Created by Jan Nash on 9/4/17.
//  Copyright © 2017 JanNash. All rights reserved.
//


protocol AsyncDataSource: DataSource {
    var clients: [AsyncDataSourceClient] { get }
    
    func loadObjectsAsync(withIDs ids: [ObjectID])
    func loadObjectsAsync(ofType type: Object.Type, with filters: [Filter])
    func reloadObjectsAsync(_ objects: [Object])
    func saveObjectsAsync(_ objects: [Object])
    func deleteObjectsAsync(_ objects: [Object])
}
