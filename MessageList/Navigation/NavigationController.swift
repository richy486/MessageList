//
//  NavigationController.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit
import ReSwift
import RxCocoa

class NavigationController: UINavigationController {
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        
        navigationBar.layer.shadowColor = Constants.Layout.shadowColor.cgColor
        navigationBar.layer.shadowOpacity = Float(Constants.Layout.shadowOpacity)
        navigationBar.layer.shadowRadius = Constants.Layout.shadowRadius
        navigationBar.layer.shadowOffset = Constants.Layout.shadowOffset
    }
    
    // The navigation controller has control over the status bar, we want to pass though to the view controllers
    // because we have different styles for different screens.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let viewControllerShowing = viewControllerShowing {
            return viewControllerShowing.preferredStatusBarStyle
        }
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        if let viewControllerShowing = viewControllerShowing {
            return viewControllerShowing.prefersStatusBarHidden
        }
        return false
    }
    
    // MARK: Actions
    
    @objc func hamburgerMenuTapped(sender: UIBarButtonItem) {
        
        let debugViewModel = DebugViewModel()
        debugViewModel.didRequestClose = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        let debugViewController = DebugViewController(viewModel: debugViewModel)
        
        present(debugViewController, animated: true, completion: nil)
    }
    
    // MARK: Navigation functions
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)

        setupHamburgerMenu(on: viewController)
    }
    
    // MARK: Private functions
    
    private func setupHamburgerMenu(on viewController: UIViewController) {
        let hamburgerMenuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburgerMenu"), style: .plain, target: self, action: #selector(hamburgerMenuTapped))
        hamburgerMenuButton.tintColor = .white
        viewController.navigationItem.leftBarButtonItem = hamburgerMenuButton
    }
    
    private var viewControllerShowing: UIViewController? {
        if let presentedViewController = presentedViewController {
            return presentedViewController
        }
        if let topViewController = viewControllers.last {
            return topViewController
        }
        return nil
    }
    
    // MARK: - Memory manager

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
