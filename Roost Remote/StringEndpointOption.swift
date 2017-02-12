//
//  StringEndpointOption.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit

class StringEndpointOption: EndpointOption {
    var value: String!
    
    override func endpointOption() -> AnyObject? {
        return value as AnyObject?
    }
}
