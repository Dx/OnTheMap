//
//  UdacitySessionEntity.swift
//  OnTheMap
//
//  Created by Dx on 08/08/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import Foundation

class UdacitySessionEntity {
    
    var key : String
    var sessionId : String
    var expirationDate : String
    
    init(keyP: String, sessionIdP: String, expirationDateP: String)
    {
        self.key = keyP
        self.sessionId = sessionIdP
        self.expirationDate = expirationDateP
    }
    
//    func parseDate(expirationDate : String) -> NSDate
//    {
//        var dateFmt = NSDateFormatter()
//        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
//        dateFmt.dateFormat = "yyyy-MM-ddTHH:mm:ss.SS"
//        if let parsedDate = dateFmt.dateFromString(expirationDate) {
//            return parsedDate
//        } else {
//            return NSDate.new()
//        }
//    }
}