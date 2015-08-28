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
    
    @IBAction func cancelClick(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func shareUrlClick(sender: AnyObject) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        let parseClient = ParseAPIClient()
        parseClient.postingLocation(appDelegate.session!, mediaURL: urlText.text, mapString: appDelegate.position!.mapString!, latitude: appDelegate.position!.latitude!, longitude: appDelegate.position!.longitude!) { result, error in
            if let error = error {
                println("Error trying to get student locations")
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
