//
//  EndpointTableViewController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/4/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit

class EndpointTableViewController: UITableViewController {
    let endpointManager: EndpointManager = EndpointManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let rightButton: UIBarButtonItem! = UIBarButtonItem(title: "Load", style: UIBarButtonItemStyle.Plain, target: self, action: "refresh")
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func refresh() {
        endpointManager.fetchEndpoints({ (error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error == nil {
                    self.tableView.reloadData()
                } else {
                    let alert: UIAlertView! = UIAlertView(title: "Something went wrong", message: error.debugDescription, delegate: self, cancelButtonTitle: "OK")
                    alert.show();
                }
            })
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.endpointManager.endpoints.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.endpointManager.endpoints[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let endpoint: Endpoint = endpointManager.endpoints[indexPath.row]
        let options: [EndpointOption] = endpoint.options.options
        let alert: UIAlertController = UIAlertController(title: endpoint.name, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        for option in options {
            let action: UIAlertAction = UIAlertAction(title: option.name, style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                endpoint.json = [endpoint.options.name : option.endpointOption]
                endpoint.execute { (success) in
                    if !success {
                        let alert: UIAlertView! = UIAlertView(title: "Something went wrong", message: "Ruh roh", delegate: self, cancelButtonTitle: "OK")
                        alert.show();
                    }
                }
            })
            alert.addAction(action)
        }
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}
