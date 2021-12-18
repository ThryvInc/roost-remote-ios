//
//  Trigger.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 12/31/19.
//  Copyright © 2019 Elliot Schrock. All rights reserved.
//

import Foundation
import Combine

class Trigger: Codable {
    var flowName: String?
    var name: String?
    var enabled: Bool = false
    var date: Date?
}
//extension Trigger: Codable {}
