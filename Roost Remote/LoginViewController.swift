//
//  LoginViewController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import LUX
import Combine

class LoginViewController: LUXLoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        
        loginButton?.layer.cornerRadius = (loginButton?.bounds.size.height ?? 10) / 2
    }
}
