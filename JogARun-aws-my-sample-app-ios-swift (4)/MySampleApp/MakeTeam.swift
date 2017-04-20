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
        
        //Credit to http://stackoverflow.com/questions/41364720/search-users-amazon-cognito-with-listusers-api-or-ios-sdk for starting point with this function
        // Make a AWSCognitoListUsers Request
        let getUsersRequest = AWSCognitoIdentityProviderListUsersRequest()
        
        // Add the Parameters
        //we will also want to grab the id here i think so we can keep track of id's on this new team
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
