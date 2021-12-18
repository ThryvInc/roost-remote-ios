//
//  DevicesFlowCoordinator.swift
//  Roost Remote
//
//  Created by Elliot Schrock on 12/31/19.
//  Copyright © 2019 Elliot Schrock. All rights reserved.
//

import LUX
import LithoOperators
import Combine
import MultiModelTableViewDataSource

class DevicesFlowCoordinator: LUXFlowCoordinator {
    private var place: Place?
    private var placeVM: PlaceViewModel?
    private var placesCall: CombineNetCall?
    private var cancelBag = Set<AnyCancellable?>()
    private var batchFC: BatchesFlowCoordinator?
    private var batchDelegate: LUXTappableTableDelegate?
    
    func initialVC() -> UIViewController? {
        let mainVC = DevicesViewController.makeFromXIB()
        placesCall = getPlacesCall()
        let modelPub: AnyPublisher<[Place], Never> = modelPublisher(from: placesCall!.responder!.$data.eraseToAnyPublisher())
        cancelBag.insert(modelPub.sink { (places) in
            self.place = places.first
            self.setupDevices(mainVC)
        })
        placesCall?.fire()
        
        mainVC.onDevicesPressed = setupDevices
        mainVC.onBatchesPressed = setupBatches
        mainVC.onAddPressed = addNewBatch
        
        let navVC = UINavigationController(rootViewController: mainVC)
        navVC.modalTransitionStyle = .crossDissolve
        navVC.modalPresentationStyle = .fullScreen
        return navVC
    }
    
    func setupDevices(_ mainVC: DevicesViewController) {
        if let place = self.place {
            mainVC.place = place

            if let placeId = place._id {
                self.placeVM = PlaceViewModel(placeId: placeId)
            }
            mainVC.viewModel = self.placeVM
            mainVC.refreshableModelManager = LUXRefreshableNetworkCallManager(mainVC.viewModel!.call)
            mainVC.tableViewDelegate = LUXTappableTableDelegate { indexPath in
                if let device = mainVC.viewModel?.models[indexPath.row] {
                    let endpointVC = EndpointsViewController.makeFromXIB()
                    let devDesc = DeviceDescriber()
                    devDesc.name = device.name
                    devDesc.host = device.describer
                    devDesc.device = device
                    endpointVC.describer = devDesc
                    mainVC.navigationController?.pushViewController(endpointVC, animated: true)
                }
            }
            mainVC.refresh()
            mainVC.setupView()
        }
    }
    
    func setupBatches(_ vc: DevicesViewController) {
        let sub = CurrentValueSubject<[Flow], Never>(flows())
        let executeFlow: (Flow) -> Void = { $0.executeTasks() }
        let editFlow: (Flow) -> Void = { flow in
            save(flows: flows().filter { $0.name != flow.name })
            if let _ = self.batchFC {
            } else {
                self.batchFC = BatchesFlowCoordinator(devices: self.placeVM!.models)
            }
            let editVC = self.batchFC?.initialVC() as? CreateBatchViewController
            editVC?.flow = flow
            editVC?.devices = self.placeVM?.models
            if let edit = editVC {
                vc.pushAnimated(edit)
            }
        }
        
        let vm = LUXModelListViewModel(modelsPublisher: sub.eraseToAnyPublisher(),
                                       modelToItem: executeFlow >||> (editFlow >|||> flowToItem))
        
        batchDelegate = LUXTappableTableDelegate(vm.dataSource)
        vm.dataSource.tableView = vc.tableView
        vc.tableView?.dataSource = vm.dataSource
        vc.tableView?.delegate = batchDelegate
        vc.tableView?.reloadData()
    }
    
    func addNewBatch(_ vc: DevicesViewController) {
        if let devices = self.placeVM?.models {
            batchFC = BatchesFlowCoordinator(devices: devices)
        }
        if let editVC = batchFC?.initialVC() {
            vc.pushAnimated(editVC)
        }
    }
}

func flowToItem(_ flow: Flow, tappedFlow: @escaping (Flow) -> Void, longTappedFlow: @escaping (Flow) -> Void) -> MultiModelTableViewDataSourceItem {
    return configuratorToItem(configurer: flowCellConfig(flow), onTap: voidCurry(flow, tappedFlow), onLongTap: voidCurry(flow, longTappedFlow))
}

func flowCellConfig(_ flow: Flow) -> (UITableViewCell) -> Void {
    return { cell in
        cell.textLabel?.text = flow.name
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
    }
}

func configuratorToItem(configurer: @escaping (UITableViewCell) -> Void, onTap: @escaping () -> Void, onLongTap: @escaping () -> Void) -> MultiModelTableViewDataSourceItem {
    return LongTappableFunctionalMultiModelItem<LongTapDetailsTableViewCell>(identifier: "flowcell", configurer, onTap, onLongTap)
}

public protocol LongTappable {
    var onLongTap: () -> Void { get set }
}

open class LongTappableFunctionalMultiModelItem<T>: TappableFunctionalMultiModelItem<T>, LongTappable where T: UITableViewCell {
    public var onLongTap: () -> Void
    
    public init(identifier: String, _ configureCell: @escaping (UITableViewCell) -> Void, _ onTap: @escaping () -> Void, _ onLongTap: @escaping () -> Void) {
        self.onLongTap = onLongTap
        let configureLongTap = { (cell: UITableViewCell) in
            if let longTapCell = cell as? LongTapDetailsTableViewCell {
                if let longTap = longTapCell.longTap {
                    longTapCell.removeGestureRecognizer(longTap)
                }
                let longTap = UILongPressGestureRecognizer(target: longTapCell, action: #selector(longTapCell.longPress))
                longTapCell.addGestureRecognizer(longTap)
                longTapCell.longTap = longTap
                
                longTapCell.onLongTap = onLongTap
            }
        }
        super.init(identifier: identifier, union(configureLongTap, configureCell), onTap)
    }
    
//    open func configureLongTap(_ cell: UITableViewCell) {
//        if var longTapCell = cell as? LongTappable {
//            longTapCell.onLongTap = self.onLongTap
//        }
//    }
}
