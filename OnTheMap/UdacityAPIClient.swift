//
//  UdacityAPIClient.swift
//  OnTheMap
//
//  Created by Dx on 21/07/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import Foundation

class UdacityAPIClient : NSObject {
    func createSession (userName: String, password: String) {
        
        var url_ToFind = "https://www.udacity.com/api/session"        
        
        let url = NSURL(string: url_ToFind)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
        }
        
        task.resume()
    }
}