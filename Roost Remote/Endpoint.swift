//
//  Endpoint.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/6/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit
import Mantle

class Endpoint: MTLModel, MTLJSONSerializing {
    var name: String = ""
    var endpoint: String = ""
    var method: String = ""
    var options: EndpointOptionHolder!
    var json: NSDictionary!
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return ["name":"name", "endpoint":"endpoint", "method":"method", "options":"options"]
    }
    
    class func JSONTransformerForKey(key: String!) -> NSValueTransformer! {
        if key == "options" {
            return MTLJSONAdapter.dictionaryTransformerWithModelClass(EndpointOptionHolder)
        }
        
        return nil
    }
    
    func execute(completion: ((Bool) -> Void)) {
        var error: NSError?
        let jsonData: NSData? = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
        if let jsonError = error {
            completion(false)
        }else if let data: NSData = jsonData {
            let call: BaseNetworkCall = BaseNetworkCall()
            call.endpoint = self.endpoint
            call.httpMethod = self.method
            call.postData = data
            call.execute { (data, response, error) -> Void in
                if let httpResponse = response {
                    completion(response.statusCode < 300)
                }else{
                    completion(error == nil)
                }
            }
        }
    }
}
