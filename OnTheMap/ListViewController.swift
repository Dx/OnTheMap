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
        
        pointsTable.delegate = self
        
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

}
