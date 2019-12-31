//
//  DeviceViewModel.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import ThryvUXComponents
import MultiModelTableViewDataSource
import Prelude
import ReactiveSwift

class PlaceViewModel: THUXModelListViewModel<Device> {
    let call: GetDevicesCall
    
    init(placeId: String) {
        let devicesCall = GetDevicesCall(placeId: placeId)
        self.call = devicesCall
        
        super.init(modelsSignal: devicesCall.devicesSignal, modelToItem: DeviceTableItem.item)
    }
}
