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
    
    private struct LayoutConstants {
        static let contentInset = UIEdgeInsets(top: 16,
                                               left: 0,
                                               bottom: 0,
                                               right: 0)
        static let backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        
        // The value 161 is based on a 4 line cell on a 4.7" device. Using `UITableViewAutomaticDimension` will
        // default to 44pts and cause the cells to have conflicting constraints
        static let estimatedCellHeight = CGFloat(161)
    }
    
    // MARK: - Subviews
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableViewAutomaticDimension
        view.contentInset = LayoutConstants.contentInset
        view.separatorStyle = .none
        view.backgroundColor = .white
        view.allowsMultipleSelection = false
        view.allowsSelectionDuringEditing = false
        view.backgroundColor = LayoutConstants.backgroundColor
        return view
    }()
    
    // MARK: - Properties
    private let viewModel: ViewModel
    private let disposeBag = DisposeBag()
    private static let cellIdentifier = "messageListCellIdentifier"
    private var cellHeights: [IndexPath: CGFloat] = [:]
    
    private let cellDismissed = PublishSubject<IndexPath>()
    private lazy var dataSource: RxTableViewSectionedAnimatedDataSource<MessageListSectionPresenter> = {
        
        return RxTableViewSectionedAnimatedDataSource(
            configureCell: { (dataSource, table, indexPath, item) in
                guard let cell = table.dequeueReusableCell(withIdentifier: MessageListViewController.cellIdentifier, for: indexPath) as? MessageCell else {
                    fatalError("Table view: \(table) not setup to handle MessageCell cells")
                }
                cell.setup(withPresenter: item)
                
                cell.dismissed
                    .subscribe(onNext: { [weak self] _ in
                        // Calculating index path here because the cell's indexPath will change when cells are removed
                        guard let indexPath = table.indexPath(for: cell) else {
                            return
                        }
                        
                        self?.cellDismissed.onNext(indexPath)
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            },
            canEditRowAtIndexPath: { (dataSource, indexPath) -> Bool in
                return true
            }
        )
    }()
    
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
        
        title = Localizations.Global.AppName

        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageListViewController.cellIdentifier)

        setupSubviews()
        setupViewModelObservables()
        setupViewObservables()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
        
    // MARK: - Private methods
    
    private func setupSubviews() {
        
        // Setup Subviews with constraints and anchors
        
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
        
        viewModel.errorMessage
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: Localizations.Global.Error, message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Localizations.Global.Ok, style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupViewObservables() {
        
        // Observe signals on local views

        // Checks the offset of the table but doesn't trigger anything if we are still loading. The signals for the content offset
        // and the loading observables are combined so they are always in sync
        
        let table = tableView // This is because `tableView` conflicts with the delegate methods in the array below
        let nearBottom = table.rx.nearBottomEdge.asObservable()
        let emptySpace = table.rx.gap.asObservable()
        
        Observable<Void>.merge([nearBottom, emptySpace])
            .subscribe({ [unowned self] _ in
                    
                self.viewModel.tableDidReachNearEnd()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        cellDismissed
            .subscribe(onNext: {  [unowned self] indexPath in
                self.viewModel.deleteItem(at: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Memory manager
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MessageListViewController: UITableViewDelegate {
    
    // Not using RxCocoa ControlEvents here because these functions return a value and that isn't supported by RxCocoa's methodInvoked function
    
    // This is a work around for `UITableViewAutomaticDimension` not being very accurate and causing the table view to jump when inserting cells.
    // It stores the heights
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else {
            return LayoutConstants.estimatedCellHeight
        }
        
        return height
    }

}

