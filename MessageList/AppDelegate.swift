//
//  AppDelegate.swift
//  MessageList
//
//  Created by Richard Adem on 25/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit
import ReSwift
import SDWebImage

var store = Store<State>(reducer: appReducer, state: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // TODO: maybe make this into a debug option?
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
        
        // Global Styles
        UINavigationBar.appearance().barStyle = UIBarStyle.default
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.4039215686, green: 0.2274509804, blue: 0.7176470588, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let rootViewController = UINavigationController(rootViewController: MessageListViewController(viewModel: MessageListViewModel()))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            let viewController = rootViewController
            window.rootViewController = viewController
            window.backgroundColor = UIColor.white
            window.makeKeyAndVisible()
        }
        
        return true
    }
}
