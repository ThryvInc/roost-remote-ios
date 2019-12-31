//
//  EndpointOptionHolder.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit

open class EndpointOptionHolder: Decodable {
    var key: String!
    var staticValues: [EndpointOption]?
    var values: [EndpointOption]?
}
