//
//  EndpointManager.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/4/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit
import Eson

public class EndpointManager: NSObject {
    var endpoints: [Endpoint] = []
    
    public func fetchEndpoints(completion: ((NSError?) -> Void)){
        let baseNetworkCall: BaseNetworkCall = BaseNetworkCall()
        baseNetworkCall.httpMethod = "GET"
        baseNetworkCall.endpoint = "/index"
        baseNetworkCall.execute { (data, response, netError) -> Void in
            if netError == nil {
                do {
                    let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                    self.endpoints = Eson().fromJsonArray(json as? [[String: AnyObject]], clazz: Endpoint.self)!
                    completion(nil)
                }catch let error as NSError{
                    completion(error)
                }
            }else{
                completion(netError)
            }
        }
    }
}
