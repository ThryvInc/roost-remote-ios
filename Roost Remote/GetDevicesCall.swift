//
//  GetDevicesCall.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import ThryvUXComponents
import FunkyNetwork

class GetDevicesCall: THUXModelCall<[Device]> {
    lazy var devicesSignal = modelSignal
    
    init(placeId: String, stubHolder: StubHolderProtocol? = nil) {
        super.init(configuration: RRServerConfig.current, httpMethod: "GET", httpHeaders: [:], endpoint: "places/\(placeId)/devices", postData: nil, stubHolder: stubHolder)
    }
}
