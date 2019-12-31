//
//  GetPlacesCall.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import ThryvUXComponents
import FunkyNetwork

class GetPlacesCall: THUXModelCall<[Place]> {
    lazy var placesSignal = modelSignal
    
    init(stubHolder: StubHolderProtocol? = nil) {
        super.init(configuration: RRServerConfig.current, httpMethod: "GET", httpHeaders: [:], endpoint: "places", postData: nil, stubHolder: stubHolder)
    }
}
