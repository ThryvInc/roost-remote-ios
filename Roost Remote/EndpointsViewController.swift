//
//  EndpointsViewController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/23/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit

class EndpointsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var describer: DeviceDescription!
    @IBOutlet var endpointTableView: UITableView! 
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = describer.name
        
        editButton.setTitleColor(UIColor.buttonTextColor(), for: UIControlState())
        editButton.backgroundColor = UIColor.buttonBgColor()
        editButton.layer.cornerRadius = editButton.bounds.width / 2
        
        endpointTableView.dataSource = self
        endpointTableView.delegate = self
        endpointTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let rightButton: UIBarButtonItem! = UIBarButtonItem(title: "LOAD", style: UIBarButtonItemStyle.plain, target: self, action: #selector(EndpointsViewController.refresh))
        navigationItem.rightBarButtonItem = rightButton
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func refresh() {
        describer.fetchEndpoints( { (error) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if error == nil {
                    self.endpointTableView.reloadData()
                } else {
                    let alert: UIAlertView! = UIAlertView(title: "Something went wrong", message: error.debugDescription, delegate: self, cancelButtonTitle: "OK")
                    alert.show();
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
            if let options = endpointOptions.options {
                if options.count == 1 {
                    execute(endpoint: endpoint, option: options[0])
                }else{
                    let alert: UIAlertController = UIAlertController(title: endpoint.name, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
                    for option in options {
                        let action: UIAlertAction = UIAlertAction(title: option.name, style: UIAlertActionStyle.default, handler: { (action) -> Void in
                            self.execute(endpoint: endpoint, option: option)
                        })
                        alert.addAction(action)
                    }
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                        alert.dismiss(animated: true, completion: { () -> Void in})
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func execute(endpoint: Endpoint, option: EndpointOption) {
        if let device = self.describer.device {
            endpoint.execute(host: device.host!, namespace: device.hostNamespace!, option: option) { (success) in
                if !success {
                    let alert: UIAlertView! = UIAlertView(title: "Something went wrong", message: "Ruh roh", delegate: self, cancelButtonTitle: "OK")
                    alert.show();
                }
            }
        }
    }
}
