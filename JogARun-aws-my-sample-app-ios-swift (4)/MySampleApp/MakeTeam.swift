//
//  MakeTeam.swift
//  MySampleApp
//
//  Created by Labuser on 4/20/17.
//
//

import UIKit
import AWSMobileHubHelper
import AWSDynamoDB
import AWSCognitoIdentityProvider


class MakeTeam: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var usersTable: UITableView!
    @IBOutlet weak var search: UISearchBar!
    var usersArray = ["Owen", "Matt", "Ethan"]
    
    //ulimately i think these should be user ID's instead of usernames but
    var usersToAdd: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTable.dataSource = self
        usersTable.delegate = self
        getUsers()
        usersTable.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submit(_ sender: UIButton) {
    }
    
    func getUsers() -> [String] {
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "begins_with(username = :username)"
        queryExpression.expressionAttributeNames = ["#userId": "userId",]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.default().identityId!,]
        objectMapper.query(Users.self, expression: queryExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                print("Request worked")
                for user in paginatedOutput.items as! [Users] {
                    print(user)
                }
                print("Printed users")
            }
            return nil
        })
        return usersArray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        myCell.textLabel?.text = usersArray[indexPath.row]
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        usersToAdd.append(usersArray[indexPath.row])
        
        //some visual cue that this user was added to the team
        usersTable.cellForRow(at: indexPath)?.backgroundColor = UIColor.green
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
