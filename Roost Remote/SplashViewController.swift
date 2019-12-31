//
//  SplashViewController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import ThryvUXComponents

class SplashViewController: THUXSplashViewController {
    var flowController: AppInitFlowController!
    
    override func viewDidLoad() {
        flowController = AppInitFlowController()
        viewModel = flowController.splashViewModel
        super.viewDidLoad()
        
        viewModel?.outputs.advanceAuthedSignal.observeValues({
            let mainVC = DevicesViewController(nibName: "DevicesViewController", bundle: nil)
            self.flowController.configureMain(viewController: mainVC)
            let navVC = UINavigationController(rootViewController: mainVC)
            self.present(navVC, animated: true, completion: nil)
        })
        viewModel?.outputs.advanceUnauthedSignal.observeValues({
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.flowController.configureLogin(viewController: loginVC)
            let navVC = UINavigationController(rootViewController: loginVC)
            self.present(navVC, animated: true, completion: nil)
        })
    }

}
