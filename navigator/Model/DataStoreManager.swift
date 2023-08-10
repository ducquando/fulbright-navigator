//  ARIndoorNav
//
//  DataStoreManager.swift
//
//  Created by Bryan Ung on 5/18/20.
//  Modified by Duc Quan Do on 5/25/23.
//
//  This class is responsible for all actions performed on the DataStore such as saving data

import Foundation

enum DataStoreManagerStringNames: String {
    case dataStoreManager = "dataStoreManager"
}

final class DataStoreManager {
    
    //MARK: - Properties
    
    static let dataStoreManagerSharedInstance: DataStoreManager = DataStoreManager()
    var dataStore = DataStore()
    
    //MARK: - Init

    private init() {
        do {
            let defaults = UserDefaults.standard
            let decoded = defaults.object(forKey: DataStoreManagerStringNames.dataStoreManager.rawValue)
            if decoded != nil {
                let dataStore = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [DataStore.self, DataStore.self], from: decoded as! Data) as? DataStore
//                let dataStore = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded as! Data)
                if dataStore != nil {
                    self.dataStore = dataStore!
                    print(ConsoleConstants.dataStoreDataLoadedSuccess)
                }
            }
        }
        
    }
    
    //MARK: - Save
    
    /// Saves dataStore data to the device.
    func saveDataStore() {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: self.dataStore, requiringSecureCoding: false)
            //let encodedData = NSKeyedArchiver.archivedData( withRootObject: self.dataStore)
            let defaults = UserDefaults.standard
            defaults.set(encodedData, forKey: DataStoreManagerStringNames.dataStoreManager.rawValue)
        } catch {
            let nsError = error as NSError
            print(nsError.localizedDescription)
        }
        print(ConsoleConstants.customMapSaveSuccess)
    }
}
