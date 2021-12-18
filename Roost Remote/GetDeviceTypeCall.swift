//
//  GetDeviceTypeCall.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/17/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import LUX
import FunNet
import LithoOperators

func getDeviceTypesCall(by typeId: String, _ serverConfig: ServerConfigurationProtocol = RRServerConfig.current) -> CombineNetCall {
    var endpoint = FunNet.Endpoint()
    endpoint.path = "device_types/" + typeId
    endpoint /> addJsonHeaders
    endpoint /> authorize
    return CombineNetCall(configuration: serverConfig, endpoint)
}
