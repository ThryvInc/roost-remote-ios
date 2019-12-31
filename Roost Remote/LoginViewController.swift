//
//  LoginViewController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import ThryvUXComponents

class LoginViewController: THUXLoginViewController {
    var flowController: AppInitFlowController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        
        loginButton?.layer.cornerRadius = (loginButton?.bounds.size.height ?? 10) / 2
        
        loginViewModel?.outputs.advanceAuthed.observeValues({ (_) in
            let mainVC = DevicesViewController(nibName: "DevicesViewController", bundle: nil)
            self.flowController?.configureMain(viewController: mainVC)
            let navVC = UINavigationController(rootViewController: mainVC)
            self.present(navVC, animated: true, completion: nil)
        })
    }
}
