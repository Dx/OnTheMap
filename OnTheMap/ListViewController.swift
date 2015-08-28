//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Dx on 21/07/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    @IBOutlet weak var pointsTable: UITableView!
    
    var points: [MapPointEntity]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        let height = toolbar.frame.size.height
        let viewBounds = self.parentViewController!.view.bounds
        let viewHeight = CGRectGetHeight(viewBounds)
        let viewWidth = CGRectGetWidth(viewBounds)
        let rectArea = CGRectMake(0, 20, viewWidth, height)
        
        toolbar.frame = rectArea
        
        var logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        var addButton = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "add")
        var refreshButton = UIBarButtonItem(title: "Ref", style: .Plain, target: self, action: "refresh")
        var space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        var buttons = [logoutButton, space, addButton, refreshButton]
        
        toolbar.setItems(buttons, animated: true)
        
        self.navigationController!.view.addSubview(toolbar)
        
        pointsTable.delegate = self
        
        refresh()
    }
    
    func refresh() {
        let parseClient = ParseAPIClient()
        parseClient.getLocationsFromParse() { result, error in
            if let error = error {
                println("Error trying to get student locations")
            }
            else {
                
                let resultSorted = result?.sorted({ (pin1, pin2) -> Bool in
                    let pin1C = pin1 as MapPointEntity
                    let pin2C = pin2 as MapPointEntity
                    
                    return pin1C.updatedAt > pin2C.updatedAt
                })
                
                self.points = resultSorted
                
                self.pointsTable.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell";
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
        if let firstName = points[indexPath.row].firstName as String! {
            if let secondName = points[indexPath.row].lastName as String! {
                cell.textLabel!.text = firstName + secondName
            }
        }
        
        if let address = points[indexPath.row].mapString as String! {
            cell.detailTextLabel!.text = address
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let counting = points {
            return counting.count
        } else {
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let selectedItem = points[indexPath.row]
        app.openURL(NSURL(string: selectedItem.mediaURL)!)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func add() {
        let parseClient = ParseAPIClient()
        
        let userKey = (UIApplication.sharedApplication().delegate as! AppDelegate).session!.key!
        
        parseClient.getStudentLocationFromParse(userKey, completionHandler: { result, error in
            if let error = error {
                self.performSegueWithIdentifier("showLocationFromTable", sender: self)
            } else {
                if let point = result {
                    var alert = UIAlertController(title: "Location found for \(point.firstName) \(point.lastName)", message: "Would you like to update your data?", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                        self.performSegueWithIdentifier("showLocationFromTable", sender: self)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        })
    }

}
