//
//  ShareURLViewController.swift
//  OnTheMap
//
//  Created by Dx on 14/08/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit
import MapKit

class ShareURLViewController: UIViewController {

    @IBOutlet weak var urlText: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var myActivityIndicator:UIActivityIndicatorView!
    
    var placemark: MKPlacemark?
    
    override func viewDidLoad() {
        
        setToolbar()
        
        addActivityIndicator()
        
        setPlacemark()
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
    
    func setPlacemark() {
        if let placemark = placemark {
            self.mapView.addAnnotation(placemark)
            
            let center = CLLocationCoordinate2D(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func setToolbar() {
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
    
    func addActivityIndicator() {
        self.myActivityIndicator = UIActivityIndicatorView(frame:CGRectMake(100, 100, 100, 100)) as UIActivityIndicatorView
        
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.myActivityIndicator.center = self.view.center
        
        self.view.addSubview(myActivityIndicator)
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
        
        self.myActivityIndicator.startAnimating()
        parseClient.postingLocation(appDelegate.session!, mediaURL: urlText.text, mapString: appDelegate.position!.mapString!, latitude: appDelegate.position!.latitude!, longitude: appDelegate.position!.longitude!) { result, error in
            if error != nil {
                println("Error posting position")
                dispatch_async(dispatch_get_main_queue()) {
                    self.myActivityIndicator.stopAnimating()
                    var alert = UIAlertController(title: "Posting position failed", message: "There was an error posting the url and location, try again", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                        // Do nothing
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.myActivityIndicator.stopAnimating()

                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName("askForRefresh", object: nil)
                }
            }
        }
    }
    
    func puttingPosition() {
        let parseClient = ParseAPIClient()
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        self.myActivityIndicator.startAnimating()
        parseClient.puttingLocation(appDelegate.lastUserMapPoint!.objectId, session: appDelegate.session!, mediaURL: urlText.text, mapString: appDelegate.position!.mapString!, latitude: appDelegate.position!.latitude!, longitude: appDelegate.position!.longitude!) { result, error in
            if error != nil {
                println("Error putting position")
                dispatch_async(dispatch_get_main_queue()) {
                    self.myActivityIndicator.stopAnimating()
                    var alert = UIAlertController(title: "Posting position failed", message: "There was an error posting the url and location, try again", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                        // Do nothing
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.myActivityIndicator.stopAnimating()
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName("askForRefresh", object: nil)
                }
            }
        }
    }
    
    func cancelClick() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
