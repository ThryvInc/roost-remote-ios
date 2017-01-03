//
//  EndpointsViewController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/23/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit

class EndpointsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let endpointManager: EndpointManager = EndpointManager()
    @IBOutlet var endpointTableView: UITableView! 
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Roost Remote"
        
        editButton.setTitleColor(UIColor.buttonTextColor(), forState: UIControlState.Normal)
        editButton.backgroundColor = UIColor.buttonBgColor()
        editButton.layer.cornerRadius = editButton.bounds.width / 2
        
        endpointTableView.dataSource = self
        endpointTableView.delegate = self
        endpointTableView.registerNib(UINib(nibName: "EndpointTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        let rightButton: UIBarButtonItem! = UIBarButtonItem(title: "LOAD", style: UIBarButtonItemStyle.Plain, target: self, action: "refresh")
        navigationItem.rightBarButtonItem = rightButton
        navigationController?.navigationBar.translucent = false
    }
    
    func refresh() {
        endpointManager.fetchEndpoints({ (error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return endpointManager.endpoints.count != 0 ? 1 : 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.endpointManager.endpoints.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "TV"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: EndpointTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! EndpointTableViewCell
        cell.nameLabel.text = self.endpointManager.endpoints[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.endpointTableView.deselectRowAtIndexPath(indexPath, animated: true)
        let endpoint: Endpoint = endpointManager.endpoints[indexPath.row]
        if let endpointOptions = endpoint.options {
            if let options = endpointOptions.options {
                let alert: UIAlertController = UIAlertController(title: endpoint.name, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
                for option in options {
                    let action: UIAlertAction = UIAlertAction(title: option.name, style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        endpoint.json = [endpointOptions.name : option.endpointOption]
                        endpoint.execute { (success) in
                            if !success {
                                let alert: UIAlertView! = UIAlertView(title: "Something went wrong", message: "Ruh roh", delegate: self, cancelButtonTitle: "OK")
                                alert.show();
                            }
                        }
                    })
                    alert.addAction(action)
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                    alert.dismissViewControllerAnimated(true, completion: { () -> Void in})
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}
