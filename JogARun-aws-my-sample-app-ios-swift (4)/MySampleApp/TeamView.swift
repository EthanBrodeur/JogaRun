//
//  TeamView.swift
//  MySampleApp
//
//  Created by Matt Hibshman on 4/21/17.
//
//

import Foundation
import UIKit

class TeamView : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        tableview.delegate = self
        tableview.dataSource = self
        self.title = "Teams"
        tableview.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dateLabel.text = logInfo[indexPath.row]._date!
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamTableCell
        cell.teamLabel.text = "Team"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
