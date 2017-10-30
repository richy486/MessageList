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
    
//    override init(rootViewController: UIViewController) {
    //        super.init(rootViewController: rootVivarontroller)
//
//        setupHamburgerMenu(on: rootViewController)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        
        // TODO: try shadow again
        
//        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPropertyList:)];
//        self.navigationItem.rightBarButtonItem = anotherButton;
//        [anotherButton release];
        
//        self.navigationBar.rx.`
        
//        let hamburgerMenuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburgerMenu"), style: .plain, target: self, action: #selector(hamburgerMenuTapped))
//        navigationItem.leftBarButtonItem = nil
//        navigationItem.leftBarButtonItems = [hamburgerMenuButton]
//        let btn1 = UIButton(type: .custom)
//        btn1.setImage(UIImage(named: "hamburgerMenu"), for: .normal)
////        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btn1.addTarget(self, action: #selector(hamburgerMenuTapped), for: .touchUpInside)
//        let item1 = UIBarButtonItem(customView: btn1)
//        navigationItem.setLeftBarButtonItems([item1], animated: true)
        
//        navigationItem.setLeftBarButton(hamburgerMenuButton, animated: false)
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
    
    // MARK: - Memory manager

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
