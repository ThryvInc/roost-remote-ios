//
//  Batch.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 12/31/19.
//  Copyright © 2019 Elliot Schrock. All rights reserved.
//

import Foundation
import LithoOperators
import LUX

struct Flow {
    var name: String
    var waitTasks: [WaitTask]
    var deviceTasks: [EndpointOptionTask]
    var flowTasks: [FlowTask]
    var triggers: [Trigger]?
    
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
extension Flow: Codable {}

func flows() -> [Flow] {
    if let data = UserDefaults.standard.data(forKey: "flowsData"), let flows = LUXJsonProvider.forceDecode([Flow].self, from: data) {
        return flows
    }
    return [Flow]()
}

func save(flows: [Flow]) {
    UserDefaults.standard.set(LUXJsonProvider.forceEncode(flows), forKey: "flowsData")
}

func triggerFlow(named flowName: String, callback: @escaping () -> Void) {
    flows().first { $0.name == flowName }?.execute(callback)
}
