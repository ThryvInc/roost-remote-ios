//
//  BaseNetworkCall.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/6/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit

class BaseNetworkCall: NSObject {
    let hostName: String = "192.168.0.133:8081"
    let scheme: String = "http"
    let apiVersion: String = "/api/v1"
    var endpoint: String!
    var httpMethod: String!
    var postData: NSData?
    
    func execute(completion: ((NSData!, NSHTTPURLResponse!, NSError!) -> Void)){
        var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var request = NSMutableURLRequest(URL: NSURL(scheme: scheme, host: hostName, path: apiVersion + endpoint)!)
        request.HTTPMethod = httpMethod;
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        if let data = postData where httpMethod != "GET" {
            request.HTTPBody = data
        }
        
        session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            completion(data, response as? NSHTTPURLResponse, error)
        }).resume();
    }
}
