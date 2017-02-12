//
//  EndpointArrayDeserializer.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit
import Eson

class EndpointArrayDeserializer: Deserializer {
    
    func nameOfClass() -> String {
        return "Array<Endpoint>"
    }
    
    func valueForObject(_ object: AnyObject) -> AnyObject?{
        let eson = Eson()
        eson.deserializers.append(EndpointOptionDeserializer())
        return eson.fromJsonArray(object as? [[String : AnyObject]], clazz: Endpoint.self) as AnyObject?
    }

}
