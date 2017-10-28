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
        view.separatorStyle = .singleLine
        view.backgroundColor = .white
        view.allowsMultipleSelection = false
        view.allowsSelectionDuringEditing = false
        return view
    }()
    
    // MARK: - Properties
    private let viewModel: ViewModel
    private let disposeBag = DisposeBag()
    private static let cellIdentifier = "messageListCellIdentifier"
    
    private let dataSource: RxTableViewSectionedReloadDataSource<MessageListSectionPresenter> = {
        return RxTableViewSectionedReloadDataSource(
            configureCell: { (dataSource, table, indexPath, item) in
                guard let cell = table.dequeueReusableCell(withIdentifier: MessageListViewController.cellIdentifier, for: indexPath) as? MessageCell else {
                    fatalError("Table view: \(table) not setup to handle MessageCell cells")
                }
                cell.textLabel?.text = "\(item.title)"
                
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
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageListViewController.cellIdentifier)

        setupSubviews()
        setupViewModelObservables()
        setupViewObservables()
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
    }
    
    private func setupViewObservables() {
        
        // Observe signals on local views

        // Checks the offset of the table but doesn't trigger anything if we are still loading. The signals for the content offset
        // and the loading observables are combined so they are always in sync
        tableView.rx.contentOffset
            .withLatestFrom(viewModel.isLoading.asObservable()) { (offset: $0, isLoading: $1) }
            .flatMap { arg -> Observable<CGPoint> in
                (!arg.isLoading ? Observable<CGPoint>.just(arg.offset) : Observable<CGPoint>.empty())
            }
            .flatMap { [unowned self] offset in
                self.tableView.isNearBottomEdge()
                    ? Observable<Void>.just(())
                    : Observable<Void>.empty()
            }
            .subscribe({ [unowned self] _ in //value in
                print("trigger \(Date().timeIntervalSince1970)")
                self.viewModel.tableDidReachNearEnd()
            })
            .disposed(by: disposeBag)
        
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
//        tableView.rx.swipedLeading.subscribe(onNext: { indexPath in
//            print("swiped: \(indexPath)")
//        })
//        .disposed(by: disposeBag)
    }
    
    // MARK: - Memory manager

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
//    func contextualToggleReadAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
////        var email = data[indexPath.row]
////        let title = email.isNew ? "Mark as Read" : "Mark as Unread"
//        let action = UIContextualAction(style: .normal, title: "clear") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
////            if email.toggleReadFlag() {
////                self.data[indexPath.row] = email
////                self.tableView.reloadRows(at: [indexPath], with: .none)
////                completionHandler(true)
////            } else {
////                completionHandler(false)
////            }
//            self.tableView.reloadRows(at: [indexPath], with: .none)
//            completionHandler(true)
//        }
//        action.backgroundColor = UIColor.blue
//        return action
//    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            print("Deleting")
//            self.data.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .left)
            self?.viewModel.deleteItem(at: indexPath)
            
            completionHandler(true)
        }
        
        return action
    }
    
//    func contextualToggleFlagAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
////        var email = data[indexPath.row]
//        let action = UIContextualAction(style: .normal, title: "Flag") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
////            if email.toggleFlaggedFlag() {
////                self.data[indexPath.row] = email
////                self.tableView.reloadRows(at: [indexPath], with: .none)
////                completionHandler(true)
////            } else {
////                completionHandler(false)
////            }
//            self.tableView.reloadRows(at: [indexPath], with: .none)
//            completionHandler(true)
//        }
////        action.image = UIImage(named: "flag")
////        action.backgroundColor = email.isFlagged ? UIColor.gray : UIColor.orange
//        action.backgroundColor = UIColor.orange
//        return action
//    }
}

//func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool

extension MessageListViewController: UITableViewDelegate {
    
    // Not using RxCocoa ControlEvents here because these functions return a value and that isn't supported by RxCocoa's methodInvoked function
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let swipeConfig = UISwipeActionsConfiguration(actions: [self.contextualToggleReadAction(forRowAtIndexPath: indexPath)])
//        return swipeConfig
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
//        let flagAction = self.contextualToggleFlagAction(forRowAtIndexPath: indexPath)
//        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, flagAction])
//        return swipeConfig
//    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

}

