//
//  Batch.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 12/31/19.
//  Copyright © 2019 Elliot Schrock. All rights reserved.
//

import Foundation
import WatchConnectivity

struct Flow: Codable, Equatable, Identifiable {
    var id: String {
        return name
    }
    var name: String
    var waitTasks: [WaitTask]
    var deviceTasks: [EndpointOptionTask]
    var flowTasks: [FlowTask]
    var triggers: [Trigger]?
    
    static func ==(lhs: Flow, rhs: Flow) -> Bool {
        return lhs.name == rhs.name
    }
    
    func tasks() -> [Task] {
        var tasks: [Task] = [Task]()
        tasks.append(contentsOf: waitTasks)
        tasks.append(contentsOf: flowTasks)
        tasks.append(contentsOf: deviceTasks)
        tasks = tasks.sorted { $0.index < $1.index }
        return tasks
    }
    
    func executeTasks() {
        execute(nil)
    }
    
    func execute(_ callback: (() -> Void)?) {
        execute(taskNumber: 0, callback: callback)
    }
    
    func execute(taskNumber: Int, callback: (() -> Void)?) {
        let tasks = self.tasks()
        if tasks.count > taskNumber {
            tasks[taskNumber].execute {
                self.execute(taskNumber: taskNumber + 1, callback: callback)
            }
        } else {
            callback?()
        }
    }
}

func flows() -> [Flow] {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    if let data = UserDefaults.standard.data(forKey: "flowsData"), let flows = try? decoder.decode([Flow].self, from: data) {
        return flows
    }
    return [Flow]()
}

func save(flows: [Flow]) {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .iso8601
    UserDefaults.standard.set(try! encoder.encode(flows), forKey: "flowsData")
    
    #if os(iOS)
    sendFlows(WCSession.default)
    #endif
}

func triggerFlow(named flowName: String, callback: @escaping () -> Void) {
    flows().first { $0.name == flowName }?.execute(callback)
}
