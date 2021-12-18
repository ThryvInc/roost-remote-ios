//
//  GetPlacesCall.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import LUX
import FunNet
import LithoOperators

func getPlacesCall(_ serverConfig: ServerConfigurationProtocol = RRServerConfig.current) -> CombineNetCall {
    var endpoint = FunNet.Endpoint()
    endpoint.path = "places"
    endpoint /> addJsonHeaders
    endpoint /> authorize
    return CombineNetCall(configuration: serverConfig, endpoint)
}
