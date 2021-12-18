//
//  Styles.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 1/2/20.
//  Copyright © 2020 Elliot Schrock. All rights reserved.
//

import UIKit
import LithoOperators

func setupAutoLayout(_ object: UIView) {
    object.translatesAutoresizingMaskIntoConstraints = false
}

func setupCorners(_ object: UIView) {
    object.layer.cornerRadius = 6
    object.clipsToBounds = true
}

func setupCircleCorners(_ object: UIView) {
    object.layer.cornerRadius = object.frame.size.height / 2
    object.clipsToBounds = true
}

func setupButtonTitle(_ object: UIButton) {
    object.setTitleColor(.buttonTextColor(), for: .normal)
}

func setupButtonBackground(_ object: UIView) {
    object.backgroundColor = UIColor.buttonBgColor()
}

func setupInvertedButtonTitle(_ object: UIButton) {
    object.setTitleColor(.invertedButtonTextColor(), for: .normal)
}

func setupInvertedButtonBackground(_ object: UIView) {
    object.backgroundColor = UIColor.invertedButtonBgColor()
}

let styleInvertedButton = union(setupCircleCorners, setupInvertedButtonBackground, setupInvertedButtonTitle)
