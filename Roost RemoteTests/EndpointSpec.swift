//
//  EndpointSpec.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import Roost_Remote
import Eson
import Quick
import Nimble

class EndpointSpec: QuickSpec {
    var endpointJson: [String: AnyObject]!
    override func spec() {
        describe("the endpoint", { () -> Void in
            beforeSuite {
                self.endpointJson = ["name": "Power",
                    "method": "PUT",
                    "endpoint": "/power",
                    "options": [
                        "key": "on",
                        "values": [
                            [
                                "name": "On",
                                "value": true
                            ],
                            [
                                "name": "Off",
                                "value": false
                            ]
                        ]
                    ]
                ]
            }
            
            context("gets created by Eson", { () -> Void in
                it("is not nil") {
                    let eson = Eson()
                    eson.deserializers.append(EndpointOptionHolderDeserializer())
                    let endpoint: Endpoint? = eson.fromJsonDictionary(self.endpointJson, clazz: Endpoint.self)
                    expect(endpoint).toNot(beNil())
                }
                it("has a name, a method, an endpoint, and options") {
                    let eson = Eson()
                    eson.deserializers.append(EndpointOptionHolderDeserializer())
                    let endpoint: Endpoint? = eson.fromJsonDictionary(self.endpointJson, clazz: Endpoint.self)
                    expect(endpoint?.name).toNot(beNil())
                    expect(endpoint?.method).toNot(beNil())
                    expect(endpoint?.endpoint).toNot(beNil())
                    expect(endpoint?.options).toNot(beNil())
                    expect(endpoint?.options).to(beAnInstanceOf(EndpointOptionHolder.self))
                    expect(endpoint?.options?.options).toNot(beNil())
                }
            })
        })
    }
}
