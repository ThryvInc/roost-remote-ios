//
//  DevicesViewController.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 2/11/17.
//  Copyright © 2017 Elliot Schrock. All rights reserved.
//

import UIKit
import ThryvUXComponents
import SDWebImage

class DevicesViewController: THUXRefreshableTableViewController, UITableViewDelegate {
    @IBOutlet weak var backgroundImageView: UIImageView!
    var place: Place? {
        didSet {
            if let placeId = place?._id {
                self.viewModel = PlaceViewModel(placeId: placeId)
                
                setupView()
            }
        }
    }
    var viewModel: PlaceViewModel? {
        didSet {
            if let viewModel = viewModel {
                refreshableModelManager = THUXRefreshableNetworkCallManager(viewModel.call)
                
                viewModel.dataSource.tableView = self.tableView
                tableView.dataSource = viewModel.dataSource
                
                refreshableModelManager?.refresh()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshableModelManager?.refresh()
    }
    
    func setupView() {
        if let placeName = place?.name {
            title = placeName
        }
        if let imageUrl = place?.imageUrl {
            backgroundImageView.sd_setImage(with: URL(string: imageUrl))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let device = (viewModel?.dataSource.sections?.first?.items?[indexPath.row] as? DeviceTableItem)?.device {
            let endpointVC = EndpointsViewController(nibName: "EndpointsViewController", bundle: nil)
            let devDesc = DeviceDescription()
            devDesc.name = device.name
            devDesc.host = device.describer
            devDesc.device = device
            endpointVC.describer = devDesc
            navigationController?.pushViewController(endpointVC, animated: true)
        }
    }
}
