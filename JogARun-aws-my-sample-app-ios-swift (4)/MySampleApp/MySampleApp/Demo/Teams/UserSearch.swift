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

class UserSearch: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var theTable: UITableView!
    
    let myArray = ["Owen", "Matt", "Ethan"]
    
    func getUsers() -> [String] {
        
        //Credit to http://stackoverflow.com/questions/41364720/search-users-amazon-cognito-with-listusers-api-or-ios-sdk for starting point with this function
        // Make a AWSCognitoListUsers Request
        let getUsersRequest = AWSCognitoIdentityProviderListUsersRequest()
        
        // Add the Parameters
        getUsersRequest?.attributesToGet = ["username"]
        getUsersRequest?.limit = 10
        getUsersRequest?.userPoolId = AWSCognitoUserPoolId
//        print("pool: \(AWSCognitoIdentityProvider)")
        
//        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.USEast1, identityPoolId:"us-east-1:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx‌​xx")
        
        print("making request")
        // Make the Request
        AWSCognitoIdentityProvider(forKey: AWSCognitoUserPoolId).listUsers(getUsersRequest!, completionHandler: { (response, error) in
            print("hello")
            print("Response: \(response)")
            print("Error: \(error)")
            // The response variable contains the Cognito Response
            
        })
        print("got through")
        return myArray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        myCell.textLabel?.text = myArray[indexPath.row]
        myCell.imageView?.image = UIImage.init(named: "washu")
        return myCell
        
    }
    
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        theTable.dataSource = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("shit it worked")
        let users = getUsers()
        print(users)
    }
    
}
