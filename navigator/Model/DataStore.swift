//  ARIndoorNav
//
//  DataStore.swift
//
//  Created by Bryan Ung on 5/18/20.
//  Modified by Duc Quan Do on 5/25/23.
//
//  This class is responsbile for storing/persisting of variables

import Foundation

enum DataStoreStringNames: String{
    case locationInfo = "locationInfo"
}

class DataStore: NSObject, NSCoding {
    
    //MARK: - Properties
    
    private var locationInfoList: Array<LocationInfo> = []
    
    //MARK: - Init
    override init() {
        super.init()
    }
    
    //MARK: - Helper
    
    /// Sets locationInfoList to a Array<LocationInfo>
    func setLocationInfoList(list: Array<LocationInfo>){
        self.locationInfoList = list
    }

    /// Returns locationInfoList
    func getLocationInfoList() -> Array<LocationInfo> {
        return self.locationInfoList
    }
    
    //MARK: - Encode

    /// Function which is called when app attempts to ArchiveData
    func encode(with coder: NSCoder) {
        coder.encode(self.locationInfoList, forKey: DataStoreStringNames.locationInfo.rawValue)
    }
    
    //MARK: - Decode

    /// Called when app attempts to unarchiveTopLevelObjectWithData. Sets the locationInfoList to saved LocationInfo Array
    required init?(coder decoder: NSCoder) {
        super.init()
        self.locationInfoList = decoder.decodeObject(forKey: DataStoreStringNames.locationInfo.rawValue) as! Array<LocationInfo>
    }
}
