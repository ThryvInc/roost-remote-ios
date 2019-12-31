//
//  DeviceTableItem.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import MultiModelTableViewDataSource

class DeviceTableItem: ConcreteMultiModelTableViewDataSourceItem<DetailsTableViewCell> {
    var device: Device
    
    init(_ identifier: String, _ device: Device) {
        self.device = device
        super.init(identifier: identifier)
    }
    
    override func configureCell(_ cell: UITableViewCell) {
        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = device.host
        
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        
        cell.backgroundColor = UIColor.clear
        
//        let path = \UITableViewCell.textLabel?.text
    }
    
    static func item(device: Device) -> DeviceTableItem {
        return DeviceTableItem("deviceCell", device)
    }
}

func whiteLabel(label: UILabel?) -> UILabel? {
    label?.textColor = UIColor.white
    return label
}

//func setter<T, U>(object: T?, path: KeyPath<T, U>, value: U?) -> T? {
//    if let unwrapped = object {
//        unwrapped[path] = value
//    }
//    return object
//}
