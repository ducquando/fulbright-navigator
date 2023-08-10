//  ARIndoorNav
//
//  DataModel.swift
//
//  Created by Bryan Ung on 5/18/20.
//  Modified by Duc Quan Do on 5/25/23.
//
//  The centralized source of Data within the application. Classes are able to retrieve instances of other data models/classes.

import Foundation
import UIKit
import ARKit
class DataModel {
    
    //MARK: - Properties
    
    static let dataModelSharedInstance = DataModel()
    var sceneView: ARSCNView?
    var mainVC: ViewController?
    var locationDetailsSharedInstance: LocationDetails?
    var locationManagerSharedInstance: LocationManager?
    var ARSCNViewDelegateSharedInstance: ViewAR?
    var nodeManagerSharedInstance: NodeManager?
    var dataStoreManagerSharedInstance: DataStoreManager?

    //MARK: - Helpers

    /// Initializes the locationManager
    private func initLocationManager(){
        self.locationManagerSharedInstance!.requestLocationAuth(success: {message in
        }, failure: {alertString in
            self.mainVC!.alert(info: alertString)
        })
        print(ConsoleConstants.locationManagerSuccess)
    }

    /// Inits the locationDetails
    func initLocationDetails(){
        self.locationDetailsSharedInstance?.reset()
        print(ConsoleConstants.locationDetailsSuccess)
    }

    /// Inits the initARSCNViewDelegate
    private func initARSCNViewDelegate(){
        print(ConsoleConstants.ARSCNViewSuccess)
    }

    /// Inits the initNodeManager
    private func initNodeManager(){
        self.nodeManagerSharedInstance?.reset()
        print(ConsoleConstants.nodeManagerSuccess)
    }

    /// Inits the initDataStoreManager
    private func initDataStoreManager(){
        print(ConsoleConstants.dataStoreManagerSuccess)
    }

    /// Resets navigation to a resting state
    func resetNavigationToRestingState(){
        getLocationDetails().reset()
        getNodeManager().reset()
        getARNSCNViewDelegate().reset()
    }
    
    //MARK: - Setters
    
    /// Sets locationManagerSharedInstance to a LocationManager
    func setLocationManager(locationManager: LocationManager){
        locationManagerSharedInstance = locationManager
        initLocationManager()
    }

    /// Sets locationDetailsSharedInstance to a LocationDetails
    func setLocationDetails(locationDetails: LocationDetails){
        locationDetailsSharedInstance = locationDetails
        initLocationDetails()
    }

    /// Sets dataStoreManagerSharedInstance to a DataStoreManager
    func setDataStoreManager(dataStoreManager: DataStoreManager){
        dataStoreManagerSharedInstance = dataStoreManager
        initDataStoreManager()
    }

    /// Sets ARSCNViewDelegateSharedInstance to a ViewAR
    func setARSCNViewDelegate(ARSCNViewDelegate: ViewAR){
        ARSCNViewDelegateSharedInstance = ARSCNViewDelegate
        initARSCNViewDelegate()
    }

    /// Sets nodeManagerSharedInstance to a NodeManager
    func setNodeManager(nodeManager: NodeManager){
        nodeManagerSharedInstance = nodeManager
        initNodeManager()
    }

    /// Sets mainVC to a ViewController
    func setMainVC(vc: ViewController) {
        self.mainVC = vc
    }

    /// Sets sceneView to a ARSCNView
    func setSceneView(view: ARSCNView) {
        self.sceneView = view
    }
    
    //MARK: - Getter Functions
    
    /// Get locationManagerSharedInstance
    func getLocationManager() -> LocationManager{
        return self.locationManagerSharedInstance!
    }

    /// Get locationDetailsSharedInstance
    func getLocationDetails() -> LocationDetails{
        return self.locationDetailsSharedInstance!
    }

    /// Get dataStoreManagerSharedInstance
    func getDataStoreManager() -> DataStoreManager{
        return self.dataStoreManagerSharedInstance!
    }

    /// Get ARSCNViewDelegateSharedInstance
    func getARNSCNViewDelegate() -> ViewAR{
        return self.ARSCNViewDelegateSharedInstance!
    }

    /// Get nodeManagerSharedInstance
    func getNodeManager() -> NodeManager{
        return self.nodeManagerSharedInstance!
    }

    /// Get mainVC
    func getMainVC() -> ViewController {
        return self.mainVC!
    }

    /// Get sceneView
    func getSceneView() -> ARSCNView {
        return self.sceneView!
    }
}
