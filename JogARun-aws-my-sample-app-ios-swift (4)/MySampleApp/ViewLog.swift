//
//  ViewLog.swift
//  MySampleApp
//
//  Created by Thomas Gales on 4/7/17.
//
//

import UIKit
import Foundation
import AWSMobileHubHelper
import AWSDynamoDB

class ViewLog: UIViewController {
    
    @IBOutlet weak var logViewLabel: UILabel!
    
    @IBAction func dataRequested(_ sender: UIButton) {
        loadData()
    }
    
    func loadData() {
        let objectMapper = AWSDynamoDBObjectMapper.default()
                
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId",]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.default().identityId!,]
        
        objectMapper.query(Logs.self, expression: queryExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for log in paginatedOutput.items as! [Logs] {
                    self.logViewLabel.text?.append("\(log)") //Why doesn't this work??
                    print(log)
                }
            }
            return nil
        })
        
        
        
    }
}
