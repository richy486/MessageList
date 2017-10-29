//
//  SwipePan.swift
//  MessageList
//
//  Created by Richard Adem on 29/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit
import RxSwift

protocol SwipePan {
    func setupSwipePan(withView view: UIView, trigger: @escaping () -> Void) -> Disposable
}

extension SwipePan {
    func setupSwipePan(withView view: UIView, trigger: @escaping () -> Void) -> Disposable {
        let panGesture = view.rx.panGesture().share(replay: 1)
        
        let changed = panGesture
            .when(.changed)
            .asTranslation()
            .subscribe(onNext: { translation, _ in
                view.transform = CGAffineTransform(translationX: translation.x, y: 0)
            })
        
        let ended = panGesture
            .when(.ended)
            .subscribe(onNext: { gesture in
                
                print("\(view.transform)")
                if view.transform.tx > view.frame.width/2 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                        view.transform = CGAffineTransform(translationX: view.frame.width * 3, y: 0)
                    }, completion: { _ in
                        trigger()
                    })
                } else {
                    //
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                        view.transform = CGAffineTransform.identity
                    }, completion: nil)
                }
            })
        
        return Disposables.create([changed, ended])
    }
}
