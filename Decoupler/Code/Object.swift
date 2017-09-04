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

