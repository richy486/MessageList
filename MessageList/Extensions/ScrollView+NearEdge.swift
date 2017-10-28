//
//  ScrollView+NearEdge.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit

private let defaultOffset = CGFloat(300)

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = defaultOffset) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
