//
//  UserSearch.swift
//  MySampleApp
//
//  Created by Thomas Gales on 4/15/17.
//
//

import Foundation
import UIKit
import AWSCognitoIdentityProvider
import AWSDynamoDB
import AWSMobileHubHelper

class UserSearch: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var theTable: UITableView!
    
    var myUsers = [Users]()
    
    func getUsers() {
        
        let searchText = searchBar.text
        let searchLower = searchText?.lowercased()

        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        let scanExpression = AWSDynamoDBScanExpression()

        scanExpression.filterExpression = "begins_with(#username, :searchThis)"
        scanExpression.expressionAttributeNames = ["#username": "username",]
        
        scanExpression.expressionAttributeValues = [":searchThis": searchLower!,]
        
        objectMapper.scan(Users.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
                self.myUsers = [Users]()
            } else if let paginatedOutput = task.result {
                self.myUsers = paginatedOutput.items as! [Users]
                DispatchQueue.main.async {
                    self.theTable.reloadData()
                }
            }
            return nil
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        myCell.textLabel?.text = myUsers[indexPath.row]._username
        return myCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(myUsers[indexPath.row])
        let storyboard = UIStoryboard(name: "ViewLog", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewLog") as! ViewLog
        controller.myLog = false
        controller.uId = myUsers[indexPath.row]._userId!
        navigationController?.pushViewController(controller, animated: true)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        theTable.dataSource = self
        theTable.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getUsers()
    }
    
}
