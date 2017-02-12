//
//  DictionaryEndpointOption.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit

class DictionaryEndpointOption: EndpointOption {
    var value: NSDictionary!
    
    override func endpointOption() -> AnyObject? {
        return value
    }
}
