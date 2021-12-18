//
//  LongTapDetailsTableViewCell.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 1/2/20.
//  Copyright © 2020 Elliot Schrock. All rights reserved.
//

import UIKit

class LongTapDetailsTableViewCell: DetailsTableViewCell, LongTappable {
    public var onLongTap: () -> Void = {}
    public var longTap: UIGestureRecognizer?

    @objc func longPress(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .ended {
            onLongTap()
        }
    }
}
