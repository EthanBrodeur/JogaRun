//
//  MainViewController.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.12
//

import UIKit
import AWSMobileHubHelper

class MainViewController: UITableViewController {

    var demoFeatures: [DemoFeature] = []
    var signInObserver: AnyObject!
    var signOutObserver: AnyObject!
    fileprivate let loginButton: UIBarButtonItem = UIBarButtonItem(title: nil, style: .done, target: nil, action: nil)
    
    // MARK: - View lifecycle
    
    func checkLogAndUpdate() {
        demoFeatures = []

        if !(AWSIdentityManager.default().isLoggedIn) {
            let demoFeature = DemoFeature.init(
                name: NSLocalizedString("Search",
                                        comment: "Label for demo menu option."),
                detail: NSLocalizedString("Search for Another User",
                                          comment: "Description for demo menu option."),
                icon: "UserIdentityIcon", storyboard: "UserSearch")
            demoFeatures.append(demoFeature)
        }
        else {
            var demoFeature = DemoFeature.init(
                name: NSLocalizedString("Create Log",
                                        comment: "Label for demo menu option."),
                detail: NSLocalizedString("Create a new workout",
                                          comment: "Description for demo menu option."),
                icon: "UserIdentityIcon", storyboard: "CreateLog")
            
            demoFeatures.append(demoFeature)
            
            demoFeature = DemoFeature.init(
                name: NSLocalizedString("View Log",
                                        comment: "Label for demo menu option."),
                detail: NSLocalizedString("View your logs",
                                          comment: "Description for demo menu option."),
                icon: "NoSQLIcon", storyboard: "ViewLog")
            
            demoFeatures.append(demoFeature)
            
            demoFeature = DemoFeature.init(
                name: NSLocalizedString("Manage Teams",
                                        comment: "Label for demo menu option."),
                detail: NSLocalizedString("Create and view Team Pages",
                                          comment: "Description for demo menu option."),
                icon: "NoSQLIcon", storyboard: "TeamEntry")
            
            demoFeatures.append(demoFeature)
            
            demoFeature = DemoFeature.init(
                name: NSLocalizedString("Search",
                                        comment: "Label for demo menu option."),
                detail: NSLocalizedString("Search for Another User",
                                          comment: "Description for demo menu option."),
                icon: "UserIdentityIcon", storyboard: "UserSearch")
            demoFeatures.append(demoFeature)
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        
        
        // Default theme settings.
        navigationController!.navigationBar.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController!.navigationBar.barTintColor = UIColor(red: 0xF5/255.0, green: 0x85/255.0, blue: 0x35/255.0, alpha: 1.0)
        navigationController!.navigationBar.tintColor = UIColor.white
        
        
        signInObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AWSIdentityManagerDidSignIn, object: AWSIdentityManager.default(), queue: OperationQueue.main, using: {[weak self] (note: Notification) -> Void in
            guard let strongSelf = self else { return }
            print("Sign In Observer observed sign in.")
            
            strongSelf.setupRightBarButtonItem()
        })
        
        signOutObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AWSIdentityManagerDidSignOut, object: AWSIdentityManager.default(), queue: OperationQueue.main, using: {[weak self](note: Notification) -> Void in
            guard let strongSelf = self else { return }

            print("Sign Out Observer observed sign out.")
            strongSelf.setupRightBarButtonItem()
        })
        
        setupRightBarButtonItem()
        checkLogAndUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLogAndUpdate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(signInObserver)
        NotificationCenter.default.removeObserver(signOutObserver)
    }
    
    func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = loginButton
        navigationItem.rightBarButtonItem!.target = self
        
        if (AWSIdentityManager.default().isLoggedIn) {
            navigationItem.rightBarButtonItem!.title = NSLocalizedString("Sign-Out", comment: "Label for the logout button.")
            navigationItem.rightBarButtonItem!.action = #selector(MainViewController.handleLogout)
        }
        if !(AWSIdentityManager.default().isLoggedIn) {
            navigationItem.rightBarButtonItem!.title = NSLocalizedString("Sign-In", comment: "Label for the login button.")
            navigationItem.rightBarButtonItem!.action = #selector(goToLogin)
        }
    }
    
    // MARK: - UITableViewController delegates
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell")!
        let demoFeature = demoFeatures[indexPath.row]
        cell.imageView!.image = UIImage(named: demoFeature.icon)
        cell.textLabel!.text = demoFeature.displayName
        cell.detailTextLabel!.text = demoFeature.detailText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoFeatures.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let demoFeature = demoFeatures[indexPath.row]
        let storyboard = UIStoryboard(name: demoFeature.storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: demoFeature.storyboard)
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    
    func goToLogin() {
        print("Handling optional sign-in.")
        let loginStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
        let loginController = loginStoryboard.instantiateViewController(withIdentifier: "SignIn")
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    func handleLogout() {
        if (AWSIdentityManager.default().isLoggedIn) {
            
            AWSIdentityManager.default().logout(completionHandler: {(result: Any?, error: Error?) in
                self.navigationController!.popToRootViewController(animated: false)
                self.setupRightBarButtonItem()
                self.checkLogAndUpdate()
            })
            
        } else {
            assert(false)
        }
    }
}

class FeatureDescriptionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Back", style: .plain, target: nil, action: nil)
    }
}
