//
//  EndpointManagerSpecs.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/15/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import Roost_Remote
import Quick
import Nimble
import Nocilla

class EndpointManagerSpecs: QuickSpec {
    override func spec() {
        describe("the manager", { () -> Void in
            beforeSuite {
                LSNocilla.sharedInstance().start()
            }
            afterSuite {
                LSNocilla.sharedInstance().stop()
            }
            afterEach {
                LSNocilla.sharedInstance().clearStubs()
            }
            it("downloads the endpoints") {
                let json: NSData = NSData(contentsOfFile: NSBundle(forClass: self.classForCoder).pathForResource("index", ofType: "json")!)!
                let endpointManager: EndpointManager = EndpointManager()
                stubRequest("GET", "http://192.168.0.124:8081/api/v1/index").withHeader("Content-type", "application/json").andReturn(200).withBody(json)
                var endpoints: [Endpoint]?
                endpointManager.fetchEndpoints({ (error) -> Void in
                    endpoints = endpointManager.endpoints
                })
                expect(endpoints?.count).toEventually(equal(2))
            }
        })
    }
}
