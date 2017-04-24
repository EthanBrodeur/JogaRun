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

class CreateLog:UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var miles: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var pace: UILabel!
    @IBOutlet weak var shoe: UILabel!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var shoePicker: UITableView!
    
    var logInfo: [Logs] = []
    var add: Bool = false
    var dateString: String = ""
    var myShoes: [Shoes] = []
    var wait = true
    var selectedShoe: Shoes = Shoes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shoePicker.dataSource = self
        shoePicker.delegate = self
    
        if(dateString != ""){
            date.text = dateString
        }
        navigationController?.delegate = self
        loadShoes()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(add){
            (viewController as? ViewIndivLog)?.logInfo.logStuff = logInfo // Here you pass the to your original view controller
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myShoes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexpath.row: \(indexPath.row) + \(myShoes.count)")
        if (indexPath.row < myShoes.count) {
            print("creating a shoe cell")
            let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            myCell.textLabel?.text = "\(myShoes[indexPath.row]._shoe!)\n\(myShoes[indexPath.row]._mileage!) mi."
            return myCell
        } else {
            print("Creating cell")
            let myCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TextInputTableViewCell
            myCell.textField.delegate = self
            myCell.textField?.text = ""
            return myCell
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToCreate: Shoes = Shoes()

        itemToCreate._userId = AWSIdentityManager.default().identityId!
        itemToCreate._shoe = textField.text
        itemToCreate._mileage = 0.0
        objectMapper.save(itemToCreate, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("Item saved.")
            DispatchQueue.main.async {
                self.loadShoes()
            }
        })
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row < myShoes.count) {
            shoe.text = "\(myShoes[indexPath.row]._shoe!)\n\(myShoes[indexPath.row]._mileage!) mi."
            selectedShoe = myShoes[indexPath.row]
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if shoe.text == "Shoe:\n[None]" {
            UIAlertView(title: "Please select a shoe",
                        message: "Please select above",
                        delegate: nil,
                        cancelButtonTitle: "Ok").show()
        }
        
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
        if(date.text?.characters.count == 9 || date.text?.characters.count == 8){
            date.text = "0" + date.text!
        }
        itemToCreate._date = date.text
        itemToCreate._notes = note.text
        itemToCreate._shoe = shoe.text
        itemToCreate._distance = NSNumber(value:Double(miles.text!)!)
        itemToCreate._time = NSNumber(value:Double((time.text?.replacingOccurrences(of: ":", with: "."))!)!)
        itemToCreate._timestamp = NSNumber(value: Date().timeIntervalSince1970)
        itemToCreate._title = titleField.text
        if(itemToCreate._title == ""){
            itemToCreate._title = " "
        }
        objectMapper.save(itemToCreate, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("Item saved.")
        })
        logInfo.append(itemToCreate)
        print(logInfo)
        updateShoes()
        
    }
    
    func loadShoes() {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId",]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.default().identityId!]
        
        objectMapper.query(Shoes.self, expression: queryExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                self.myShoes = paginatedOutput.items as! [Shoes]
                DispatchQueue.main.async {
                    self.shoePicker.reloadData()
                }
            }
            return nil
        })
    }
    
    func updateShoes() {
        let shoeToCreate: Shoes = Shoes()
        shoeToCreate._userId = AWSIdentityManager.default().identityId!
        shoeToCreate._shoe = shoe.text
        
        shoeToCreate._mileage = NSNumber(value: Double(selectedShoe._mileage!) + Double(self.miles.text!)!)
//        
////        var breaker = NSCharacterSet(charactersIn: "\n")
//        
        var array = shoe.text?.components(separatedBy: "\n")
        let result = array?[0]
//        guard shoeToCreate._shoe = result! else {
//            print("Something went wrong with shoes")
//            return
//        }
        print("RESULT: \(result!)")
//
        shoeToCreate._shoe = result!
//        let result2 = result!
//        print("RESULT2: \(result2)")
//        shoeToCreate._shoe = result
//        print("SHOE: \(shoeToCreate._shoe)")
//        
//////        let shoeRegex = ".*(\\n)"
////        print(shoeRegex)
////
////        let regex = try! NSRegularExpression(pattern:shoeRegex,options:[])
////        let matches = regex.matches(in: shoe.text!, options: [], range: NSRange(location: 0, length: shoe.text!.characters.count))
////        if(matches.isEmpty){
////            UIAlertView(title: "Error: invalid Date",
////                        message: "must be in form MM/DD/YYYY",
////                        delegate: nil,
////                        cancelButtonTitle: "Ok").show()
////            return
////        } else {
////            print("MATCHES: \(matches)")
////        }
////        let actualShoe = matches.map { NSString.substring(with: $0.range)}
////        
////        print("PRINTFUCKSHIT: \(actualShoe)")
////        shoeToCreate._shoe = actualShoe

        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let dynamoDB = AWSDynamoDB.default()
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId AND #shoe = :shoe"
        queryExpression.expressionAttributeNames = ["#userId": "userId", "#shoe": "shoe"]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.default().identityId!, ":shoe": shoe.text!]
        
        dynamoDB.updateItem(shoeToCreate, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("Shoe saved.")
        })

        
//        objectMapper.query(Shoes.self, expression: queryExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
//            if let error = task.error as? NSError {
//                print("The request failed. Error: \(error)")
//            } else if let paginatedOutput = task.result {
//                for shoe in paginatedOutput.items as! [Shoes] {
//                    
//                    print(shoe)
//                }
//                let shoes = paginatedOutput.items as! [Shoes]
//                if (shoes.count != 1) {
//                    print("Error: shoe does not exist, or there is more than 1 shoe with same name in database")
//                } else {
////                    shoeToCreate._mileage = NSNumber(value: Double(shoes[0]._mileage!) + Double(self.miles.text!)!)
//                    objectMapper.save(shoeToCreate, completionHandler: {(error: Error?) -> Void in
//                        if let error = error {
//                            print("Amazon DynamoDB Save Error: \(error)")
//                            return
//                        }
//                        print("Shoe saved.")
//                    })
//                }
//            }
//            return nil
//        })
        
    }
    
    @IBAction func milesChanged(_ sender: UITextField) {
        calculatePace()
    }
    
    @IBAction func timeChanged(_ sender: UITextField) {
        calculatePace()
    }
    
    func calculatePace() {
        let times = Double((self.time.text?.replacingOccurrences(of: ":", with: "."))!)
        let dist = Double(miles.text!)
        if times == nil || dist == nil{
            return
        }
       
        
        var sec = times! - Double(Int(times!))
        print(sec)
        sec = (times!-sec)*60 + sec*100
        
        print(sec)
        sec = sec/dist!
        print(sec)
        sec = sec/60
        print(sec)
        var ans = sec - Double(Int(sec))
        ans = sec-ans + ans*60/100
        
        ans = round(100*ans)/100
        var ansString = String(ans).replacingOccurrences(of: ".", with: ":")
        if ansString.characters.count == 3{
            ansString += "0"
        }
        pace.text = ansString
        
    }
}
