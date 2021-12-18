//
//  DeviceDescription.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit
import LUX
import FunNet
import Combine

class DeviceDescriber: NSObject {
    var name: String?
    var host: String?
    var device: Device?
    var call: CombineNetCall?
    private var cancelBag = Set<AnyCancellable?>()
    
    open func fetchEndpoints(_ completion: @escaping ((NSError?) -> Void)){
        if let typeId = device?.deviceTypeId {
            fetchType(by: typeId, completion)
        } else {
            fetchFromDescriber(completion)
        }
    }
    
    func fetchType(by typeId: String, _ completion: @escaping ((NSError?) -> Void)) {
        call = getDeviceTypesCall(by: typeId)
        let modelPub: AnyPublisher<Device, Never> = modelPublisher(from: call!.responder!.$data.eraseToAnyPublisher())
        cancelBag.insert(modelPub.sink { device in
            self.device?.hostNamespace = device.hostNamespace
            self.device?.endpoints = device.endpoints
            completion(nil)
        })
        cancelBag.insert(call?.responder?.$error.compactMap { $0 }.sink {
            completion($0)
        })
        cancelBag.insert(call?.responder?.$serverError.compactMap { $0 }.sink {
            completion($0)
        })
        call?.fire()
    }
    
    func fetchFromDescriber(_ completion: @escaping ((NSError?) -> Void)) {
        let config = ServerConfiguration(shouldStub: false, scheme: "http", host: host!, apiRoute: device?.hostNamespace ?? "api/v1")
        call = localCall(config)
        let modelPub: AnyPublisher<Device, Never> = modelPublisher(from: call!.responder!.$data.eraseToAnyPublisher())
        cancelBag.insert(modelPub.sink { device in
            self.device = device
            completion(nil)
        })
        cancelBag.insert(call?.responder?.$error.compactMap { $0 }.sink {
            completion($0)
        })
        cancelBag.insert(call?.responder?.$serverError.compactMap { $0 }.sink {
            completion($0)
        })
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
