//
//  GestureRecognizer+Cancel.swift
//  MessageList
//
//  Created by Richard Adem on 29/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit

// This cancels the gesture, we use the enable/disable method becuse we can't set the state directly
// It is called on the next cycle of the main thread so it doesn't conflict when calling this from
// observers of the gesture state
extension UIGestureRecognizer {
    func cancel() {
        DispatchQueue.main.async {
            self.isEnabled = false
            self.isEnabled = true
        }
    }
}
