//
//  ParseAPIClient.swift
//  OnTheMap
//
//  Created by Dx on 22/07/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import Foundation

class ParseAPIClient : NSObject {
    
    let baseURL = NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!
    

    func getLocationsFromParse(
        completionHandler: (points:[MapPointEntity]?, error: NSError?) -> Void) -> Void {

        let request = NSMutableURLRequest(URL: self.baseURL)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                let newError = NSError(domain: "ParseApi", code: 1, userInfo: nil)
                completionHandler(points: nil, error: newError)
            }
            else {
                var parsingError: NSError? = nil
                let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                var points = [MapPointEntity]()
                
                if let pointsArray = parsedResult["results"] as? [NSObject] {
                    for result in pointsArray {
                        if let resultDictionary = result as? [String : AnyObject] {
                            points.append(MapPointEntity(dictionary: resultDictionary))
                        }
                    }
                }
                
                completionHandler(points: points, error: nil)
            }

        }
        
        task.resume()
    }
}