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

        let panGesture = view.rx.panGesture(minimumNumberOfTouches: 1, maximumNumberOfTouches: 1) { (guestureRecognizer, delegate) in
            // This prevents the scroll view from scrolling unless this pan gesture has failed
            delegate.selfFailureRequirementPolicy = .custom { gestureRecognizer, otherGestureRecognizer in
                return otherGestureRecognizer.view is UIScrollView
            }
        }

        // This observer cancels the pan gesture if the user pans further in the Y direction,
        // this means that they probably want to scroll the table view instead
        let changed = panGesture
            .when(.changed)
            .subscribe(onNext: { gesture in
                
                let translation = gesture.translation(in: view)
                
                if fabs(translation.x) < fabs(translation.y) {
                    gesture.cancel()
                }
            })
        
        let translated = panGesture
            .when(.changed)
            .asTranslation()
            .subscribe(onNext: { translation, _ in
                view.transform = CGAffineTransform(translationX: translation.x, y: 0)
            })
        
        let ended = panGesture
            .when(.ended)
            .subscribe(onNext: { gesture in
                if view.transform.tx > view.frame.width/2 {
                    self.completeAnimation(withView: view, andTrigger: trigger)
                } else {
                    self.cancelAnimation(withView: view)
                }
            })
        
        // If the gesture is canceled don't try to complete the movement with the trigger closure,
        // the user probably doesn't want to delete the cell if the gesture was canceled
        let canceled = panGesture
            .when(.cancelled)
            .subscribe(onNext: { gesture in
                self.cancelAnimation(withView: view)
            })
        
        return Disposables.create([translated, changed, ended, canceled])
    }
    
    private func completeAnimation(withView view: UIView, andTrigger trigger: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform(translationX: view.superview?.frame.width ?? view.frame.width * 2, y: 0)
        }, completion: { _ in
            trigger()
        })
    }
    private func cancelAnimation(withView view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
