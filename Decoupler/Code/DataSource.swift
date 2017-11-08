//
//  DataSource.swift
//  Decoupler
//
//  Created by Jan Nash on 9/4/17.
//  Copyright © 2017 JanNash. All rights reserved.
//


// MARK: // Public
// MARK: Protocol Declaration
/*
 A DataSource is supposed to:
 - provide data-records on request
 
 It could also (but does not have to):
 - save changed records
 - delete records
 
 It should not:
 - map the data between different representations
 - change the data
 - cache the data (since a cache is a datasource itself)
 
 Records can be requested in two different ways:
 - by ID
 - by filtering
 
 A client passes either:
 - a single ID
 - a set of IDs
 - one or more filters
 and receives a Result ???
 
 This can happen either synchronously or asynchronously.
 (though that's out of the scope of this abstract protocol)
 
 A DataSource can have multiple clients.
 */
protocol DataSource {
    var clients: DataSourceClient { get }
}
