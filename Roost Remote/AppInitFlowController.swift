//
//  AppInitFlowController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import LUX
import THUXAuth
import MultiModelTableViewDataSource
import Prelude
import Combine

class AppInitFlowController: LUXAppOpenFlowController {
    private var cancelBag = Set<AnyCancellable?>()
    private var authedCoordinator = AuthedFlowCoordinator()
    
    override init() {
        super.init()
        setupSplash()
        setupLogin()
    }
    
    override func initialVC() -> UIViewController? {
        let splashVC = SplashViewController(nibName: "SplashViewController", bundle: nil)
        splashVC.viewModel = splashViewModel
        
        cancelBag.insert(splashViewModel?.outputs.advanceAuthedPublisher.sink {
            if let vc = self.authedCoordinator.initialVC() {
                splashVC.present(vc, animated: true, completion: nil)
            }
        })
        cancelBag.insert(splashViewModel?.outputs.advanceUnauthedPublisher.sink {
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.configureLogin(viewController: loginVC)
            let navVC = UINavigationController(rootViewController: loginVC)
            navVC.modalTransitionStyle = .crossDissolve
            navVC.modalPresentationStyle = .fullScreen
            splashVC.present(navVC, animated: true, completion: nil)
        })
        
        return splashVC
    }
    
    func setupSplash() {
        THUXSessionManager.primarySession = THUXUserDefaultsSession(host: "rrApiKey", authHeaderKey: "X-API-Key")
        splashViewModel = LUXSplashViewModel(minimumVisibleTime: 0.0, otherTasks: nil)
    }
    
    func setupLogin() {
        let call = createSessionCall()
        
        let modelPub: AnyPublisher<AuthResponse, Never> = modelPublisher(from: call.responder!.$data.eraseToAnyPublisher())
        cancelBag.insert(modelPub.sink(receiveValue: AppInitFlowController.createSession(auth:)))
        
        loginViewModel = LUXLoginViewModel(credsCall: call, loginModelToJson: auth(username:password:))
    }
    
    func configureLogin(viewController: LoginViewController) {
        viewController.loginViewModel = loginViewModel
        cancelBag.insert(loginViewModel?.advanceAuthedPublisher.sink {
            if let vc = self.authedCoordinator.initialVC() {
                viewController.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    static func createSession(auth: AuthResponse) {
        if let apiKey = auth.apiKey {
            let session = THUXUserDefaultsSession(host: "rrApiKey", authHeaderKey: "X-API-Key")
            session.setAuthValue(authString: apiKey)
            THUXSessionManager.primarySession = session
        }
    }
}

extension MultiModelTableViewDataSourceSection {
    static func itemsToSection(items: [MultiModelTableViewDataSourceItem]) -> MultiModelTableViewDataSourceSection {
        let section = MultiModelTableViewDataSourceSection()
        section.items = items
        return section
    }
}

func arrayOfSingleObject<T>(object: T) -> [T] {
    return [object]
}
