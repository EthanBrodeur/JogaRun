//
//  ViewIndivLog.swift
//  MySampleApp
//
//  Created by Matt Hibshman on 4/11/17.
//
//

import Foundation
import UIKit

class ViewIndivLog: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var logInfo: [Logs] = []
    @IBOutlet weak var dateLabel: UILabel!
    var dateString: String = ""
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dateLabel.text = dateString
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    @IBAction func addLog(_ sender: UIButton) {
        
        let loginStoryboard = UIStoryboard(name: "CreateLog", bundle: nil)
        let loginController = loginStoryboard.instantiateViewController(withIdentifier: "CreateLog")
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dateLabel.text = logInfo[indexPath.row]._date!
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!CustomTableCell
        cell.miles.text = "Miles: " + String(describing: logInfo[indexPath.row]._distance!)
        cell.title.text = "Title: " + String(describing: logInfo[indexPath.row]._title!)
        cell.time.text = "Time: " + String(describing: logInfo[indexPath.row]._time!)
        //cell.shoe.text = "Shoe: " + String(describing: logInfo[indexPath.row]._shoe!["shoe" + String(indexPath.row)]!)
        cell.note.text = String(describing: logInfo[indexPath.row]._notes!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return logInfo.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
