//
//  ScrollView+NearEdge.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat? = nil) -> Bool {
        
        // Triggering when there is less than another screens worth of content below the current view
        // (content offset is at the top of the view)
        let tollerence = self.contentOffset.y + self.frame.size.height*2
        let height = self.contentSize.height
        return tollerence > height
    }
    
    func isGap() -> Bool {
        return self.contentSize.height < self.frame.size.height
    }
}

extension Reactive where Base: UIScrollView {
    var nearBottomEdge: ControlEvent<Void> {
        let observable = self.base.rx.contentOffset.asObservable()
            .flatMap { _ -> Observable<Void> in

                return self.base.isNearBottomEdge()
                    ? Observable<Void>.just(())
                    : Observable<Void>.empty()
            }
        return ControlEvent(events: observable)
    }
    
    var gap: ControlEvent<Void> {
        let observable = self.base.rx.observe(type(of: self.base.contentSize), "contentSize")
            .flatMap { _ -> Observable<Void> in
                
                return self.base.isGap()
                    ? Observable<Void>.just(())
                    : Observable<Void>.empty()
            }
        return ControlEvent(events: observable)
    }
}
