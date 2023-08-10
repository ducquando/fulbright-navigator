//  ARIndoorNav
//
//  LocationInfo.swift
//
//  Created by Bryan Ung on 9/8/20.
//  Modified by Duc Quan Do on 5/25/23.
//
//  This file contains the model structure of data structures.
//  Within the models include instructions for encoding/decoding

import Foundation

//MARK: - LocationInfo

enum LocatinInfoStringNames: String {
    case destination = "destination"
    case nodes = "nodes"
    case beaconName = "beacon_name"
    case nodeCount = "node_count"
}

class LocationInfo: NSObject, NSCoding, Codable {
    let destination: String
    let beaconName: String
    let nodeCount: Int
    let nodes: Nodes

    enum CodingKeys: String, CodingKey {
        case destination = "destination"
        case beaconName = "beacon_name"
        case nodeCount = "node_count"
        case nodes
    }

    /// Encodes the data with the given key
    func encode(with coder: NSCoder) {
        coder.encode(self.destination, forKey: LocatinInfoStringNames.destination.rawValue)
        coder.encode(self.nodeCount, forKey: LocatinInfoStringNames.nodeCount.rawValue)
        coder.encode(self.nodes, forKey: LocatinInfoStringNames.nodes.rawValue)
        coder.encode(self.beaconName, forKey: LocatinInfoStringNames.beaconName.rawValue)
    }

    /// On init, decodes the data with the given key
    required init?(coder decoder: NSCoder) {
        self.destination = decoder.decodeObject(forKey: LocatinInfoStringNames.destination.rawValue) as! String
        self.nodes = decoder.decodeObject(forKey: LocatinInfoStringNames.nodes.rawValue) as! Nodes
        self.beaconName = decoder.decodeObject(forKey: LocatinInfoStringNames.beaconName.rawValue) as! String
        self.nodeCount = decoder.decodeInteger(forKey: LocatinInfoStringNames.nodeCount.rawValue)
    }

    /// Inits the class with specific data
    init(destination: String, beaconName: String, nodeCount: Int, nodes: Nodes) {
        self.destination = destination
        self.beaconName = beaconName
        self.nodeCount = nodeCount
        self.nodes = nodes
    }

    /// Constructs and returns a JSON representation of the data within this class and
    func getJSON() -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(destination, forKey: LocatinInfoStringNames.destination.rawValue)
        dict.setValue(beaconName, forKey: LocatinInfoStringNames.beaconName.rawValue)
        dict.setValue(nodeCount, forKey: LocatinInfoStringNames.nodeCount.rawValue)
        dict.setValue(nodes.getJSON(), forKey: LocatinInfoStringNames.nodes.rawValue)
        return dict
    }
}
enum NodesStringNames: String {
    case indexArray = "index"
}

//MARK: - Nodes

class Nodes: NSObject, NSCoding, Codable {
    let index: [Index]

    /// Encodes the data with the given key
    func encode(with coder: NSCoder) {
        coder.encode(self.index, forKey: NodesStringNames.indexArray.rawValue)
    }
    
    /// On init, decodes the data with the given key
    required init?(coder decoder: NSCoder) {
        self.index = decoder.decodeObject(forKey: NodesStringNames.indexArray.rawValue) as! Array<Index>
    }

    /// Inits the class with specific data
    init(index: [Index]){
        self.index = index
    }

    /// Constructs and return a JSON representation of the data within this class
    func getJSON() -> NSMutableDictionary {
        let values = NSMutableDictionary()

        var indexArray = Array<NSMutableDictionary>()
        for item in index {
            indexArray.append(item.getJSON())
        }
        values.setValue(indexArray, forKey: NodesStringNames.indexArray.rawValue)

        return values
    }
}
enum IndexStringNames: String {
    case type = "type"
    case xOffset = "x_offset"
    case yOffset = "y_offset"
    case zOffset = "z_offset"
    case descript = "descript"
}
enum NodeType: String{
    case start = "start"
    case intermediate = "intermediate"
    case destination = "destination"
}

//MARK: - Index

class Index: NSObject, NSCoding, Codable {
    let type: NodeType.RawValue
    let xOffset, yOffset, zOffset: Float
    let descript: String
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case xOffset = "x_offset"
        case yOffset = "y_offset"
        case zOffset = "z_offset"
        case descript = "descript"
    }
    
    /// Encodes the data with the given key
    func encode(with coder: NSCoder) {
        coder.encode(self.type, forKey: IndexStringNames.type.rawValue)
        coder.encode(self.xOffset, forKey: IndexStringNames.xOffset.rawValue)
        coder.encode(self.yOffset, forKey: IndexStringNames.yOffset.rawValue)
        coder.encode(self.zOffset, forKey: IndexStringNames.zOffset.rawValue)
        coder.encode(self.descript, forKey: IndexStringNames.descript.rawValue)
    }

    /// Decodes the data with the given key on init
    required init?(coder decoder: NSCoder) {
        let temp = decoder.decodeObject(forKey: IndexStringNames.type.rawValue) as! String
        var retrievedType: String?
        switch temp{
            case NodeType.start.rawValue:
                retrievedType = NodeType.start.rawValue
            case NodeType.intermediate.rawValue:
                retrievedType = NodeType.intermediate.rawValue
            case NodeType.destination.rawValue:
                retrievedType = NodeType.destination.rawValue
            default:
                break
        }
        self.type = retrievedType!
        self.xOffset = decoder.decodeFloat(forKey: IndexStringNames.xOffset.rawValue)
        self.yOffset = decoder.decodeFloat(forKey: IndexStringNames.yOffset.rawValue)
        self.zOffset = decoder.decodeFloat(forKey: IndexStringNames.zOffset.rawValue)
        self.descript = decoder.decodeObject(forKey: IndexStringNames.descript.rawValue) as! String

    }

    /// Inits the class with specific data
    init(type: String, xOffset: Float, yOffset: Float, zOffset: Float, descript: String) {
        self.type = type
        self.xOffset = xOffset
        self.yOffset = yOffset
        self.zOffset = zOffset
        self.descript = descript
    }

    /// Constructs and return a JSON representation of the data within this class
    func getJSON() -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(type, forKey: IndexStringNames.type.rawValue)
        dict.setValue(xOffset, forKey: IndexStringNames.xOffset.rawValue)
        dict.setValue(yOffset, forKey: IndexStringNames.yOffset.rawValue)
        dict.setValue(zOffset, forKey: IndexStringNames.zOffset.rawValue)
        dict.setValue(descript, forKey: IndexStringNames.descript.rawValue)
        return dict
    }
}

// MARK: - DestinationList
typealias DestinationList = [String]

//MARK: - DownloadableLists
typealias DownloadableList = [String]
