//
//  EndpointOptionDeserializer.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit
import Eson

class EndpointOptionDeserializer: Deserializer {
    
    func nameOfClass() -> String {
        return "EndpointOption"
    }
    
    func valueForObject(_ object: AnyObject) -> AnyObject?{
        if object is NSDictionary {
            if object["value"] is NSNumber {
                return Eson().fromJsonDictionary(object as? [String : AnyObject], clazz: NumberEndpointOption.self)
            }else if object["value"] is String {
                return Eson().fromJsonDictionary(object as? [String : AnyObject], clazz: StringEndpointOption.self)
            }else if object["value"] is NSDictionary {
                return Eson().fromJsonDictionary(object as? [String : AnyObject], clazz: DictionaryEndpointOption.self)
            }
        }
        return NSObject()
    }

}
