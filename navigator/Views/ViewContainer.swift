//  ARIndoorNav
//
//  ViewContainer.swift
//
//  Created by Duc Quan Do on 5/25/23.
//
//  Class houses the main VC view, and the hamburger menu VC view. Controls when the views are shown/hidden, and helps serve as a central navigation handler to new VCs. Furthermore, it connects multiple VCs.

import UIKit

class ViewContainer: UIViewController {
    
    // MARK: - Properties
    
    /// Animation for the status bar on top
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    /// Status bar boolean hidden value
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    /// View Controller with ARSceneView
    var viewController: ViewController!
    /// Top Level Controller
    var viewCenter: UIViewController!
    var viewLogin: ViewLogin!
    var isExpanded = false
    var dataModelSharedInstance: DataModel!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
        self.initDataModel()
    }
    
    //MARK: - Helpers
    
    /// Configuration for the the viewCenter and viewController
    private func configureViewController(){
        viewController = ViewController()
        viewCenter = UINavigationController(rootViewController: viewController)
        guard let navController = viewCenter as? UINavigationController else {return}
        navController.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(viewCenter.view)
        addChild(viewCenter)
        viewCenter.didMove(toParent: self)
    }
    
    /// Initialization of the centralized DataModel
    private func initDataModel(){
        self.dataModelSharedInstance = DataModel.dataModelSharedInstance
        
        let ARSCNViewDelegateSharedInstance = ViewAR.ARSCNViewDelegateInstance
        let locationDetailsSharedInstance = LocationDetails.LocationDetailsSharedInstance
        let locationManagerSharedInstance = LocationManager.locationManagerInstance
        let nodeManagerSharedInstance = NodeManager.nodeManagerSharedInstance
        let dataStoreManagerSharedInstance = DataStoreManager.dataStoreManagerSharedInstance
        
        dataModelSharedInstance.setMainVC(vc: viewController)
        dataModelSharedInstance.setLocationDetails(locationDetails: locationDetailsSharedInstance)
        dataModelSharedInstance.setLocationManager(locationManager: locationManagerSharedInstance)
        dataModelSharedInstance.setARSCNViewDelegate(ARSCNViewDelegate: ARSCNViewDelegateSharedInstance)
        dataModelSharedInstance.setNodeManager(nodeManager: nodeManagerSharedInstance)
        dataModelSharedInstance.setDataStoreManager(dataStoreManager: dataStoreManagerSharedInstance)
        
        viewController.delegateViewContainer = self
        viewController.viewARDelegate = ARSCNViewDelegateSharedInstance
        ARSCNViewDelegateSharedInstance.delegate = viewController
        
        print(ConsoleConstants.dataModelSucces)
    }
    
    // MARK: - Handlers
    
}

/// Handles the action when any is clicked.
extension ViewContainer: ViewControllerDelegate{
    func handleMapsButton() {}
    func handleUndoButton() {}
    func handleAddButton() {}
    func handleEndButton() {}
    func handleSaveButton() {}
}
