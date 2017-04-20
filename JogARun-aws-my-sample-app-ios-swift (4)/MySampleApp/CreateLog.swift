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
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var miles: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var pace: UILabel!
    @IBOutlet weak var shoe: UITextField!
    @IBOutlet weak var note: UITextView!
    
    
    @IBAction func submit(_ sender: UIButton) {
        //CHECK FIELDS
        let dateRegex = "^\\d{1,2}\\/\\d{1,2}\\/\\d{4}$"
        var regex = try! NSRegularExpression(pattern:dateRegex,options:[])
        var matches = regex.matches(in: date.text!, options: [], range: NSRange(location: 0, length: date.text!.characters.count))
        if(matches.isEmpty){
            UIAlertView(title: "Error: invalid Date",
                    message: "must be in form MM/DD/YYYY",
                    delegate: nil,
                    cancelButtonTitle: "Ok").show()
            return
        }
        let milesRegex = "[\\d]+[.]?[\\d]{0,2}"
        regex = try! NSRegularExpression(pattern:milesRegex,options:[])
        matches = regex.matches(in: miles.text!, options: [], range: NSRange(location: 0, length: miles.text!.characters.count))
        if(matches.isEmpty || matches.map{ (miles.text! as NSString).substring(with: $0.range) }[0] != miles.text!){
            UIAlertView(title: "Error: invalid Miles",
                        message: "must be number with maximum two decimal places",
                        delegate: nil,
                        cancelButtonTitle: "Ok").show()
            return
        }
        let timeRegex = "[\\d]+[:][\\d]{2}"
        regex = try! NSRegularExpression(pattern:timeRegex,options:[])
        matches = regex.matches(in: time.text!, options: [], range: NSRange(location: 0, length: time.text!.characters.count))
        if(matches.isEmpty || matches.map{ (time.text! as NSString).substring(with: $0.range) }[0] != time.text!){
            UIAlertView(title: "Error: invalid Time",
                        message: "must be of form min:sec",
                        delegate: nil,
                        cancelButtonTitle: "Ok").show()
            return
        }
        insertData()
    }
    
    func insertData() {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToCreate: Logs = Logs()
        
        print(Double(miles.text!)!)
        
        itemToCreate._userId = AWSIdentityManager.default().identityId!
        if(date.text?.characters.count == 9){
            date.text = "0" + date.text!
        }
        itemToCreate._date = date.text
        itemToCreate._notes = note.text
        itemToCreate._shoe = ["shoe1":"AsicsJ33"]
        itemToCreate._distance = NSNumber(value:Double(miles.text!)!)
        itemToCreate._time = NSNumber(value:Double((time.text?.replacingOccurrences(of: ":", with: "."))!)!)
        itemToCreate._timestamp = NSNumber(value: Date().timeIntervalSince1970)
        itemToCreate._title = titleField.text
        objectMapper.save(itemToCreate, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("Item saved.")
        })
    }
}
