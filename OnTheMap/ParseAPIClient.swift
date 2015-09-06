//
//  ParseAPIClient.swift
//  OnTheMap
//
//  Created by Dx on 22/07/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import Foundation

class ParseAPIClient : NSObject {
    
    let baseURL = "https://api.parse.com/1/classes/StudentLocation"    

    func getLocationsFromParse(
        completionHandler: (points:[MapPointEntity]?, error: NSError?) -> Void) -> Void {

        let parameters = "?limit=1000&order=-updatedAt"
        let url = NSURL(string:baseURL + parameters)
        let request = NSMutableURLRequest(URL: url!)
            
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                let newError = NSError(domain: "ParseApi", code: 1, userInfo: nil)
                completionHandler(points: nil, error: newError)
            } else {
                var parsingError: NSError? = nil
                let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if parsingError != nil {
                    completionHandler(points: nil, error: parsingError)
                } else {
                
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

        }
        
        task.resume()
    }
    
    func getStudentLocationFromParse(key: String,
        completionHandler: (point:MapPointEntity?, error: NSError?) -> Void) -> Void {
            
            let parameters = "?where={\"uniqueKey\":\"\(key)\"}"
            let completeurl = "\(baseURL)\(parameters)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let url = NSURL(string:completeurl!)!
            let request = NSMutableURLRequest(URL: url)
            
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error...
                    let newError = NSError(domain: "ParseApi", code: 1, userInfo: nil)
                    completionHandler(point: nil, error: newError)
                } else {
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
                    
                    if points.count > 0 {
                        completionHandler(point: points[0], error: nil)
                    }
                    else {
                        completionHandler(point: nil, error: nil)
                    }
                }
            }
            
            task.resume()
    }
    
    func postingLocation (session: UdacitySessionEntity, mediaURL: String, mapString: String, latitude: Double, longitude: Double,completionHandler: (result: String?, error: NSError?) -> Void) -> Void {
        
        let url = NSURL(string:baseURL)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = "{\"uniqueKey\": \"\(session.key!)\", \"firstName\": \"\(session.firstName!)\", \"lastName\": \"\(session.lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\":\(latitude), \"longitude\":\(longitude)}"
        
        request.HTTPBody = json.dataUsingEncoding(NSUTF8StringEncoding)
        
        println(json)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                let newError = NSError(domain: "ParseApi", code: 1, userInfo: nil)
                completionHandler(result: nil, error: newError)
            } else {
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
                completionHandler(result: "Success!", error: nil)
            }
        }
        
        task.resume()
        
    }
    
    func puttingLocation (objectId:String, session: UdacitySessionEntity, mediaURL: String, mapString: String, latitude: Double, longitude: Double,completionHandler: (result: String?, error: NSError?) -> Void) -> Void {
        
        let parameters = "/\(objectId)"
        let url = NSURL(string:baseURL + parameters)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "PUT"
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = "{\"uniqueKey\": \"\(session.key!)\", \"firstName\": \"\(session.firstName!)\", \"lastName\": \"\(session.lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\":\(latitude), \"longitude\":\(longitude)}"
        
        request.HTTPBody = json.dataUsingEncoding(NSUTF8StringEncoding)
        
        println(json)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                let newError = NSError(domain: "ParseApi", code: 1, userInfo: nil)
                completionHandler(result: nil, error: newError)
            } else {
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
                completionHandler(result: "Success!", error: nil)
            }
        }
        
        task.resume()
        
    }
}