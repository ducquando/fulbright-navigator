//  ARIndoorNav
//
//  Formatter.swift
//
//  Created by Bryan Ung on 7/27/20.
//  Modified by Duc Quan Do on 5/25/23.
//
//  This class serves as a formatter for information retrieved from the NodeJS Server

import Foundation
import Firebase

class Formatter{
    static let FormatterSharedInstance = Formatter()
    
    //MARK: Functions
    /// Decodes a Data Object into an array of strings: Alias = <DownloadableList> (Located in /Model/LocationInfo.DownloadableList)
    func decodeDownloadableCustomMapsNames(JSONdata: Data) -> DownloadableList? {
        let data = try? JSONDecoder().decode(DownloadableList.self, from: JSONdata)
        return data
    }

    /// Decodes a Data Object into a <LocationInfo> (LocationInfo.swift.LocationInfo) Object
    func decodeJSONDestination(JSONdata: Data) -> LocationInfo?{
        let data = try? JSONDecoder().decode(LocationInfo.self, from: JSONdata)
        return data
    }

    /// Decodes a Data Object into a <DestinationList> (LocationInfo.swift.DestinationList) Object to show queryable results to users on the search controller
    func decodeJSONDestinationList(JSONdata: Data) -> DestinationList?{
        let data = try? JSONDecoder().decode(DestinationList.self, from: JSONdata)
        return data
    }

    /// Decodes a JSON message which is of type <String>
    func decodeJSONMessage(JSONdata: Data) -> String{
        let str = String(decoding: JSONdata, as: UTF8.self)
        return str
    }

    /// Builds an Array<Index> (LocationInfo.swift.Index) which houses information on each node from start to finish. Called from NodeManager.generateNodeList
    func buildNodeListWithJsonData(jsonDecoded: LocationInfo) -> Array<Index>{
        let nodeCount = jsonDecoded.nodeCount
        let nodes = jsonDecoded.nodes.index
        var returnList = Array<Index>()
        
        for (index, nodeEntry) in nodes.enumerated(){
            let tempNode: Index
            if index == 0 {
                tempNode = Index(type: NodeType.start.rawValue, xOffset: nodeEntry.xOffset, yOffset: nodeEntry.yOffset, zOffset: nodeEntry.zOffset, descript: nodeEntry.descript)
            } else if index == nodeCount - 1{
                tempNode = Index(type: NodeType.destination.rawValue, xOffset: nodeEntry.xOffset, yOffset: nodeEntry.yOffset, zOffset: nodeEntry.zOffset, descript: nodeEntry.descript)
            } else {
                tempNode = Index(type: NodeType.intermediate.rawValue, xOffset: nodeEntry.xOffset, yOffset: nodeEntry.yOffset, zOffset: nodeEntry.zOffset, descript: nodeEntry.descript)
            }
            returnList.append(tempNode)
        }
        return returnList
    }
}
