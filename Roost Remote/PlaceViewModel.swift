//
//  DeviceViewModel.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import LUX
import MultiModelTableViewDataSource
import Prelude
import FunNet
import Combine

class PlaceViewModel: LUXModelListViewModel<Device> {
    let call: CombineNetCall
    
    init(placeId: String) {
        self.call = getDevicesCall(placeId)
        let modelPub: AnyPublisher<[Device], Never> = modelPublisher(from: call.responder!.$data.eraseToAnyPublisher())
        
        super.init(modelsPublisher: modelPub, modelToItem: DeviceTableItem.item)
    }
}
