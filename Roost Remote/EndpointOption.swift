//
//  EndpointOption.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit
import Eson

open class EndpointOption: NSObject, EndpointOptionProtocol {
    var name: String!
    
    open func endpointOption() -> AnyObject? {
        return "" as AnyObject?
    }
   
}
