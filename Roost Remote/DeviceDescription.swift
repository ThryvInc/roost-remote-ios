//
//  DeviceDescription.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit
import ThryvUXComponents
import FunkyNetwork

class DeviceDescription: NSObject {
    var name: String?
    var host: String?
    var device: Device?
    var call: JsonNetworkCall?
    
    open func fetchEndpoints(_ completion: @escaping ((NSError?) -> Void)){
        if let typeId = device?.deviceTypeId {
            fetchType(by: typeId, completion)
        } else {
            fetchFromDescriber(completion)
        }
    }
    
    func fetchType(by typeId: String, _ completion: @escaping ((NSError?) -> Void)) {
        let config = RRServerConfig.current
        call = THUXAuthenticatedNetworkCall(configuration: config, httpMethod: "GET", httpHeaders: [:], endpoint: "device_types/" + typeId, postData: nil, stubHolder: nil)
        call?.dataSignal.skipNil().map(parseIndexDevice).skipNil().observeValues { (device) in
            self.device?.hostNamespace = device.hostNamespace
            self.device?.endpoints = device.endpoints
            completion(nil)
        }
        call?.errorSignal.observeValues { (error) in
            completion(error)
        }
        call?.serverErrorSignal.observeValues { (error) in
            completion(error)
        }
        call?.fire()
    }
    
    func fetchFromDescriber(_ completion: @escaping ((NSError?) -> Void)) {
        let config = ServerConfiguration(shouldStub: false, scheme: "http", host: host!, apiRoute: "api/v1")
        call = JsonNetworkCall(configuration: config, httpMethod: "GET", endpoint: "index", postData: nil)
        call?.dataSignal.skipNil().map(parseIndexDevice).skipNil().observeValues { (device) in
            self.device = device
            completion(nil)
        }
        call?.errorSignal.observeValues { (error) in
            completion(error)
        }
        call?.serverErrorSignal.observeValues { (error) in
            completion(error)
        }
        call?.fire()
    }
}

func parseIndexDevice(data: Data) -> Device? {
    do {
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            print("String: " + string)
        }
        let decoder = JSONDecoder()
        let result = try decoder.decode(Device.self, from: data)
        return result
    } catch {
        print("\(error)")
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            print("String: " + string)
        }
        return nil
    }
}
