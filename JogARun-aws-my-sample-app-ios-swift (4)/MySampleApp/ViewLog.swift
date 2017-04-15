//
//  ViewLog.swift
//  MySampleApp
//
//  Created by Thomas Gales on 4/7/17.
//
//

import UIKit
import Foundation
import AWSMobileHubHelper
import AWSDynamoDB

class ViewLog: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var calendar: UICollectionView!
    @IBOutlet weak var month: UILabel!
    
    var calendarObj = Calendar.current
    
    var currentMonth: Int = 0
    var currentYear: Int = 0
    var firstDay: Int = 0
    var refDate: Date = Date()
    var leapYear: Int = 28
    
    
    override func viewDidAppear(_ animated: Bool) {
        calendar.dataSource = self
        calendar.delegate = self
        currentMonth = calendarObj.component(.month, from: Date())
        currentYear = calendarObj.component(.year, from: refDate)
        let start = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: refDate)))!
        print(start)
        firstDay = calendarObj.component(.weekday, from: start)
        print(firstDay)
        
        //Stupid February leap year rules
        if(currentYear%4 == 0){
            if (currentYear%100 == 0) {
                leapYear = 29
            }
            else if (currentYear%400 == 0){
                leapYear = 28
            }
            else {
                leapYear = 29
            }
        }
        
        setMonth()
        calendar.reloadData()
    }
    
    func checkLeapYearRules() {
        if(currentYear%4 == 0){
            if (currentYear%100 == 0) {
                leapYear = 29
            }
            else if (currentYear%400 == 0){
                leapYear = 28
            }
            else {
                leapYear = 29
            }
        }
    }
    
    @IBAction func prevMonth(_ sender: UIButton) {
        currentMonth -= 1
        if(currentMonth == 0){
            currentMonth = 12
            currentYear -= 1
            checkLeapYearRules()
        }
        
        refDate = refDate.addingTimeInterval(-2339200)
        let start = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: refDate)))!
        print(start)
        firstDay = calendarObj.component(.weekday, from: start)
        print(firstDay)
        setMonth()
        calendar.reloadData()
    }
    
    
    @IBAction func nextMonth(_ sender: UIButton) {
        currentMonth += 1
        if(currentMonth == 13){
            currentMonth = 1
            currentYear += 1
            checkLeapYearRules()
        }
        refDate = refDate.addingTimeInterval(2339200)
        let start = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: refDate)))!
        print(start)
        firstDay = calendarObj.component(.weekday, from: start)
        print(firstDay)
        setMonth()
        calendar.reloadData()
    }
    
    func setMonth() {
        switch currentMonth{
        case 1:
            month.text = "January " + String(currentYear)
        case 2:
            month.text = "February " + String(currentYear)
        case 3:
            month.text = "March " + String(currentYear)
        case 4:
            month.text = "April " + String(currentYear)
        case 5:
            month.text = "May " + String(currentYear)
        case 6:
            month.text = "June " + String(currentYear)
        case 7:
            month.text = "July " + String(currentYear)
        case 8:
            month.text = "August " + String(currentYear)
        case 9:
            month.text = "September " + String(currentYear)
        case 10:
            month.text = "October " + String(currentYear)
        case 11:
            month.text = "November " + String(currentYear)
        case 12:
            month.text = "December " + String(currentYear)
        default:
            break
        }
    }
    
    func thirtyDays() -> Bool{
        if(currentMonth == 4 || currentMonth == 6 || currentMonth == 9 || currentMonth == 11){
            return true
        }
        return false
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: CustomCollectionCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionCell
        
        if(indexPath.section == 0 && indexPath.row+1 < firstDay){
            cell.label.text = ""
            cell.timeLabel.text = ""
            cell.milesLabel.text = ""
            cell.miles.text = ""
            cell.time.text = ""
            cell.backgroundColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
            return cell
        }
        if(((indexPath.section)*7+indexPath.row+1) - firstDay+1 > leapYear && currentMonth == 2){
            cell.label.text = ""
            cell.timeLabel.text = ""
            cell.milesLabel.text = ""
            cell.miles.text = ""
            cell.time.text = ""
            cell.backgroundColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
            return cell
        }
        if(((indexPath.section)*7+indexPath.row+1) - firstDay+1 > 30 && thirtyDays()){
            cell.label.text = ""
            cell.timeLabel.text = ""
            cell.milesLabel.text = ""
            cell.miles.text = ""
            cell.time.text = ""
            cell.backgroundColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
            return cell
        }
        if(((indexPath.section)*7+indexPath.row+1) - firstDay+1 > 31){
            cell.label.text = ""
            cell.timeLabel.text = ""
            cell.milesLabel.text = ""
            cell.miles.text = ""
            cell.time.text = ""
            cell.backgroundColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
            return cell
        }
        cell.timeLabel.text = "Time:"
        cell.milesLabel.text = "Miles:"
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.label.text = String(((indexPath.section)*7+indexPath.row+1) - firstDay+1)
        cell.miles.text = String(((indexPath.section)*7+indexPath.row+1) - firstDay+1)
        cell.time.text = String(((indexPath.section)*7+indexPath.row+1) - firstDay+1)
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView:UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let cellTouched = indexPath.section + indexPath.row
        print(cellTouched)
    }
    
    @IBAction func dataRequested(_ sender: UIButton) {
        loadData()
    }
    
    func loadData() {
        let objectMapper = AWSDynamoDBObjectMapper.default()
                
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId",]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.default().identityId!,]
        
        objectMapper.query(Logs.self, expression: queryExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                for log in paginatedOutput.items as! [Logs] {
                    
                    print(log)
                }
            }
            return nil
        })
    }
    
    
    
    
}
