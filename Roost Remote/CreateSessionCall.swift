//
//  CreateSessionCall.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 12/30/19.
//  Copyright © 2019 Elliot Schrock. All rights reserved.
//

import LUX
import FunNet
import LithoOperators

func createSessionCall(_ serverConfig: ServerConfigurationProtocol = RRServerConfig.current) -> CombineNetCall {
    var endpoint = FunNet.Endpoint()
    endpoint.path = "session"
    endpoint /> setToPost
    endpoint /> addJsonHeaders
    return CombineNetCall(configuration: serverConfig, endpoint)
}
