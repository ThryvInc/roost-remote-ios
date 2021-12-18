//
//  AlarmTableViewCell.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 1/7/20.
//  Copyright © 2020 Elliot Schrock. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    var onSwitchToggled: ((Bool) -> Void)?
    
    @IBAction func switchToggled() {
        onSwitchToggled?(toggle.isOn)
    }
}
