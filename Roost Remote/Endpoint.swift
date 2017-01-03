//
//  Endpoint.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/6/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit
import Eson

class Endpoint: NSObject {
    var name: String = ""
    var endpoint: String = ""
    var method: String = ""
    var options: EndpointOptionHolder?
    var json: NSDictionary!
    
    func execute(completion: ((Bool) -> Void)) {
        do {
            let jsonData: NSData? = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
            if let data: NSData = jsonData {
                let call: BaseNetworkCall = BaseNetworkCall()
                call.endpoint = self.endpoint
                call.httpMethod = self.method
                call.postData = data
                call.execute { (data, response, error) -> Void in
                    if let httpResponse = response {
                        completion(httpResponse.statusCode < 300)
                    }else{
                        completion(error == nil)
                    }
                }
            }
        }catch {
            completion(false)
        }
    }
}
