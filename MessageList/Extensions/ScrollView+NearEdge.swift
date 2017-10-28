//
//  ScrollView+NearEdge.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat? = nil) -> Bool {
        let usingOffset = edgeOffset ?? self.frame.size.height*2
        
        // TODO: Maybe change this to be halfway through the content size rather than rely on the frame size
        return self.contentOffset.y + self.frame.size.height + usingOffset > self.contentSize.height
    }
}
