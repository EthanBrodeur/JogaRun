//
//  CreateLog.swift
//  MySampleApp
//
//  Created by Thomas Gales on 4/7/17.
//
//

import UIKit
import Foundation
import AWSMobileHubHelper
import AWSDynamoDB

class CreateLog:UIViewController {
    
    @IBAction func WorkoutSubmitted(_ sender: UIButton) {
        insertData()
    }
    
    func insertData() {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToCreate: Logs = Logs()
        
        itemToCreate._userId = AWSIdentityManager.default().identityId!
        itemToCreate._notes = "note-2"
        itemToCreate._shoe = ["shoe1":"AsicsJ33"]
        itemToCreate._distance = 5.0
        itemToCreate._time = 36
        itemToCreate._timestamp = NSNumber(value: Date().timeIntervalSince1970)
        itemToCreate._title = "Test2 Title"
        objectMapper.save(itemToCreate, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("Item saved.")
        })
    }
}
