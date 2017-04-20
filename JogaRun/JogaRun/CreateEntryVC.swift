//
//  CreateEntryVC.swift
//  JogaRun
//
//  Created by Labuser on 4/4/17.
//  Copyright © 2017 Taylor. All rights reserved.
//

import UIKit

class CreateEntryVC: UIViewController {

    @IBOutlet weak var hello: UILabel!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let username = defaults.object(forKey: "Username")
        hello.text = "Welcome, \(username as? String) !"
        
        
        // Do any additional setup after loading the view.
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
