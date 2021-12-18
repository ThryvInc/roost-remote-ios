//
//  Task.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 12/31/19.
//  Copyright © 2019 Elliot Schrock. All rights reserved.
//

import Foundation

protocol Task {
    var name: String { get }
    var index: Int { get set }
    
    func execute(_ callback: @escaping () -> Void)// {}
}

final class FlowTask: Task {
    let name: String
    var index: Int = Int.max
    let flowName: String
    
    init(name: String, flowName: String) {
        self.name = name
        self.flowName = flowName
    }
    
    func execute(_ callback: @escaping () -> Void) {
        triggerFlow(named: flowName, callback: callback)
    }
}
extension FlowTask: Codable {}

final class WaitTask: Task {
    let name: String
    var index: Int = Int.max
    let delay: Int
    
    init(name: String, delay: Int) {
        self.name = name
        self.delay = delay
    }
    
    func execute(_ callback: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(delay)) {
            callback()
        }
    }
}
extension WaitTask: Codable {}

final class EndpointOptionTask: Task {
    let name: String
    var index: Int = Int.max
    let netCall: BaseNetworkCall?
    
    init(name: String, device: Device, description: ServerDescription, endpoint: Endpoint, option: EndpointOption) {
        self.name = name
        self.netCall = call(from: device, description: description, endpoint: endpoint, option: option)
    }
    
    func execute(_ callback: @escaping () -> Void) {
        netCall?.execute { _, _, _ in
            callback()
        }
    }
}
extension EndpointOptionTask: Codable {}
