//
//  EndpointOption.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit

open class EndpointOption: Decodable {
    var name: String!
    var value: Decodable?
    
    public required init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: EndpointOptionCodingKey.self)
        
        if let name = try? container.decode(String.self, forKey: .name) {
            self.name = name
        }
        
        if let val = try? container.decode(String.self, forKey: .value) {
            value = val
        }
        if let val = try? container.decode(Int.self, forKey: EndpointOptionCodingKey.value) {
            value = val
        }
        if let val = try? container.decode(Bool.self, forKey: EndpointOptionCodingKey.value) {
            value = val
        }
        if let val = try? container.decode([String: String].self, forKey: EndpointOptionCodingKey.value) {
            value = val
        }
        if let val = try? container.decode([String: Int].self, forKey: EndpointOptionCodingKey.value) {
            value = val
        }
        if let val = try? container.decode([String: Bool].self, forKey: EndpointOptionCodingKey.value) {
            value = val
        }
        if let val = try? container.decode([String: [String]].self, forKey: EndpointOptionCodingKey.value) {
            value = val
        }
    }
    
    open func endpointOption() -> Decodable? {
        return value
    }
    
    enum EndpointOptionCodingKey: CodingKey {
        case name
        case value
    }
}
