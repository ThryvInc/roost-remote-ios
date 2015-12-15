//
//  EndpointSpec.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import Roost_Remote
import Mantle
import Quick
import Nimble

class EndpointSpec: QuickSpec {
    var endpointJson: [NSObject: AnyObject]!
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
                                "value": "true"
                            ],
                            [
                                "name": "Off",
                                "value": "false"
                            ]
                        ]
                    ]
                ]
            }
            
            context("gets created by Mantle", { () -> Void in
                it("is not nil") {
                    do {
                        var endpoint: Endpoint? = try MTLJSONAdapter.modelOfClass(Endpoint.self, fromJSONDictionary: self.endpointJson) as? Endpoint
                        expect(endpoint).toNot(beNil())
                    }catch let error as NSError {
                        expect(error).to(beNil())
                    }
                }
                it("has a name, a method, an endpoint, and options") {
                    do {
                        var endpoint: Endpoint? = try MTLJSONAdapter.modelOfClass(Endpoint.self, fromJSONDictionary: self.endpointJson) as? Endpoint
                        expect(endpoint).toNot(beNil())
                        expect(endpoint!.name).toNot(beNil())
                        expect(endpoint!.method).toNot(beNil())
                        expect(endpoint!.endpoint).toNot(beNil())
                        expect(endpoint!.options).toNot(beNil())
                    }catch let error as NSError {
                        expect(error).to(beNil())
                    }
                }
            })
        })
    }
}
