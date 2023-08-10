//  ARIndoorNav
//
//  LocationManager.swift
//
//  Created by Bryan Ung on 5/13/20.
//  Modified by Duc Quan Do on 5/25/23.
//
//  Class is responsible for handling the geolocation of the user.

import Foundation
import CoreLocation
import ARKit

class LocationManager: NSObject, CLLocationManagerDelegate{
    static let locationManagerInstance = LocationManager()
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    var dataModelSharedInstance: DataModel?
    
    //MARK: - Init
    override init() {
        super.init()
        dataModelSharedInstance = DataModel.dataModelSharedInstance
    }
    
    //MARK: - Helper Functions
    /// Request user access to Location
    func requestLocationAuth(success: @escaping((String) -> Void), failure: @escaping((String) -> Void)){
        if CLLocationManager.locationServicesEnabled() == true {
            let manager = CLLocationManager()
            
            switch manager.authorizationStatus {
            case .restricted, .denied, .notDetermined:
                failure(AlertConstants.locationServiceError)
            default:
                locationManager.requestWhenInUseAuthorization()
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            }
        } else {
            failure(AlertConstants.locationServiceError)
        }
        success(ConsoleConstants.locationSuccess)
        self.locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}
