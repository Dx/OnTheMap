//
//  ViewController.swift
//  OnTheMap
//
//  Created by Dx on 21/07/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSuccess:", name: "loginSuccessNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginError:", name: "loginErrorNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginConnectionError:", name: "loginConnectionErrorNotification", object: nil)
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center;
        loginButton.delegate = self
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let fbToken = result {
        
            let udacityClient = UdacityAPIClient()
        
            udacityClient.loginWithFacebook(fbToken.token!.tokenString) { result, error in
                if error != nil {
                    var alert = UIAlertController(title: "Facebook login failed", message: "There was an error on Facebook login, try again", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                        // Do nothing
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    println("waiting for notification")
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }

    @IBAction func loginClic(sender: AnyObject) {
        
        let user = usernameText.text
        let pass = passwordText.text
        
        let model = UdacityAPIClient()
         model.createSession(user, parameterPassword:pass)
        
        
    }
    
    @objc func loginSuccess (notification: NSNotification) {
        
        if let session = notification.object as? UdacitySessionEntity {
            
            let udacityClient = UdacityAPIClient()
            udacityClient.getUserData(session.key!) { result, error in
                if let sessionResult = result {
                    session.lastName = sessionResult.lastName
                    session.firstName = sessionResult.firstName
                }
            }
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).session = session as UdacitySessionEntity
            
        }
        
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

