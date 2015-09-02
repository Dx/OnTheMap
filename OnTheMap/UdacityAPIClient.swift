//
//  UdacityAPIClient.swift
//  OnTheMap
//
//  Created by Dx on 21/07/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import Foundation

class UdacityAPIClient : NSObject {
    
    var udacitySession = UdacitySessionEntity()    
    
    func createSession (userName: String, parameterPassword: String, completionHandler: (user:UdacitySessionEntity?, error: NSError?) -> Void) {
        
        var url_ToFind = "https://www.udacity.com/api/session"        
        
        let url = NSURL(string: url_ToFind)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(parameterPassword)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                let newError = NSError(domain: "UdacityApi", code: 1, userInfo: nil)
                completionHandler(user: nil, error: newError)
            }
            if let unwrappedData = data {
                let dataMinus5 = unwrappedData.subdataWithRange(NSMakeRange(5, unwrappedData.length - 5))
                println(NSString(data: dataMinus5, encoding: NSUTF8StringEncoding))
                
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(dataMinus5, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let status = parsedResult["status"] as? Int {
                    if (status == 403) {
                        let newError = NSError(domain: "UdacityApi", code: 403, userInfo: nil)
                        completionHandler(user: nil, error: newError)
                    }
                }
                
                var keySession = ""
                var sessionId = ""
                var sessionExpiration = ""
                
                if let account = parsedResult["account"] as? NSDictionary {
                    if let keySessionUW = account["key"] as? String {
                        keySession = keySessionUW
                    }
                }
                
                if let session = parsedResult["session"] as? NSDictionary {
                    if let sessionIdUW = session["id"] as? String {
                        sessionId = sessionIdUW
                    }
                    if let sessionExpirationUW = session["expiration"] as? String {
                        sessionExpiration = sessionExpirationUW
                    }
                }
                
                let sessionObject = UdacitySessionEntity()
                sessionObject.key = keySession
                sessionObject.sessionId = sessionId
                sessionObject.expirationDate = sessionExpiration
                
                completionHandler(user: sessionObject, error: nil)
            }
        }
        
        task.resume()
    }
    
    func getUserData (userId: String, completionHandler: (user:UserData?, error: NSError?) -> Void) -> Void {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userId)")!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                let newError = NSError(domain: "UdacityApi", code: 1, userInfo: nil)
                completionHandler(user: nil, error: newError)
            }
            if let unwrappedData = data {
                let dataMinus5 = unwrappedData.subdataWithRange(NSMakeRange(5, unwrappedData.length - 5))
                println(NSString(data: dataMinus5, encoding: NSUTF8StringEncoding))
                
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(dataMinus5, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                let userData = UserData(firstNameP: "a", lastNameP: "b")
                
                if let user = parsedResult["user"] as? NSDictionary {
                    if let lastName = user["last_name"] as? String {
                        if let firstName = user["first_name"] as? String {
                            userData.firstName = firstName
                            userData.lastName = lastName
                        }
                    }
                }
                
                completionHandler(user: userData, error: nil)
            }
        }
        
        task.resume()
    }
    
    func loginWithFacebook(
            facebookMobile: String,
            completionHandler: (user:UdacitySessionEntity?, error: NSError?) -> Void) -> Void {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
                
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(facebookMobile)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                let newError = NSError(domain: "UdacityApi", code: 1, userInfo: nil)
                completionHandler(user: nil, error: newError)
            }
            if let unwrappedData = data {
                let dataMinus5 = unwrappedData.subdataWithRange(NSMakeRange(5, unwrappedData.length - 5))
                println(NSString(data: dataMinus5, encoding: NSUTF8StringEncoding))
                
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(dataMinus5, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let status = parsedResult["status"] as? Int {
                    if (status == 403) {
                        let newError = NSError(domain: "UdacityApi", code: 403, userInfo: nil)
                        completionHandler(user: nil, error: newError)
                    }
                }
                
                var keySession = ""
                var sessionId = ""
                var sessionExpiration = ""
                
                if let account = parsedResult["account"] as? NSDictionary {
                    if let keySessionUW = account["key"] as? String {
                        keySession = keySessionUW
                    }
                }
                
                if let session = parsedResult["session"] as? NSDictionary {
                    if let sessionIdUW = session["id"] as? String {
                        sessionId = sessionIdUW
                    }
                    if let sessionExpirationUW = session["expiration"] as? String {
                        sessionExpiration = sessionExpirationUW
                    }
                }
                
                let sessionObject = UdacitySessionEntity()
                sessionObject.key = keySession
                sessionObject.sessionId = sessionId
                sessionObject.expirationDate = sessionExpiration
                
                completionHandler(user: sessionObject, error: nil)
            }

        }
        task.resume()
    }
    
    func logout (
            completionHandler: (result:NSString?, error: NSError?) -> Void) -> Void {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                let newError = NSError(domain: "UdacityApi", code: 1, userInfo: nil)
                completionHandler(result: nil, error: newError)
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            let resultString = NSString(data: newData, encoding: NSUTF8StringEncoding)
            println(resultString)
            completionHandler(result: resultString, error: nil)
        }
        
        task.resume()
    }
}