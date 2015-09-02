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
        
        let loginFBButton = FBSDKLoginButton()
        loginFBButton.center = self.view.center;
        loginFBButton.delegate = self
        self.view.addSubview(loginFBButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClic(sender: AnyObject) {
        
        let user = usernameText.text
        let pass = passwordText.text
        
        let model = UdacityAPIClient()
        model.createSession(user, parameterPassword:pass) { result, error in
            if let errorReturned = error {
                if errorReturned.code == 403 {
                    println("Error 403 trying to login")
                    dispatch_async(dispatch_get_main_queue()) {
                        var alert = UIAlertController(title: "Udacity login failed", message: "There was an error on Udacity login, try again", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                            // Do nothing
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                } else {
                    println("Error in communications trying to login to Udacity")
                    dispatch_async(dispatch_get_main_queue()) {
                        var alertUdacity = UIAlertController(title: "Udacity login failed", message: "There was an error connecting Udacity, try again", preferredStyle: UIAlertControllerStyle.Alert)
                        alertUdacity.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                            // Do nothing
                        }))
                        self.presentViewController(alertUdacity, animated: true, completion: nil)
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("showTabController", sender: nil)
                }
            }
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let fbToken = result {
        
            let udacityClient = UdacityAPIClient()
        
            udacityClient.loginWithFacebook(fbToken.token!.tokenString) { result, error in
                if let errorReturned = error {
                    if errorReturned.code == 403 {
                        println("Error 403 trying to login")
                        dispatch_async(dispatch_get_main_queue()) {
                            var alert = UIAlertController(title: "Facebook login failed", message: "There was an error on Facebook login, try again", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                                // Do nothing
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    } else {
                        println("Error in communications trying to login to Facebook")
                        dispatch_async(dispatch_get_main_queue()) {
                            var alert = UIAlertController(title: "Facebook login failed", message: "There was an error connecting Facebook, try again", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                                // Do nothing
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("showTabController", sender: nil)
                    }
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
}

