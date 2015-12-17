//
//  EndpointTableViewCell.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 5/23/15.
//  Copyright (c) 2015 Elliot Schrock. All rights reserved.
//

import UIKit

class EndpointTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.cardView.backgroundColor = UIColor.cardViewBgColor()
        self.nameLabel.textColor = UIColor.cardViewTextColor()
//        self.cardView.layer.shadowColor = UIColor.whiteColor().CGColor //UIColor(red: 221.0/255.0, green: 191.0/255.0, blue: 19.0/255.0, alpha: 1).CGColor
//        self.cardView.layer.shadowOffset = CGSizeMake(0, 2)
//        self.cardView.layer.shadowOpacity = 0.3
//        self.cardView.layer.shadowRadius = 4
        
        cardView.layer.cornerRadius = 4
    }
    
}
