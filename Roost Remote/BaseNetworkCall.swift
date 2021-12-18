//
//  BaseNetworkCall.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/6/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit

class BaseNetworkCall: NSObject, Codable {
    var hostName: String = "192.168.0.133:8081"
    let scheme: String = "http"
    var namespace: String = ""
    var endpoint: String!
    var httpMethod: String!
    var postData: Data?
    
    func execute(_ completion: @escaping ((Data?, HTTPURLResponse?, NSError?) -> Void)){
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = NSMutableURLRequest(url: (NSURL(scheme: scheme, host: hostName, path: "/" + namespace + endpoint) as? URL)!)
        request.httpMethod = httpMethod;
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        if let data = postData, httpMethod != "GET" {
            request.httpBody = data
        }
        
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, response as? HTTPURLResponse, error as? NSError)
            }
        }.resume();
    }
}
