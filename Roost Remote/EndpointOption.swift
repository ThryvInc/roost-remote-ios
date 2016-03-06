//
//  EndpointOption.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit
import Eson

public class EndpointOption: NSObject, EsonKeyMapper {
    var name: String!
    var endpointOption: NSNumber!
    
    public class func esonPropertyNameToKeyMap() -> [String : String] {
        return ["endpointOption":"value"]
    }
   
}
