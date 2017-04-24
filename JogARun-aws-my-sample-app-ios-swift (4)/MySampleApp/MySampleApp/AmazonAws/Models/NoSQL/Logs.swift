//
//  Logs.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.12
//

import Foundation
import UIKit
import AWSDynamoDB

class Logs: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _timestamp: NSNumber?
    var _date: String?
    var _distance: NSNumber?
    var _notes: String?
    var _shoe: String?
    var _time: NSNumber?
    var _title: String?
    
    class func dynamoDBTableName() -> String {

        return "jogarun-mobilehub-2062646821-Logs"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_timestamp"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_timestamp" : "Timestamp",
               "_date" : "Date",
               "_distance" : "Distance",
               "_notes" : "Notes",
               "_shoe" : "Shoe",
               "_time" : "Time",
               "_title" : "Title",
        ]
    }
}
