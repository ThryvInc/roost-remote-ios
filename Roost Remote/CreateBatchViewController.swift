//
//  CreateBatchViewController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 12/31/19.
//  Copyright © 2019 Elliot Schrock. All rights reserved.
//

import LUX
import LithoOperators
import Combine

class CreateBatchViewController: LUXMultiModelTableViewController<LUXModelListViewModel<Task>> {
    @IBOutlet weak var titleTextField: UITextField?
    
    @IBOutlet weak var tasksButton: UIButton?
    var onTasksPressed: ((CreateBatchViewController) -> Void)?
    @IBOutlet weak var triggersButton: UIButton?
    var onTriggersPressed: ((CreateBatchViewController) -> Void)?
    @IBOutlet weak var addButton: UIButton?
    var onAddPressed: ((CreateBatchViewController) -> Void)?
    
    var devices: [Device]?
    var flow: Flow? {
        didSet {
            tasks = flow?.tasks()
            triggers = flow?.triggers
        }
    }
    @Published var tasks: [Task]?
    @Published var triggers: [Trigger]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = tasks {} else { tasks = [Task]() }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        titleTextField?.text = flow?.name
        ifExecute(tasksButton, styleInvertedButton)
        ifExecute(triggersButton, styleInvertedButton)
        ifExecute(addButton, styleInvertedButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let flow = createFlow() {
            var newFlows = flows()
            newFlows.append(flow)
            save(flows: newFlows)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func add<T>(task: T) where T: Task {
        if var tasks = tasks {
            tasks.append(task)
            self.tasks = tasks
        }
    }
    
    func createFlow() -> Flow? {
        if let title = titleTextField?.text, let tasks = tasks, !title.isEmpty {
            return Flow(name: title,
                        waitTasks: tasks.compactMap { $0 as? WaitTask },
                        deviceTasks: tasks.compactMap { $0 as? EndpointOptionTask },
                        flowTasks: tasks.compactMap { $0 as? FlowTask })
        }
        return nil
    }
    
    @IBAction func taskPressed() {
        onTasksPressed?(self)
    }
    
    @IBAction func triggersPressed() {
        onTriggersPressed?(self)
    }
    
    @IBAction func addPressed() {
        onAddPressed?(self)
    }
}
