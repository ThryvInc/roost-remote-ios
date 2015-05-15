//
//  EndpointManager.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/4/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit
import Mantle

public class EndpointManager: NSObject {
    var endpoints: [Endpoint] = []
    
    public func fetchEndpoints(completion: ((NSError!) -> Void)){
        let baseNetworkCall: BaseNetworkCall = BaseNetworkCall()
        baseNetworkCall.httpMethod = "GET"
        baseNetworkCall.endpoint = "/index"
        baseNetworkCall.execute { (data, response, error) -> Void in
            var jsonError: NSError?
            let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError)
            var mantleError: NSError?
            self.endpoints = MTLJSONAdapter.modelsOfClass(Endpoint.self, fromJSONArray: json as! [AnyObject], error: &mantleError) as! [Endpoint]
            completion(mantleError)
        }
    }
}
