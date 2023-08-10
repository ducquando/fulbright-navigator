//  ARIndoorNav
//
//  LocationDetails.swift
//
//  Created by Bryan Ung on 5/13/20.
//  Modified by Duc Quan Do on 5/25/23.
//

import CoreLocation
import Foundation
import SceneKit

class LocationDetails{
    static let LocationDetailsSharedInstance = LocationDetails()
    
    //MARK: - Properties
    var sourcePosition: CLLocationCoordinate2D?
    var destinationPosition: CLLocationCoordinate2D?
    var userPositionWhenFoundBeacon: SCNVector3?
    var isNavigating: Bool!
    var isBeaconRootNodeFound: Bool!
    var destination: String!
    var isCreatingCustomMap: Bool!
    var isWorldOriginSet: Bool!
    var isUploadingMap: Bool!
    
    var dataModelSharedInstance: DataModel?
    //MARK: - Init
    private init() {
        self.dataModelSharedInstance = DataModel.dataModelSharedInstance
        reset()
    }
    //MARK: - Helpers
    
    /// Resets data to resting state
    func reset(){
        isNavigating = false
        isBeaconRootNodeFound = false
        destination = nil
        isCreatingCustomMap = false
        isWorldOriginSet = false
        isUploadingMap = false
    }
    
    //MARK: Setters
    
    /// Sets isNavigating to a boolean value.
    func setIsNavigating(isNav: Bool){
        self.isNavigating = isNav
    }
    
    /// Sets isCreatingCustomMap to a boolean value.
    func setIsCreatingCustomMap(isCreatingCustomMap: Bool){
        self.isCreatingCustomMap = isCreatingCustomMap
    }
    
    /// Sets isBeaconRootNodeFound to a boolean value.
    func setIsBeaconRootNodeFound(isFound: Bool){
        self.isBeaconRootNodeFound = isFound
    }
    
    /// Sets destination to a String value.
    func setDestination(destination: String){
        self.destination = destination
    }
    
    /// Sets userPositionWhenFoundBeacon to a SCNVector3 value.
    func setUserPositionWhenFoundBeacon (pos: SCNVector3){
        self.userPositionWhenFoundBeacon = pos
    }
    
    /// Sets isWorldOriginSet to a Boolean value.
    func setIsWorldOriginSet (isSet: Bool){
        self.isWorldOriginSet = isSet
    }
    
    /// Sets isUploadingMap to a Boolean value.
    func setIsUploadingMap (isSet: Bool){
        self.isUploadingMap = isSet
    }
    
    //MARK: Getters
    
    /// Returns isNavigating
    func getIsNavigating() -> Bool {
        return isNavigating
    }
    
    /// Returns isCreatingCustomMap
    func getIsCreatingCustomMap() -> Bool{
        return self.isCreatingCustomMap
    }
    
    /// Returns isBeaconRootNodeFound
    func getIsBeaconRootNodeFound() -> Bool {
        return isBeaconRootNodeFound
    }
    
    /// Returns destination
    func getDestination() -> String{
        return self.destination
    }
    
    /// Returns the last known user position at the moment the last beacon was scanned
    func getUserPositionWhenFoundBeacon() -> SCNVector3 {
        return self.userPositionWhenFoundBeacon!
    }
    
    /// Returns boolean stating whether or not the world origin is set with the ARConfiguration
    func getIsWorldOriginSet() -> Bool {
        return isWorldOriginSet
    }
    
    /// Returns boolean stating whether or not the app is uploading a map
    func getIsUploadingMap() -> Bool {
        return isUploadingMap
    }
}
