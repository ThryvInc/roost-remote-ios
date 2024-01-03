//
//  AppDelegate.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/4/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit
import LUX
import WatchConnectivity

func sendFlows(_ session: WCSession) {
    session.sendMessage(["flows": try? JSONEncoder().encode(flows())], replyHandler: { _ in
        print("reply")
    })
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var flowController: LUXFlowCoordinator = AppInitFlowController()
    var session: WCSession = .default
    var watchDelegate = WatchConnectivityDelegate({ sendFlows(WCSession.default) }, didReceiveMessage: { _ in })

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainFont = UIFont(name: "AvenirNext-DemiBold", size: 20)!
        let buttonFont = UIFont(name: "AvenirNext-DemiBold", size: 17)!
        
        application.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.navBgColor()
        appearance.titleTextAttributes = [NSAttributedString.Key.font : mainFont, NSAttributedString.Key.foregroundColor : UIColor.navTextColor()]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : buttonFont], for: UIControl.State())
        UIBarButtonItem.appearance().tintColor = UIColor.navHighlightColor()
        
        UITableView.appearance().backgroundColor = UIColor.tableBgColor()
        
        let splashVC = flowController.initialVC() //SplashViewController(nibName: "SplashViewController", bundle: nil)
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
        
        session.delegate = watchDelegate
        session.activate()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

