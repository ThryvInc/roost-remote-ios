//
//  DevicesViewController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit
import LUX
import SDWebImage
import LithoOperators
import Prelude

class DevicesViewController: LUXMultiModelTableViewController<PlaceViewModel> {
    @IBOutlet weak var backgroundImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var devicesButton: UIButton?
    var onDevicesPressed: ((DevicesViewController) -> Void)?
    @IBOutlet weak var batchesButton: UIButton?
    var onBatchesPressed: ((DevicesViewController) -> Void)?
    @IBOutlet weak var addButton: UIButton?
    var onAddPressed: ((DevicesViewController) -> Void)?
    
    var place: Place?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.backgroundColor = .clear
        ifExecute(devicesButton, styleInvertedButton)
        ifExecute(batchesButton, styleInvertedButton)
        ifExecute(addButton, styleInvertedButton)
        
        setupView()
    }
    
    func setupView() {
        if let placeName = place?.name {
            titleLabel?.text = placeName
        }
//        tableView?.delegate = self
//        if let imageUrl = place?.imageUrl {
//            backgroundImageView.sd_setImage(with: URL(string: imageUrl))
//        }
    }
    
    @IBAction func devicesPressed() {
        onDevicesPressed?(self)
    }
    
    @IBAction func batchesPressed() {
        onBatchesPressed?(self)
    }
    
    @IBAction func addPressed() {
        onAddPressed?(self)
    }
}
