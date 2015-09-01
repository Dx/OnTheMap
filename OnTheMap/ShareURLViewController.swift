//
//  ShareURLViewController.swift
//  OnTheMap
//
//  Created by Dx on 14/08/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit

class ShareURLViewController: UIViewController {

    @IBOutlet weak var urlText: UITextField!
    
    override func viewDidLoad() {
        
        var toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        let height = toolbar.frame.size.height
        let viewBounds = self.parentViewController!.view.bounds
        let viewHeight = CGRectGetHeight(viewBounds)
        let viewWidth = CGRectGetWidth(viewBounds)
        let rectArea = CGRectMake(0, 20, viewWidth, height)
        
        toolbar.frame = rectArea
        
        var space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var logoutButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelClick")
        logoutButton.tintColor = UIColor.orangeColor()
        
        var buttons = [space, logoutButton]
        
        toolbar.setItems(buttons, animated: true)
        
        self.navigationController?.view.addSubview(toolbar)
    }
    
    @IBAction func shareUrlClick(sender: AnyObject) {
        
        if self.validateURL(urlText.text) {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            
            if appDelegate.alreadyHasPosition {
                puttingPosition()
            } else {
                postingPosition()
            }
        } else {
            self.showURLNotValid()
        }
    }
    
    func showURLNotValid() {
        var alert = UIAlertController(title: "Url validation", message: "Not a valid URL. It has to be like http://www.udacity.com", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func validateURL(url: String) -> Bool {
        
        let regexString = "^http://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"
        
        let options :NSStringCompareOptions = .RegularExpressionSearch | .CaseInsensitiveSearch
        
        if let range = url.rangeOfString(regexString, options:options) {
            let validUrl = url.substringWithRange(range)
            println("validUrl: \(validUrl)")
            return true
        }
        else {
            print("Not valid url")
            return false
        }
    }
    
    func postingPosition() {
        let parseClient = ParseAPIClient()
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        parseClient.postingLocation(appDelegate.session!, mediaURL: urlText.text, mapString: appDelegate.position!.mapString!, latitude: appDelegate.position!.latitude!, longitude: appDelegate.position!.longitude!) { result, error in
            if let error = error {
                println("Error trying to get student locations")
            } else {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func puttingPosition() {
        let parseClient = ParseAPIClient()
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        parseClient.puttingLocation(appDelegate.lastUserMapPoint!.objectId, session: appDelegate.session!, mediaURL: urlText.text, mapString: appDelegate.position!.mapString!, latitude: appDelegate.position!.latitude!, longitude: appDelegate.position!.longitude!) { result, error in
            if let error = error {
                println("Error trying to get student locations")
            } else {
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                NSNotificationCenter.defaultCenter().postNotificationName("askForRefresh", object: nil)
            }
        }
    }
    
    func cancelClick() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
