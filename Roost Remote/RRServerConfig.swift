//
//  RRServerConfig.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import FunNet

class RRServerConfig: ServerConfiguration {
    public static let production = ServerConfiguration(scheme: "https", host: "roost-remote-devices.herokuapp.com", apiRoute: "api/v1")
    public static let stub = ServerConfiguration(shouldStub: true, scheme: "https", host: "roost-remote-devices.herokuapp.com", apiRoute: "api/v1")
    
    public static let current = production
}
