//
//  AppInitFlowController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 7/16/18.
//  Copyright © 2018 Elliot Schrock. All rights reserved.
//

import UIKit
import ThryvUXComponents
import MultiModelTableViewDataSource
import Prelude

class AppInitFlowController: THUXAppOpenFlowController {
    private var placesCall: GetPlacesCall?
    
    override init() {
        super.init()
        setupSplash()
        setupLogin()
    }
    
    func setupSplash() {
        THUXSessionManager.session = THUXUserDefaultsSession(authDefaultsKey: "rrApiKey", authHeaderKey: "X-API-Key")
        splashViewModel = THUXSplashViewModel(minimumVisibleTime: 0.0, otherTasks: nil)
    }
    
    func setupLogin() {
        let call = THUXCredsLoginNetworkCall(configuration: RRServerConfig.current,
                                             endpoint: "session",
                                             wrapKey: nil,
                                             stubHolder: nil)
        
        call.dataSignal
            .skipNil()
            .map(AppInitFlowController.parseAuthResponse)
            .skipNil()
            .observeValues(AppInitFlowController.createSession)
        
        loginViewModel = THUXLoginViewModel(credsCall: call)
    }
    
    func configureLogin(viewController: LoginViewController) {
        viewController.flowController = self
        viewController.loginViewModel = loginViewModel
    }
    
    func configureMain(viewController: DevicesViewController) {
        placesCall = GetPlacesCall()
        placesCall?.placesSignal.observeValues { (places) in
            if let place = places.first {
                viewController.place = place
            }
        }
        placesCall?.fire()
    }
    
    static func parseAuthResponse(jsonData: Data) -> AuthResponse? {
        do {
            return try JSONDecoder().decode(AuthResponse.self, from: jsonData)
        } catch {
            return nil
        }
    }
    
    static func createSession(auth: AuthResponse) {
        if let apiKey = auth.apiKey {
            let session = THUXUserDefaultsSession(authDefaultsKey: "rrApiKey", authHeaderKey: "X-API-Key")
            session.setAuthValue(authString: apiKey)
            THUXSessionManager.session = session
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
