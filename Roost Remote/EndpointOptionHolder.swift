//
//  EndpointOptionHolder.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit
import Eson

public class EndpointOptionHolder: NSObject, EsonKeyMapper {
    var name: String!
    var options: [EndpointOption]?
    
    public class func esonPropertyNameToKeyMap() -> [String : String] {
        return ["name":"key","options":"values"]
    }
   
}
