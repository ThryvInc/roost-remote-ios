//
//  DeviceDescription.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit
import Eson

class DeviceDescription: NSObject {
    var name: String?
    var host: String?
    var device: Device?
    
    open func fetchEndpoints(_ completion: @escaping ((NSError?) -> Void)){
        let baseNetworkCall: BaseNetworkCall = BaseNetworkCall()
        baseNetworkCall.hostName = host!
        baseNetworkCall.httpMethod = "GET"
        baseNetworkCall.namespace = "api/v1"
        baseNetworkCall.endpoint = "/index"
        baseNetworkCall.execute { (data, response, netError) -> Void in
            if netError == nil {
                do {
//                    let string = String(data: data!, encoding: String.Encoding.utf8)
//                    print(string)
                    let json: AnyObject? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject?
                    let eson = Eson()
                    eson.deserializers.append(EndpointOptionHolderDeserializer())
                    eson.deserializers.append(EndpointArrayDeserializer())
                    eson.deserializers.append(EndpointOptionDeserializer())
                    self.device = eson.fromJsonDictionary(json as? [String: AnyObject], clazz: Device.self)!
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
