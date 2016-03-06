//
//  EndpointArrayDeserializer.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 3/5/16.
//  Copyright © 2016 Elliot Schrock. All rights reserved.
//

import UIKit
import Eson

class EndpointOptionArrayDeserializer: Deserializer {
    
    func nameOfClass() -> String {
        return "Array<EndpointOption>"
    }
    
    func valueForObject(object: AnyObject) -> AnyObject?{
        return Eson().fromJsonArray(object as? [[String : AnyObject]], clazz: EndpointOption.self)
    }
}
