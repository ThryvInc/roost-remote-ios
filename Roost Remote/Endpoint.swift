//
//  Endpoint.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/6/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit

class Endpoint: Decodable {
    var name: String = ""
    var endpoint: String = ""
    var method: String = ""
    var options: EndpointOptionHolder?
    
    func execute(device: Device, description: ServerDescription, option: EndpointOption, _ completion: @escaping ((Bool) -> Void)) {
        let netCall = call(from: device, description: description, endpoint: self, option: option)
        netCall.execute { (data, response, error) -> Void in
            if let httpResponse = response {
                completion(httpResponse.statusCode < 300)
            } else {
                completion(error == nil)
            }
        }
    }
    
    func execute(host: String, namespace: String, option: EndpointOption, _ completion: @escaping ((Bool) -> Void)) {
        if let data: Data = optionData(for: option) {
            Roost_Remote.execute(host: host, namespace: namespace, endpoint: self.endpoint, method: self.method, data: data, completion)
        }
    }
    
    func optionData(for option: EndpointOption) -> Data? {
        var json = [self.options!.key : option.endpointOption()]
        if let staticValues = self.options?.staticValues {
            for value in staticValues {
                json[value.name] = value.endpointOption()
            }
        }
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        return jsonData
    }
}

func call(from device: Device, description: ServerDescription, endpoint: Endpoint, option: EndpointOption) -> BaseNetworkCall {
    return call(from: device.host!, namespace: description.hostNamespace!, endpoint: endpoint.endpoint, method: endpoint.method, data: endpoint.optionData(for: option))
}

func call(from host: String, namespace: String, endpoint: String, method: String, data: Data?) -> BaseNetworkCall {
    let call: BaseNetworkCall = BaseNetworkCall()
    call.hostName = host
    call.namespace = namespace
    call.endpoint = endpoint
    call.httpMethod = method
    call.postData = data
    return call
}

func execute(host: String, namespace: String, endpoint: String, method: String, data: Data?, _ completion: @escaping ((Bool) -> Void)) {
    let netCall = call(from: host, namespace: namespace, endpoint: endpoint, method: method, data: data)
    netCall.execute { (data, response, error) -> Void in
        if let httpResponse = response {
            completion(httpResponse.statusCode < 300)
        }else{
            completion(error == nil)
        }
    }
}
