//
//  AuthedFlowCoordinator.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 12/31/19.
//  Copyright © 2019 Elliot Schrock. All rights reserved.
//

import LUX

class AuthedFlowCoordinator: LUXFlowCoordinator {
    var children = [LUXFlowCoordinator]()
    
    func initialVC() -> UIViewController? {
        let fc = DevicesFlowCoordinator()
        children.append(fc)
        return fc.initialVC()
    }
}
