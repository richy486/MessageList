//
//  DebugViewController.swift
//  MessageList
//
//  Created by Richard Adem on 29/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DebugViewController: UIViewController {

    typealias ViewModel = DebugViewModel

    // MARK: - Layout constraints

    private struct LayoutConstraints {
        static let contentInset = UIEdgeInsets(top: 10,
                                               left: 20,
                                               bottom: 0,
                                               right: 20)
    }
    
    // MARK: - Subviews
    
    let closeButton: UIButton = {
        let view = UIButton(type: .custom)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .grouped)
        view.rowHeight = UITableViewAutomaticDimension
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties   
    private let viewModel: ViewModel
    let disposeBag = DisposeBag()
//    private let dataSource = RxTableViewSectionedReloadDataSource<DebugMenuSectionPresenter>()
    private static let cellIdentifier = "debugCellIdentifier"
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<DebugMenuSectionPresenter> = {
        
        return RxTableViewSectionedReloadDataSource(
            configureCell: { (dataSource, table, indexPath, item) in
                guard let cell = table.dequeueReusableCell(withIdentifier: DebugViewController.cellIdentifier) else {
                    fatalError("Table view: \(table) not setup to handle cells")
                }
                cell.textLabel?.text = "\(item.iconCharacter) \(item.title)"
                switch item.optionState {
                case .none, .disabled:
                    cell.accessoryType = .none
                    break
                case .enabled:
                    cell.accessoryType = .checkmark
                    break
                }
                return cell
            },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].title
            }
        )
    }()
    
    // MARK: - View lifecycle
    
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DebugViewController.cellIdentifier)

        setupSubviews()
        setupViewModelObservables()
        setupViewObservables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
        
        super.viewDidAppear(animated)
        
        // This is so we deselect the cell when we go back to this screen, similar to how iOS Settings works
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Private methods

    private func setupSubviews() {

        // Setup Subviews with constraints and anchors
        
        view.backgroundColor = .darkGray

        view.addSubview(tableView)
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LayoutConstraints.contentInset.top),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -LayoutConstraints.contentInset.right)
            
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
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.closeTapped()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.viewModel.didTapItem(at: indexPath)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Memory manager
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Extensions
