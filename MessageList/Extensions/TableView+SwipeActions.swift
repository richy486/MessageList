//
//  TableView+SwipeActions.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

//guard let returnValue = object as? T else {
//    throw RxCocoaError.castingError(object: object, targetType: resultType)
//}

//extension TableViewSectionedDataSource {
//    open func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let closeAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            print("OK, marked as Closed")
//            success(true)
//        })
//        closeAction.image = UIImage(named: "tick")
//        closeAction.backgroundColor = .purple
//
//        return UISwipeActionsConfiguration(actions: [closeAction])
//    }
//
//}

extension Reactive where Base: UITableView {
    
//    public var swipedLeading: ControlEvent<IndexPath> {
////        self.delegate.
//
//        let source = self.delegate.methodInvoked(#selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
//            .map { a in
//                return try castOrThrow(IndexPath.self, a[1])
//        }
//
//        return ControlEvent(events: source)
//    }
    
//    public var swipedLeading: ControlEvent<IndexPath> {
    
        // _ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
        // _:leadingSwipeActionsConfigurationForRowAt:
        
        // _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
        // _:didSelectRowAt:
        
//        UISwipeActionsConfiguration
//        optional public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
        
//        optional public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
//        public var itemMoved: ControlEvent<ItemMovedEvent> {
//            let source: Observable<ItemMovedEvent> = self.dataSource.methodInvoked(#selector(UITableViewDataSource.tableView(_:moveRowAt:to:)))
//                .map { a in
//                    return (try castOrThrow(IndexPath.self, a[1]), try castOrThrow(IndexPath.self, a[2]))
//            }
//
//            return ControlEvent(events: source)
//        }
//    public var swipedLeading: ControlEvent<ItemMovedEvent> {
//        let source: Observable<ItemMovedEvent> = self.dataSource.methodInvoked(#selector(UITableViewDataSource.tableView(_:moveRowAt:to:)))
//            .map { a in
//                return (try castOrThrow(IndexPath.self, a[1]), try castOrThrow(IndexPath.self, a[2]))
//        }
//
//        return ControlEvent(events: source)
//    }

        
// let source =      self.delegate.methodInvoked(#selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
//        let source = self.delegate.methodInvoked(#selector(UITableViewDelegate.tableView(_:leadingSwipeActionsConfigurationForRowAt:)))
//            .map { a in
//                return try castOrThrow(IndexPath.self, a[1])
//            }
//
//        return ControlEvent(events: source)
//    }
}
