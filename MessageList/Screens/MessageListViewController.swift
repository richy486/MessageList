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
import RxDataSources

class MessageListViewController: UIViewController {
    
    typealias ViewModel = MessageListViewModel
    
    // MARK: - Layout constants
    
    // MARK: - Subviews
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableViewAutomaticDimension
        view.estimatedRowHeight = 140
        view.separatorStyle = .none
        view.backgroundColor = .white
        return view
    }()
    
    private let dataSource: RxTableViewSectionedReloadDataSource<MessageListSectionPresenter> = {
        return RxTableViewSectionedReloadDataSource(
            configureCell: { (dataSource, table, idxPath, item) in
                guard let cell = table.dequeueReusableCell(withIdentifier: MessageListViewController.cellIdentifier, for: idxPath) as? MessageCell else {
                    fatalError("Table view: \(table) not setup to handle MessageCell cells")
                }
                cell.textLabel?.text = "\(item.title)"
                return cell
            }
        )
    }()
    
    // MARK: - Properties
    private let viewModel: ViewModel
    private let disposeBag = DisposeBag()
    private static let cellIdentifier = "messageListCellIdentifier"
    
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: MessageListViewController.cellIdentifier)

        setupSubviews()
        setupViewModelObservables()
        setupViewObservables()
    }
    
    // MARK: - Private methods
    
    private func setupSubviews() {
        
        // Setup Subviews with constraints and anchors
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageListViewController.cellIdentifier)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModelObservables() {
        
        // Observe signals on the view model
        
        viewModel.content.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
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

