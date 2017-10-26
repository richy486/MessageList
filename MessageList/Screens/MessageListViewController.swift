//
//  MessageListViewController.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MessageListViewController: UIViewController {
    
    typealias ViewModel = MessageListViewModel
    
    // MARK: - Layout constants
    
    // MARK: - Subviews
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()
    
    // MARK: - Properties
    private let viewModel: ViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - View lifecycle
    
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, please use init(viewModel:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // This background color to identify each screen easily, remove once design has been implemented
        let hue = CGFloat(abs(String(describing: MessageListViewController.self).hashValue) % 1000) / 1000.0
        view.backgroundColor = UIColor(hue: hue, saturation: 0.75, brightness: 1.0, alpha: 1.0)
        
        setupSubviews()
        setupViewModelObservables()
        setupViewObservables()
    }
    
    // MARK: - Private methods
    
    private func setupSubviews() {
        
        // Setup Subviews with constraints and anchors
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupViewModelObservables() {
        
        // Observe signals on the view model
        
        viewModel.title.asObservable()
            .scan("") { _, newValue in
                return newValue
            }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupViewObservables() {
        
        // Observe signals on local views
    }
    
    // MARK: - Memory manager

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
