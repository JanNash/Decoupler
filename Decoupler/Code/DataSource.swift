//
//  DataSource.swift
//  Decoupler
//
//  Created by Jan Nash on 9/4/17.
//  Copyright © 2017 JanNash. All rights reserved.
//


// MARK: // Public
// MARK: Protocol Declaration
/**
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
 
 A client passes:
 - a single ID to request a single, identifiable record
 - a set of IDs to request multiple, identifiable records
 - a number of filters and sort descriptors to request
   multiple identifiable or unidentifiable recordes
 
 Since the functions that implement the retrieval can be
 implemented synchronously as well as asynchronously,
 there are two subprotocols of this protocol,
 SyncDataSource and AsyncDataSource, each of which
 also use their own refined client-protocol versions.
 
 A DataSource can have multiple clients.
 */
protocol DataSource {
    var clients: DataSourceClient { get }
}
