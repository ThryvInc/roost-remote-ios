//
//  EndpointOptionHolderDeserializer.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 3/12/16.
//  Copyright © 2016 Elliot Schrock. All rights reserved.
//

import UIKit
import Eson

class EndpointOptionHolderDeserializer: Deserializer {
    
    func nameOfClass() -> String {
        return "EndpointOptionHolder"
    }
    
    func valueForObject(object: AnyObject) -> AnyObject?{
        let eson = Eson()
        eson.deserializers.append(EndpointOptionArrayDeserializer())
        return eson.fromJsonDictionary(object as? [String : AnyObject], clazz: EndpointOptionHolder.self)
    }
}
