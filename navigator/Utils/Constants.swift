//  ARIndoorNav
//
//  Constants.swift
//
//  Created by Bryan Ung on 5/13/20.
//  Modified by Duc Quan Do on 5/25/23.
//
//  This swift file provides constants that is used throughout the app.

import Foundation
import UIKit

//let ipaddress = "192.168.1.4"
let ipaddress = "10.212.2.2"
let portal = "8888"

struct AppThemeColorConstants{
    static let fulbrightBlue = UIColor(red: 0/255, green: 25/255, blue: 111/255, alpha: 1)
    static let fulbrightGold = UIColor(red: 255/255, green: 173/255, blue: 29/255, alpha: 1)
    static let fulbrightStone: UIColor = UIColor(red: 255/255, green: 255/255, blue: 222/255, alpha: 1)
    static let fulbrightSky: UIColor = UIColor(red: 206/255, green: 237/255, blue: 246/255, alpha: 1)
    static let white : UIColor = .white
    static let red: UIColor = .red
    
}
struct TableViewConstants {
    static let rowHeight: CGFloat = 80
    static let width: CGFloat = 24
    static let height: CGFloat = 24
    static let leftPadding: CGFloat = 12
    static let font: CGFloat = 18
}
struct MapViewConstants{
    static let height: CGFloat = 40
    static let width: CGFloat = 40
    static let font: CGFloat = 30
    static let leftDescriptionPadding: CGFloat = 30
}
struct ButtonConstants{
    static let topPadding: CGFloat = 9
    static let rightPadding: CGFloat = -9
    static let leftPadding: CGFloat = 9
    static let width: CGFloat = 60
    static let height: CGFloat = 60
    static let font: CGFloat = 20
    static let distanceBetweenButtons: CGFloat = 30
}
struct BottomLabelConstants{
    static let heightOffset = -40
    static let height: CGFloat = 60
    static let leftPadding: CGFloat = 25
    static let rightPadding: CGFloat = -25
    static let bottomPadding: CGFloat = -100
    static let fontSize: CGFloat = 24
}
struct AlertConstants{
    static let arErrorMessage = "Device does not support ARConfiguration"
    static let locationServiceError = "Location Services needs to be enabled"
    static let cameraAccessErrorMessage = "Camera needs to be enabled"
    static let serverRequestFailed = "Failure to connect/retrieve data from server"
    static let notLoggedIn = "Please Login To Continue."
    static let selectMapToUpload = "Select a map to upload."
    static let failedMapUpload = "Map failed to upload."
    static let createMapToUpload = "Please create at least one map before attempting to upload."
    static let randomError = "A error occurred. Please try again."
    static let cameraAccessError = "Camera usage was denied. \n\nPlease enable it by going to Settings > ARIndoorNav > Camera"
}
struct TextConstants{
    static let findBeaconText = "Scan a beacon to begin navigation"
    static let beaconFound = "Beacon Found!"
    static let navigationBegan = "Beginning navigation..."
    static let findBeaconToBuildCustomMap = "Scan a beacon to begin the process"
    static let beaconFoundAddStartNode = "Add starting node"
    static let startNodeAddedAddIntermediate = "Add Intermediate node(s)\nAdd End Node When Done"
    static let endNodePlaced = "Select Save to save your map"
    static let passwordRequirements = "Passwords must be at least 6 characters long"
    static let destinationReached = "Destination Reached"
}
struct ConsoleConstants{
    static let locationSuccess = "Location Retrieved Succesfully"
    static let dataModelSucces = "Data Model Setup Successfully"
    static let locationDetailsSuccess = "Location Details SetUp Successfully"
    static let locationManagerSuccess = "Location Manager SetUp Successfully"
    static let ARSCNViewSuccess = "ARKit Scene View SetUp Sucessfully"
    static let nodeManagerSuccess = "Node Manager SetUp Sucessfully"
    static let dataStoreManagerSuccess = "DataStore SetUp Successfully"
    static let customMapSaveSuccess = "***DataStore Saved Sucessfully***"
    static let dataStoreDataLoadedSuccess = "***DataStore Loaded Successfully***"
}
struct ArkitNodeDimension {
    static let arrowNodeXOffset = CGFloat(0.1)
}
struct URLConstants {
    static let navigationRequest = "http://\(ipaddress):\(portal)/NavigationInstructions"
    static let destinationListRequest = "http://\(ipaddress):\(portal)/DestinationList"
    static let uploadCustomMapRequest = "http://\(ipaddress):\(portal)/UploadCustomMap"
    static let downloadableMapNames = "http://\(ipaddress):\(portal)/DownloadCustomMapNames"
    static let downloadCustomMap = "http://\(ipaddress):\(portal)/DownloadCustomMap"
}
