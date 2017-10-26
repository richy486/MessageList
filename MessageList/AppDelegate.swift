//
//  AppDelegate.swift
//  MessageList
//
//  Created by Richard Adem on 25/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit
import ReSwift

var store = Store<State>(reducer: appReducer, state: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            let viewController = MessageListViewController(viewModel: MessageListViewModel())
            window.rootViewController = viewController
            window.backgroundColor = UIColor.white
            window.makeKeyAndVisible()
        }
        
        return true
    }
}
