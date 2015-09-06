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
    
    var myActivityIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        pointsTable.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "askForRefresh:", name: "askForRefresh", object: nil)
        
        setUI()
        refresh()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell";
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
        if let firstName = points[indexPath.row].firstName as String! {
            if let secondName = points[indexPath.row].lastName as String! {
                cell.textLabel!.text = firstName + " " + secondName
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
    
    func addActivityIndicator() {
        self.myActivityIndicator = UIActivityIndicatorView(frame:CGRectMake(100, 100, 100, 100)) as UIActivityIndicatorView
        
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.myActivityIndicator.center = self.view.center
        
        self.view.addSubview(myActivityIndicator)
    }
    
    func setUI() {
        var toolbar = UIToolbar()
        toolbar.tintColor = UIColor.orangeColor()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        let height = toolbar.frame.size.height
        let viewBounds = self.parentViewController!.view.bounds
        let viewHeight = CGRectGetHeight(viewBounds)
        let viewWidth = CGRectGetWidth(viewBounds)
        let rectArea = CGRectMake(0, 20, viewWidth, height)
        
        toolbar.frame = rectArea
        
        var logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        logoutButton.image = UIImage(named: "Logout")
        var addButton = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "add")
        addButton.image = UIImage(named: "New")
        var refreshButton = UIBarButtonItem(title: "Ref", style: .Plain, target: self, action: "refresh")
        refreshButton.image = UIImage(named: "Refresh")
        var space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        var buttons = [logoutButton, space, addButton, refreshButton]
        
        toolbar.setItems(buttons, animated: true)
        
        self.navigationController!.view.addSubview(toolbar)
    }
    
    func logout() {
        let udacityClient = UdacityAPIClient()
        
        udacityClient.logout() { result, error in
            if error != nil {
                println("Could not logout")
            }
            else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    func askForRefresh (notification: NSNotification) {
        refresh()
    }
    
    func refresh() {
        
        let parseClient = ParseAPIClient()
        parseClient.getLocationsFromParse() { result, error in
            if let error = error {
                if error.code == 1 {
                    dispatch_async(dispatch_get_main_queue(), {
                        var alert = UIAlertController(title: "Connection failed", message: "There was an error on connecting to Parse API, try again", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                            // Do nothing
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        var alert = UIAlertController(title: "Data error", message: "There was an error on data. Try again", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                            // Do nothing
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            }
            else {
                
                let resultSorted = result?.sorted({ (pin1, pin2) -> Bool in
                    let pin1C = pin1 as MapPointEntity
                    let pin2C = pin2 as MapPointEntity
                    
                    return pin1C.updatedAt > pin2C.updatedAt
                })
                
                self.points = resultSorted
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func add() {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        if appDelegate.alreadyHasPosition {
            showAlertToUpdatePosition()
        } else {
            let parseClient = ParseAPIClient()
            
            let userKey = (UIApplication.sharedApplication().delegate as! AppDelegate).session!.key!
            
            self.myActivityIndicator.startAnimating()
            parseClient.getStudentLocationFromParse(userKey, completionHandler: { result, error in
                if let error = error {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.myActivityIndicator.stopAnimating()
                        self.performSegueWithIdentifier("showLocationFromTable", sender: self)
                    })
                } else {
                    if let point = result {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.myActivityIndicator.stopAnimating()
                            (UIApplication.sharedApplication().delegate as! AppDelegate).lastUserMapPoint = point
                            (UIApplication.sharedApplication().delegate as! AppDelegate).alreadyHasPosition = true
                            self.showAlertToUpdatePosition()
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.myActivityIndicator.stopAnimating()
                            self.performSegueWithIdentifier("showLocationFromTable", sender: self)
                        })
                    }
                }
            })
        }
    }
    
    func showAlertToUpdatePosition() {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        var alert = UIAlertController(title: "Location found for \(appDelegate.lastUserMapPoint!.firstName) \(appDelegate.lastUserMapPoint!.lastName)", message: "Would you like to update your data?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("showLocationFromTable", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
