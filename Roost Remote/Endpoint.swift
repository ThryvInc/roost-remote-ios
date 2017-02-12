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
    
    func execute(host: String, namespace: String, option: EndpointOption, _ completion: @escaping ((Bool) -> Void)) {
        do {
            var json = [self.options!.name : option.endpointOption()]
            if let staticValues = self.options?.staticValues {
                for value in staticValues {
                    json[value.name] = value.endpointOption()
                }
            }
            let jsonData: Data? = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let data: Data = jsonData {
//                let string = String(data: data, encoding: String.Encoding.utf8)
//                print(string!)
                let call: BaseNetworkCall = BaseNetworkCall()
                call.hostName = host
                call.namespace = namespace
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
