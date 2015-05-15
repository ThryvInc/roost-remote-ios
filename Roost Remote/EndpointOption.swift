//
//  EndpointOption.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit
import Mantle

class EndpointOption: MTLModel, MTLJSONSerializing {
    var name: String!
    var endpointOption: NSNumber!
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return ["name":"name", "endpointOption":"value"]
    }
   
}
