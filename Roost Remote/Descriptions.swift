//
//  Descriptions.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 1/7/20.
//  Copyright © 2020 Elliot Schrock. All rights reserved.
//

import Foundation
import LUX

struct ServerDescription {
    let host: String?
    let hostNamespace: String?
}
extension ServerDescription: Decodable {}
