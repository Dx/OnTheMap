//
//  ViewController.swift
//  OnTheMap
//
//  Created by Dx on 21/07/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSuccess:", name: "loginSuccessNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginError:", name: "loginErrorNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginConnectionError:", name: "loginConnectionErrorNotification", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginClic(sender: AnyObject) {
        
        let user = usernameText.text
        let pass = passwordText.text
        
        let model = UdacityAPIClient()
         model.createSession(user, parameterPassword:pass)
        
        
    }
    
    @objc func loginSuccess (notification: NSNotification) {
        performSegueWithIdentifier("showTabController", sender: self)
    }
    
    @objc func loginError (notification: NSNotification) {
        var alert = UIAlertController()
        
        let alertViewController = UIAlertController(title: "Login", message: "The user or password are invalid, try again", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // do nothing
        }
        
        alertViewController.addAction(okAction)
        
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    @objc func loginConnectionError (notification: NSNotification) {
        var alert = UIAlertController()
        
        let alertViewController = UIAlertController(title: "Login", message: "There was an error in connection, try again", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // do nothing
        }
        
        alertViewController.addAction(okAction)
        
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }
}

