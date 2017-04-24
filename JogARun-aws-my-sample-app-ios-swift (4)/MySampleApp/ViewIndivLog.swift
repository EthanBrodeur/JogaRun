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
    var logInfo: LogHolder = LogHolder()
    @IBOutlet weak var dateLabel: UILabel!
    var dateString: String = ""
    var myLog = true
    
    @IBOutlet weak var createButton: UIButton!
    override func viewDidLoad() {
        if(!myLog){
            createButton.isEnabled = false
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dateLabel.text = dateString
        tableView.dataSource = self
        tableView.delegate = self
        print(logInfo)
        tableView.reloadData()
    }
    
    @IBAction func addLog(_ sender: UIButton) {
        let loginStoryboard = UIStoryboard(name: "CreateLog", bundle: nil)
        let loginController = loginStoryboard.instantiateViewController(withIdentifier: "CreateLog") as! CreateLog
        loginController.logInfo = logInfo.logStuff
        loginController.add = true
        loginController.dateString = self.dateString
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dateLabel.text = logInfo[indexPath.row]._date!
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!CustomTableCell
        cell.miles.text = "Miles: " + String(describing: logInfo.logStuff[indexPath.row]._distance!)
        cell.title.text = "Title: " + String(describing: logInfo.logStuff[indexPath.row]._title!)
        cell.time.text = "Time: " + String(describing: logInfo.logStuff[indexPath.row]._time!)
        cell.shoe.text = "Shoe: " + String(describing: logInfo.logStuff[indexPath.row]._shoe!)
        cell.note.text = String(describing: logInfo.logStuff[indexPath.row]._notes!)
        cell.pace.text = "Pace: " + calculatePace(time: logInfo.logStuff[indexPath.row]._time as! Double, miles: logInfo.logStuff[indexPath.row]._distance as! Double)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return logInfo.logStuff.count
        
    }
    
    func calculatePace(time: Double, miles: Double) -> String {
        let times = time
        print(time)
        let dist = miles
        print(miles)
        
        
        var sec = times - Double(Int(times))
        print(sec)
        sec = (times-sec)*60 + sec*100
        
        print(sec)
        sec = sec/dist
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
        return ansString
        
    }

    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

class LogHolder {
    var logStuff: [Logs] = []
}
