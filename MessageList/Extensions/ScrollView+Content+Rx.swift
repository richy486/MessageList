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
        let usingOffset = edgeOffset ?? self.frame.size.height*2
        
        // TODO: Maybe change this to be halfway through the content size rather than rely on the frame size
        return self.contentOffset.y + self.frame.size.height + usingOffset > self.contentSize.height
    }
    
    func isGap() -> Bool {
        return self.contentSize.height < self.frame.size.height
    }
}

extension Reactive where Base: UIScrollView {
    var nearBottomEdge: ControlEvent<Void> {
        let observable = self.base.rx.contentOffset.asObservable()
            .flatMap { _ in
                self.base.isNearBottomEdge()
                    ? Observable<Void>.just(())
                    : Observable<Void>.empty()
            }
        return ControlEvent(events: observable)
    }
    
    var gap: ControlEvent<Void> {
        let observable = self.base.rx.observe(type(of: self.base.contentSize), "contentSize")
            .flatMap { _ in
                self.base.isGap()
                    ? Observable<Void>.just(())
                    : Observable<Void>.empty()
            }
        return ControlEvent(events: observable)
    }
}
