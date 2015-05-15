//
//  EndpointOptionHolderSpec.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import Roost_Remote
import Mantle
import Quick
import Nimble

class EndpointOptionHolderSpec: QuickSpec {
    var json: [NSObject: AnyObject]!
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
            
            context("gets created by Mantle", { () -> Void in
                it("is not nil") {
                    var mantleError: NSError?
                    var holder: EndpointOptionHolder? = MTLJSONAdapter.modelOfClass(EndpointOptionHolder.self, fromJSONDictionary: self.json, error: &mantleError) as? EndpointOptionHolder
                    expect(holder).toNot(beNil())
                }
                it("has a key and options") {
                    var mantleError: NSError?
                    var holder: EndpointOptionHolder! = MTLJSONAdapter.modelOfClass(EndpointOptionHolder.self, fromJSONDictionary: self.json, error: &mantleError) as! EndpointOptionHolder
                    expect(holder.name).toNot(beNil())
                    expect(holder.options).toNot(beNil())
                }
            })
        })
    }
}
