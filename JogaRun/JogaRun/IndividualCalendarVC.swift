//
//  IndividualCalendarVC.swift
//  JogaRun
//
//  Created by Labuser on 4/4/17.
//  Copyright © 2017 Taylor. All rights reserved.
//

import UIKit

class IndividualCalendarVC: UIViewController {
    let defaults = UserDefaults.standard
    var thisUser: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Step 1: Who's calendar is this?
        //If we are segueing to this VC from a team calendar, we should pass the 'other user' as part of the segue, probably as a user ID, then query MySQL to get info about that user.
        //However if there is no segue information, let's default to the session user.
        let segueUser: Int? = nil //update once segues are in place to this page from teamCal
        if segueUser == nil {
            thisUser = defaults.object(forKey: "Username") as? String
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
