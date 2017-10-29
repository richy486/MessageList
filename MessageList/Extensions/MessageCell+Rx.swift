//
//  MessageCell+Rx.swift
//  MessageList
//
//  Created by Richard Adem on 29/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    
//    var dismissedCellAtIndexPath: Observable<IndexPath> {
//        let selectObservable = base.tableView.rx.tapGesture()
//            .when(.recognized)
//            .flatMap({ tapGesture -> Observable<Int> in
//                
//                let location = tapGesture.location(in: self.base.collectionView)
//                guard let indexPath = self.base.collectionView.indexPathForItem(at: location) else {
//                    return Observable.empty()
//                }
//                
//                return Observable.just(indexPath.item)
//                
//            })
//        
//        return selectObservable
//        
//    }
}
