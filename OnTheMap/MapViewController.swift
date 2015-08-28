//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Dx on 21/07/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var points = [MapPointEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    func refresh() {
        let parseClient = ParseAPIClient()
        parseClient.getLocationsFromParse() { result, error in
            if let error = error {
                println("Error trying to get student locations")
            }
            else {
                self.points = result!
                
                self.reloadPins()
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        self.reloadPins()
    }
    
    @IBAction func addClick(sender: AnyObject) {

        confirmToAdd()
    }
    
    @IBAction func refreshClick(sender: AnyObject) {
        refresh()
    }
    
    func confirmToAdd() {
        let parseClient = ParseAPIClient()
        
        let userKey = (UIApplication.sharedApplication().delegate as! AppDelegate).session!.key!
        
        parseClient.getStudentLocationFromParse(userKey, completionHandler: { result, error in
            if let error = error {
                self.performSegueWithIdentifier("showAddLocation", sender: self)
            } else {
                if let point = result {
                    var alert = UIAlertController(title: "Location found for \(point.firstName) \(point.lastName)", message: "Would you like to update your data?", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                        self.performSegueWithIdentifier("showAddLocation", sender: self)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        })
    }


    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            let url = NSURL(string: annotationView.annotation.subtitle!)
            if url != nil{
                app.openURL(url!)
            }
        }
    }
    
    private func reloadPins() {
        var annotations = [MKPointAnnotation]()
        
        for point in self.points {
            var annotation = MKPointAnnotation()
            let lat = CLLocationDegrees(point.latitude)
            let long = CLLocationDegrees(point.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.coordinate = coordinate
            annotation.title = "\(point.firstName) \(point.lastName)"
            annotation.subtitle = point.mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
