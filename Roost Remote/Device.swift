//
//  Device.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit

class Device: NSObject, Decodable {
    var name: String?
    var host: String?
    var hostNamespace: String?
    var deviceTypeId: String?
    var describer: String?
    var describerNamespace: String?
    var endpoints: [Endpoint]?
    
    enum CodingKeys: String, CodingKey {
        case host
        case hostNamespace
        case name
        case endpoints
        case deviceTypeId
        case describer
        case describerNamespace
    }
}
