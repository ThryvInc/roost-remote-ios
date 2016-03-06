//
//  EndpointOptionHolderSpec.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import Roost_Remote
import Eson
import Quick
import Nimble

class EndpointOptionHolderSpec: QuickSpec {
    var json: [String: AnyObject]!
    override func spec() {
        describe("the endpoint", { () -> Void in
            beforeSuite {
                self.json = [
                    "key": "on",
                    "values": [
                        [
                            "name": "On",
                            "value": "true"
                        ],
                        [
                            "name": "Off",
                            "value": "false"
                        ]
                    ]
                ]
            }
            
            context("gets created by Eson", { () -> Void in
                it("is not nil") {
                    let eson = Eson()
                    eson.deserializers.append(EndpointOptionArrayDeserializer())
                    let holder: EndpointOptionHolder? = eson.fromJsonDictionary(self.json, clazz: EndpointOptionHolder.self)
                    expect(holder).toNot(beNil())
                }
                it("has a key and options") {
                    let eson = Eson()
                    eson.deserializers.append(EndpointOptionArrayDeserializer())
                    let holder: EndpointOptionHolder? = eson.fromJsonDictionary(self.json, clazz: EndpointOptionHolder.self)
                    print(holder!)
                    expect(holder?.name).toNot(beNil())
                    expect(holder?.options).toNot(beNil())
                }
            })
        })
    }
}
