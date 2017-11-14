//
//  Identifiable.swift
//  Decoupler
//
//  Created by Jan Nash on 9/4/17.
//  Copyright © 2017 JanNash. All rights reserved.
//


// MARK: // Public
// MARK: - ObjectID
public protocol ObjectID {}


// MARK: - Identifiable
public protocol Identifiable: Object {
    var objectID: ObjectID { get }
}
