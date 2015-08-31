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
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func placeFinderClick(sender: AnyObject) {
        
        var address = placeText.text
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                let mkplacemark = MKPlacemark(placemark: placemark)
                self.mapView.addAnnotation(mkplacemark)
                
                let center = CLLocationCoordinate2D(latitude: mkplacemark.coordinate.latitude, longitude: mkplacemark.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                self.mapView.setRegion(region, animated: true)
                
                let position = PositionEntity()
                position.mapString = address
                position.latitude = mkplacemark.coordinate.latitude
                position.longitude = mkplacemark.coordinate.longitude
                
                (UIApplication.sharedApplication().delegate as! AppDelegate).position = position as PositionEntity
                
                self.nextButton.enabled = true
            }
        })
    }
    
    @IBAction func cancelClick(sender: AnyObject) {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func clickNext(sender: AnyObject) {

        self.performSegueWithIdentifier("showURLScreen", sender: nil)
//        self.navigationController?.pushViewController(ShareURLViewController(), animated: true)

    }
}
