//
//  EndpointsViewController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/23/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit

class EndpointsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var describer: DeviceDescriber!
    @IBOutlet var endpointTableView: UITableView!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = describer.name
        
        editButton.setTitleColor(UIColor.buttonTextColor(), for: UIControl.State())
        editButton.backgroundColor = UIColor.buttonBgColor()
        editButton.layer.cornerRadius = editButton.bounds.width / 2
        
        endpointTableView.dataSource = self
        endpointTableView.delegate = self
        endpointTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let rightButton: UIBarButtonItem! = UIBarButtonItem(title: "LOAD", style: UIBarButtonItem.Style.plain, target: self, action: #selector(EndpointsViewController.refresh))
        navigationItem.rightBarButtonItem = rightButton
        navigationController?.navigationBar.isTranslucent = false
        
        refresh()
    }
    
    @objc func refresh() {
        describer.fetchEndpoints( { (error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if error == nil {
                    self.endpointTableView.reloadData()
                } else {
                    let alert = UIAlertController(title: "Something went wrong", message: error.debugDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return describer.device?.endpoints?.count != 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let device = describer.device {
            return device.endpoints?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let device = describer.device {
            cell.textLabel?.text = device.endpoints?[indexPath.row].name
            cell.detailTextLabel?.text = device.endpoints?[indexPath.row].endpoint
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.endpointTableView.deselectRow(at: indexPath, animated: true)
        let endpoint: Endpoint = (describer.device?.endpoints?[indexPath.row])!
        if let endpointOptions = endpoint.options {
            if let options = endpointOptions.values {
                if options.count == 1 {
                    execute(endpoint: endpoint, option: options[0])
                }else{
                    let alert: UIAlertController = UIAlertController(title: endpoint.name, message: "", preferredStyle: UIAlertController.Style.actionSheet)
                    for option in options {
                        let action: UIAlertAction = UIAlertAction(title: option.name ?? "", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                            self.execute(endpoint: endpoint, option: option)
                        })
                        alert.addAction(action)
                    }
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                        alert.dismiss(animated: true, completion: { () -> Void in})
                    }))
                    if let popover = alert.popoverPresentationController {
                        popover.sourceView = tableView.cellForRow(at: indexPath)?.contentView
                        popover.sourceRect = tableView.rectForRow(at: indexPath)
                    }
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func execute(endpoint: Endpoint, option: EndpointOption) {
        if let device = self.describer.device {
            let completion = { (success: Bool) in
                if !success {
                    let alert = UIAlertController(title: "Something went wrong", message: "Ruh roh", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            let description = ServerDescription(host: device.host, hostNamespace: device.hostNamespace)
            endpoint.execute(device: device, description: description, option: option, completion)
//            endpoint.execute(host: device.host!, namespace: device.hostNamespace!, option: option, completion)
        }
    }
}
