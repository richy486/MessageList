//
//  NavigationController.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
    }
    
    // MARK: - Memory manager

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
