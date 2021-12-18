//
//  LocalCall.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 12/31/19.
//  Copyright © 2019 Elliot Schrock. All rights reserved.
//

import LUX
import FunNet
import LithoOperators

func localCall(_ serverConfig: ServerConfigurationProtocol) -> CombineNetCall {
    var endpoint = FunNet.Endpoint()
    endpoint.path = "index"
    endpoint /> addJsonHeaders
    return CombineNetCall(configuration: serverConfig, endpoint)
}
