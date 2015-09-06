//
//  LocatorViewController.swift
//  OnTheMap
//
//  Created by Dx on 14/08/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit
import MapKit

class LocatorViewController: UIViewController {

    @IBOutlet weak var placeText: UITextField!
    
    var myActivityIndicator:UIActivityIndicatorView!
    
    var mkplacemark: MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addActivityIndicator()
    }
    
    @IBAction func placeFinderClick(sender: AnyObject) {
        
        var address = placeText.text
        var geocoder = CLGeocoder()
        
        self.myActivityIndicator.startAnimating()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            if let errorFound = error {
                dispatch_async(dispatch_get_main_queue()) {
                    self.myActivityIndicator.stopAnimating()
                    var alert = UIAlertController(title: "Geocode failed", message: "It was not possible to geocode the address. Try again", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                        // Do nothing
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                if let placemark = placemarks?[0] as? CLPlacemark {
                    self.mkplacemark = MKPlacemark(placemark: placemark)
                    dispatch_async(dispatch_get_main_queue()) {

                        let position = PositionEntity()
                        position.mapString = address
                        position.latitude = self.mkplacemark!.coordinate.latitude
                        position.longitude = self.mkplacemark!.coordinate.longitude
                        
                        (UIApplication.sharedApplication().delegate as! AppDelegate).position = position as PositionEntity
                        
                        self.myActivityIndicator.stopAnimating()
                        self.performSegueWithIdentifier("showURLScreen", sender: nil)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.myActivityIndicator.stopAnimating()
                        var alert = UIAlertController(title: "Geocode didn't found address", message: "The address was not found. Try again", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                            // Do nothing
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showURLScreen" {
            let destinationVC = segue.destinationViewController as! ShareURLViewController
            destinationVC.placemark = self.mkplacemark
        }
    }
    
    @IBAction func cancelClick(sender: AnyObject) {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addActivityIndicator() {
        self.myActivityIndicator = UIActivityIndicatorView(frame:CGRectMake(100, 100, 100, 100)) as UIActivityIndicatorView
        
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.myActivityIndicator.center = self.view.center
        
        self.view.addSubview(myActivityIndicator)
    }
}
