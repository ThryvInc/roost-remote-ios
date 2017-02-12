//
//  DevicesViewController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit

class DevicesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var devicesTableView: UITableView!
    var describers: [DeviceDescription]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateDevices()
        
        devicesTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "cell")
        devicesTableView.dataSource = self
        devicesTableView.delegate = self
    }
    
    func generateDevices() {
        let tv = DeviceDescription()
        tv.name = "TV"
        tv.host = "192.168.0.112:8081"
        
        let music = DeviceDescription()
        music.name = "Music"
        music.host = "192.168.0.147:8081"
        
        describers = [tv, music]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return describers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = describers?[indexPath.row].name
        cell.detailTextLabel?.text = describers?[indexPath.row].host
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let describer = describers?[indexPath.row]
        let endpointVC = EndpointsViewController(nibName: "EndpointsViewController", bundle: nil)
        endpointVC.describer = describer
        navigationController?.pushViewController(endpointVC, animated: true)
    }

}
