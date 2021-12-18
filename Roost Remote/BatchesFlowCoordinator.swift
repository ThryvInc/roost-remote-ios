//
//  BatchesFlowCoordinator.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 12/31/19.
//  Copyright © 2019 Elliot Schrock. All rights reserved.
//

import LUX
import LithoOperators
import MultiModelTableViewDataSource
import PlaygroundVCHelpers
import Combine
import EventKit

class BatchesFlowCoordinator: LUXFlowCoordinator {
    var devices: [Device]
    var triggerDelegate: LUXTappableTableDelegate?
    
    init(devices: [Device]) {
        self.devices = devices
    }
    
    func initialVC() -> UIViewController? {
        let vc = CreateBatchViewController.makeFromXIB()
        vc.onTasksPressed = configureTasks
        vc.onTriggersPressed = configureTriggers
        configureTasks(vc)
        return vc
    }
    
    func configureTasks(_ vc: CreateBatchViewController) {
        vc.viewModel = LUXModelListViewModel(modelsPublisher: vc.$tasks.compactMap { $0 }.eraseToAnyPublisher(), modelToItem: modelToItem(taskConfigurator))
        vc.onAddPressed = {
            $0.displayAddTypeChooser($0, devices: self.devices)
        }
        vc.tableViewDelegate = LUXTappableTableDelegate { indexPath in
            let alertController = UIAlertController(title: "Remove task", message: "Would you like to remove this task?", preferredStyle: .actionSheet)
            let doneAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) -> Void in
                var tasks = vc.tasks
                tasks?.remove(at: indexPath.row)
                vc.tasks = tasks
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) -> Void in
                alertController.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(doneAction)
            alertController.addAction(cancelAction)
            
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    
    func configureTriggers(_ vc: CreateBatchViewController) {
        vc.onAddPressed = { _ in }
        
        let sub = CurrentValueSubject<[Trigger]?, Never>(vc.triggers)
        let vm = LUXModelListViewModel(modelsPublisher: sub.eraseToAnyPublisher().compactMap { $0 }.eraseToAnyPublisher(),
                                       modelToItem: triggerToItem())
        
        triggerDelegate = LUXTappableTableDelegate(vm.dataSource)
        vm.dataSource.tableView = vc.tableView
        vc.tableView?.dataSource = vm.dataSource
        vc.tableView?.delegate = triggerDelegate
        vc.tableView?.reloadData()
    }
}

func triggerToItem() -> (Trigger) -> MultiModelTableViewDataSourceItem {
    return { trigger in
        FunctionalMultiModelTableViewDataSourceItem<AlarmTableViewCell>(identifier: "triggerCell", configureTriggerCell(trigger))
    }
}

func switchToggle(_ trigger: Trigger) -> (Bool) -> Void {
    return {
        trigger.enabled = $0
//        if let date = trigger.date, trigger.enabled {
//            let alarm = EKAlarm(absoluteDate: date)
//            
//        } else {
//            
//        }
    }
}

func configureTriggerCell(_ trigger: Trigger) -> (UITableViewCell) -> Void {
    return {
        if let alarmCell = $0 as? AlarmTableViewCell {
            alarmCell.dateLabel.text = trigger.name
            alarmCell.onSwitchToggled = switchToggle(trigger)
        }
    }
}

func modelToItem<T>(_ modelToConfig: @escaping (T) -> (UITableViewCell) -> Void) -> (T) -> MultiModelTableViewDataSourceItem {
    return { model in
        FunctionalMultiModelTableViewDataSourceItem<LUXDetailTableViewCell>(identifier: "aCell", modelToConfig(model))
    }
}

func modelToTappableItem<T>(_ modelToConfig: @escaping (T) -> (UITableViewCell) -> Void, _ tappedModel: @escaping (T) -> Void) -> (T) -> MultiModelTableViewDataSourceItem {
    return { model in
        TappableFunctionalMultiModelItem<LUXDetailTableViewCell>(identifier: "aCell", modelToConfig(model), voidCurry(model, tappedModel))
    }
}

let taskConfigurator: (Task) -> (UITableViewCell) -> Void = { task in
    return {
        $0.textLabel?.text = task.name
    }
}

extension CreateBatchViewController {
    func displayAddTypeChooser(_ vc: UIViewController, devices: [Device]) {
        let alertController = UIAlertController(title: "Add task", message: "What would you like to add?", preferredStyle: .actionSheet)
        
        let deviceAction = UIAlertAction(title: "Make device do something", style: .default, handler: {(action: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: {
                self.displayDeviceChooser(vc, devices: devices)
            })
        })
        
        let waitAction = UIAlertAction(title: "Wait", style: .default, handler: {(action: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: {
                self.displayWaitPrompt(vc)
            })
        })
        
        let flowAction = UIAlertAction(title: "Activate another batch", style: .default, handler: {(action: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: {
                self.displayFlowChooser(vc)
            })
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(deviceAction)
        alertController.addAction(waitAction)
        alertController.addAction(flowAction)
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController, let button = (vc as? CreateBatchViewController)?.addButton {
            popover.sourceView = button
            popover.sourceRect = button.bounds
        }
        
        vc.present(alertController, animated: true, completion: nil)
    }

    func displayWaitPrompt(_ vc: UIViewController) {
        let alertController = UIAlertController(title: "How long?", message: "How long should the wait be?", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction!) -> Void in
            let quantityTextField = alertController.textFields![0] as UITextField
            if let delayString = quantityTextField.text, let delay = Int(delayString) {
                let waitTask = WaitTask(name: "Wait \(delayString)ms", delay: delay)
                waitTask.index = self.tasks?.count ?? 0
                self.add(task: waitTask)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Milliseconds"
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController, let button = (vc as? CreateBatchViewController)?.addButton {
            popover.sourceView = button
            popover.sourceRect = button.bounds
        }
        
        vc.present(alertController, animated: true, completion: nil)
    }

    func displayFlowChooser(_ vc: UIViewController) {
        let alertController = UIAlertController(title: "Add task", message: "What would you like to add?", preferredStyle: .actionSheet)
        
        for flow in flows() {
            let flowAction = UIAlertAction(title: flow.name, style: .default, handler: {(action: UIAlertAction!) -> Void in
                alertController.dismiss(animated: true) {
                    let flowTask = FlowTask(name: flow.name, flowName: flow.name)
                    flowTask.index = self.tasks?.count ?? 0
                    self.add(task: flowTask)
                }
            })
            alertController.addAction(flowAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController, let button = (vc as? CreateBatchViewController)?.addButton {
            popover.sourceView = button
            popover.sourceRect = button.bounds
        }
        
        vc.present(alertController, animated: true, completion: nil)
    }

    func displayDeviceChooser(_ vc: UIViewController, devices: [Device]) {
        let alertController = UIAlertController(title: "Choose device", message: "Which device?", preferredStyle: .actionSheet)
        
        for device in devices {
            let flowAction = UIAlertAction(title: device.name, style: .default, handler: {(action: UIAlertAction!) -> Void in
                alertController.dismiss(animated: true) {
                    let devDesc = DeviceDescriber()
                    devDesc.name = device.name
                    devDesc.host = device.describer
                    devDesc.device = device
                    devDesc.fetchEndpoints { error in
                        DispatchQueue.main.async {
                            self.displayEndpointChooser(vc, device: device, deviceDescription: devDesc)
                        }
                    }
                }
            })
            alertController.addAction(flowAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController, let button = (vc as? CreateBatchViewController)?.addButton {
            popover.sourceView = button
            popover.sourceRect = button.bounds
        }
        
        vc.present(alertController, animated: true, completion: nil)
    }

    func displayEndpointChooser(_ vc: UIViewController, device: Device, deviceDescription: DeviceDescriber) {
        let alertController = UIAlertController(title: "Choose endpoint", message: "Which endpoint?", preferredStyle: .actionSheet)
        
        if let endpoints = deviceDescription.device?.endpoints {
            for endpoint in endpoints {
                let endpointAction = UIAlertAction(title: endpoint.name, style: .default, handler: {(action: UIAlertAction!) -> Void in
                    alertController.dismiss(animated: true) {
                        if let options = endpoint.options?.values {
                            self.displayOptionChooser(vc, device: device, deviceDescription: deviceDescription, endpoint: endpoint, options: options)
                        }
                    }
                })
                alertController.addAction(endpointAction)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController, let button = (vc as? CreateBatchViewController)?.addButton {
            popover.sourceView = button
            popover.sourceRect = button.bounds
        }
        
        vc.present(alertController, animated: true, completion: nil)
    }

    func displayOptionChooser(_ vc: UIViewController, device: Device, deviceDescription: DeviceDescriber, endpoint: Endpoint, options: [EndpointOption]) {
        let alertController = UIAlertController(title: "Choose option", message: "Which option?", preferredStyle: .actionSheet)
        
        for option in options {
            let optionAction = UIAlertAction(title: option.name, style: .default, handler: {(action: UIAlertAction!) -> Void in
                alertController.dismiss(animated: true) {
                    let serverDescription = ServerDescription(host: deviceDescription.host, hostNamespace: deviceDescription.device?.hostNamespace)
                    let endpointTask = EndpointOptionTask(name: "\(device.name!) > \(endpoint.name) > \(option.name!)", device: device, description: serverDescription, endpoint: endpoint, option: option)
                    endpointTask.index = self.tasks?.count ?? 0
                    self.add(task: endpointTask)
                }
            })
            alertController.addAction(optionAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController, let button = (vc as? CreateBatchViewController)?.addButton {
            popover.sourceView = button
            popover.sourceRect = button.bounds
        }
        
        vc.present(alertController, animated: true, completion: nil)
    }
}
