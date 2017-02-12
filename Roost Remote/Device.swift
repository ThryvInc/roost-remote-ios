//
//  Device.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit
import Eson

class Device: NSObject {
    var name: String?
    var host: String?
    var hostNamespace: String?
    var endpoints: [Endpoint]?
}
