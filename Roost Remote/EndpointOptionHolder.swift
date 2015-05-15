//
//  EndpointOptionHolder.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit
import Mantle

class EndpointOptionHolder: MTLModel, MTLJSONSerializing {
    var name: String!
    var options: [EndpointOption]!
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return ["name":"key", "options":"values"]
    }
    
    class func JSONTransformerForKey(key: String!) -> NSValueTransformer! {
        if key == "options" {
            return MTLJSONAdapter.arrayTransformerWithModelClass(EndpointOption.self)
        }
        
        return nil
    }
   
}
