//
//  BaseNetworkCall.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/6/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import Foundation

class BaseNetworkCall: NSObject, Codable {
    var hostName: String = "192.168.0.133:8081"
    let scheme: String = "http"
    var namespace: String = ""
    var endpoint: String!
    var httpMethod: String!
    var postData: Data?
    
    func execute(_ completion: @escaping ((Data?, HTTPURLResponse?, NSError?) -> Void)) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = NSMutableURLRequest(url: (NSURL(scheme: scheme, host: hostName, path: "/" + namespace + endpoint) as? URL)!)
        if httpMethod == "GET", let cookies = HTTPCookieStorage.shared.cookies {
            print(cookies)
            request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
            request.httpShouldHandleCookies = true
            print(request.allHTTPHeaderFields)
        }
        print(request.url?.absoluteURL)
        request.httpMethod = httpMethod;
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        if let data = postData, httpMethod != "GET" {
            request.httpBody = data
        }
        
        session.dataTask(with: request as URLRequest, completionHandler: responseHandler(session, completion)).resume();
    }
}

func responseHandler(_ session: URLSession, _ completion: @escaping ((Data?, HTTPURLResponse?, NSError?) -> Void)) -> (Data?, URLResponse?, Error?) -> Void {
    return { data, response, error in
        DispatchQueue.main.async {
            if let httpResp = response as? HTTPURLResponse {
                print("status: \(httpResp.statusCode)")
                print("resp url: \(httpResp.url?.absoluteString ?? "")")
                if httpResp.statusCode == 303, let location = httpResp.allHeaderFields.filter({ $0.key as? String == "location" }).first?.value as? String, let url = URL(string: location) {
                    print("seeing other")
                    session.dataTask(with: URLRequest(url: url), completionHandler: responseHandler(session, completion))
                } else {
                    completion(data, response as? HTTPURLResponse, error as? NSError)
                }
            }
        }
    }
}
