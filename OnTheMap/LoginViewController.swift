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
    
    var myActivityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginFBButton = FBSDKLoginButton()
        loginFBButton.center = self.view.center;
        loginFBButton.delegate = self
        self.view.addSubview(loginFBButton)
        
        addActivityIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClic(sender: AnyObject) {
        
        let user = usernameText.text
        let pass = passwordText.text
        
        let model = UdacityAPIClient()
        self.myActivityIndicator.startAnimating()
        model.createSession(user, parameterPassword:pass) { result, error in
            if let errorReturned = error {
                if errorReturned.code == 403 {
                    println("Error 403 trying to login")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.myActivityIndicator.stopAnimating()
                        var alert = UIAlertController(title: "Udacity login failed", message: "There was an error on Udacity login, try again", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                            // Do nothing
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                } else {
                    println("Error in communications trying to login to Udacity")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.myActivityIndicator.stopAnimating()
                        var alertUdacity = UIAlertController(title: "Udacity login failed", message: "There was an error connecting Udacity, try again", preferredStyle: UIAlertControllerStyle.Alert)
                         alertUdacity.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                            // Do nothing
                         }))
                         self.presentViewController(alertUdacity, animated: true, completion: nil)
                    }
                }
            } else {
                
                model.getUserData(result!.key!) { resultUserData, error in
                    if let errorReturned = error {
                    } else {
                        result?.firstName = resultUserData?.firstName
                        result?.lastName = resultUserData?.lastName
                    }
                    (UIApplication.sharedApplication().delegate as! AppDelegate).session = result! as UdacitySessionEntity
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.myActivityIndicator.stopAnimating()
                    self.performSegueWithIdentifier("showTabController", sender: nil)
                }
            }
        }
    }
    
    func addActivityIndicator() {
        self.myActivityIndicator = UIActivityIndicatorView(frame:CGRectMake(100, 100, 100, 100)) as UIActivityIndicatorView
        
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.myActivityIndicator.center = self.view.center
        
        self.view.addSubview(myActivityIndicator)
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let fbToken = result {
        
            let udacityClient = UdacityAPIClient()
        
            self.myActivityIndicator.startAnimating()
            udacityClient.loginWithFacebook(fbToken.token!.tokenString) { result, error in
                if let errorReturned = error {
                    if errorReturned.code == 403 {
                        println("Error 403 trying to login")
                        dispatch_async(dispatch_get_main_queue()) {
                            self.myActivityIndicator.stopAnimating()
                            var alert = UIAlertController(title: "Facebook login failed", message: "There was an error on Facebook login, try again", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                                // Do nothing
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    } else {
                        println("Error in communications trying to login to Facebook")
                        dispatch_async(dispatch_get_main_queue()) {
                            self.myActivityIndicator.stopAnimating()
                            var alert = UIAlertController(title: "Facebook login failed", message: "There was an error connecting Facebook, try again", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                                // Do nothing
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    
                    udacityClient.getUserData(result!.key!) { resultUserData, error in
                        if let errorReturned = error {
                        } else {
                            result?.firstName = resultUserData?.firstName
                            result?.lastName = resultUserData?.lastName
                        }
                        (UIApplication.sharedApplication().delegate as! AppDelegate).session = result! as UdacitySessionEntity
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.myActivityIndicator.stopAnimating()
                        self.performSegueWithIdentifier("showTabController", sender: nil)
                    }
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
}

