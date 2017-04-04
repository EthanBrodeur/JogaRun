//
//  ViewController.swift
//  JogaRun
//
//  Created by Labuser on 4/4/17.
//  Copyright © 2017 Taylor. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBAction func loginPress(_ sender: UIButton) {
        defaults.set(usernameField.text, forKey: "Username")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

