//
//  ViewTeam.swift
//  MySampleApp
//
//  Created by Thomas Gales on 4/21/17.
//
//

import Foundation
import UIKit
import AWSMobileHubHelper
import AWSDynamoDB

class ViewTeam: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var teams: [Teams] = []
    var team: String = ""
    var wait: Bool = true
    
    @IBOutlet weak var teamList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dbQuery()
        teamList.dataSource = self
        teamList.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text =  String(describing: teams[indexPath.row]._username!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teams.count
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(teams[indexPath.row])
        let storyboard = UIStoryboard(name: "ViewLog", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewLog") as! ViewLog
        controller.myLog = false
        controller.uId = teams[indexPath.row]._userId!
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func dbQuery() {
        teams.removeAll()
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "#team = :team"
        scanExpression.expressionAttributeNames = ["#team": "team",]
        scanExpression.expressionAttributeValues = [":team": self.team,]
        wait = true
        objectMapper.scan(Teams.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for team in paginatedOutput.items as! [Teams] {
                    self.teams.append(team)
                    DispatchQueue.main.async {
                        self.teamList.reloadData()
                        
                    }
                }
                self.wait = false
            }
            return nil
        })
    }
    
}
