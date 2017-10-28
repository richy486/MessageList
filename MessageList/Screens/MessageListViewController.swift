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
import SDWebImage

class MessageListViewController: UIViewController {
    
    typealias ViewModel = MessageListViewModel
    
    // MARK: - Layout constants
    
    private struct LayoutConstants {
        static let contentInset = UIEdgeInsets(top: 12,
                                               left: 0,
                                               bottom: 0,
                                               right: 0)
    }
    
    // MARK: - Subviews
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = UITableViewAutomaticDimension
        view.estimatedRowHeight = 105 // TODO: can we do to programmatically?
        view.contentInset = LayoutConstants.contentInset
        view.separatorStyle = .none
        view.backgroundColor = .white
        view.allowsMultipleSelection = false
        view.allowsSelectionDuringEditing = false
        view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        return view
    }()
    
    // MARK: - Properties
    private let viewModel: ViewModel
    private let disposeBag = DisposeBag()
    private static let cellIdentifier = "messageListCellIdentifier"
    
    private let dataSource: RxTableViewSectionedAnimatedDataSource<MessageListSectionPresenter> = {
        
        return RxTableViewSectionedAnimatedDataSource(
            configureCell: { (dataSource, table, indexPath, item) in
                guard let cell = table.dequeueReusableCell(withIdentifier: MessageListViewController.cellIdentifier, for: indexPath) as? MessageCell else {
                    fatalError("Table view: \(table) not setup to handle MessageCell cells")
                }
                
//                let title = "id: \(item.id), \(item.heading)"
//                cell.headingLabel.text = title
//                
//                let hue = CGFloat(abs(title.hashValue) % 1000) / 1000.0
//                cell.backgroundColor = UIColor(hue: hue, saturation: 0.75, brightness: 1.0, alpha: 1.0)
//                
//                print("image url: \(item.iconImageUrl)")
//                cell.iconImageView.sd_setImage(with: item.iconImageUrl)
                cell.setup(withPresenter: item)
                
//                print("cell size: \(cell.frame.size)")
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
        
//        view.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.1803921569, blue: 0.5725490196, alpha: 1)
        
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
        
        // TODO: this doesn't account for deleting the bottom elements on the screen
        // Needs to check if the content size is smaller than the frame size too
        tableView.rx.contentOffset
            .withLatestFrom(viewModel.isLoading.asObservable()) { (offset: $0, isLoading: $1) }
            .flatMap { arg -> Observable<CGPoint> in
                !arg.isLoading
                    ? Observable<CGPoint>.just(arg.offset)
                    : Observable<CGPoint>.empty()
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
    }
    
    // MARK: - Memory manager

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            print("Deleting")
            self?.viewModel.deleteItem(at: indexPath)
            
            completionHandler(true)
        }
        
        return action
    }
}

extension MessageListViewController: UITableViewDelegate {
    
    // Not using RxCocoa ControlEvents here because these functions return a value and that isn't supported by RxCocoa's methodInvoked function
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

}

