//  ARIndoorNav
//
//  NodeManager.swift
//
//  Created by Bryan Ung on 6/4/20.
//  Modified by Duc Quan Do on 5/25/23.
//
//  This class is responsible for handling the generation of nodes, and all related
//  to the handling of nodes

import Foundation
import ARKit
class NodeManager {
    
    //MARK: - Properities
    static var nodeManagerSharedInstance = NodeManager()
    private var dataModelSharedInstance: DataModel?
    private var referencedBeaconName: String?
    private var referenceBeaconNode: SCNNode?
    private var lastReferencedNode: SCNNode?
    private var nodeList: Array<Index> = []
    private var scnNodeList: Array<SCNNode> = []
    private var lineNodeList: Array<SCNNode> = []
    private var startingNodeIsSet = false
    private var destinationNodeIsSet = false
    private var isNodeListGenerated = false
    private var destinationScnNode: SCNNode?
    
    private var beaconNode: SCNNode?
    private var arrowNode: SCNNode?
    
    //MARK: - Init
    private init (){
        self.dataModelSharedInstance = DataModel.dataModelSharedInstance
        configureArrow()
        configureBeacons()
    }
    
    //MARK: - SaveCustomMap
    
    /// Retrieves a custom map when finished creating a custom map.
    func retrieveCustomMap(_ destination: String) -> LocationInfo{
        let nodes = Nodes(index: nodeList)
        let locInfo = LocationInfo(destination: destination, beaconName: self.referencedBeaconName!, nodeCount: nodeList.count, nodes: nodes)
        print(locInfo)
        return locInfo
    }
    
    //MARK: - Node Configurations
    
    /// Configures the model of the beacon.
    private func configureBeacons(){
        DispatchQueue.main.async {
            let node = SCNNode()
            let beaconScene = SCNScene(named: "art.scnassets/diamond.scn")
            for childNode in beaconScene!.rootNode.childNodes{
                node.addChildNode(childNode)
            }
            self.beaconNode = node
        }
    }

    /// Configures the model of the arrow.
    private func configureArrow(){
        DispatchQueue.main.async {
            let node = SCNNode()
            let arrowScene = SCNScene(named: "art.scnassets/arrow.scn")
            for childNode in arrowScene!.rootNode.childNodes{
                node.addChildNode(childNode)
            }
            self.arrowNode = node
        }
    }
    
    //MARK: - Helper Functions

    /// Resets the class to resting state
    func reset(){
        self.lastReferencedNode = nil
        self.referencedBeaconName = nil
        self.referenceBeaconNode = nil
        self.nodeList = Array<Index>()
        self.lineNodeList = Array<SCNNode>()
        self.scnNodeList = Array<SCNNode>()
        self.startingNodeIsSet = false
        self.destinationNodeIsSet = false
        self.isNodeListGenerated = false
        self.destinationScnNode = nil
    }

    /// Adds a node (LocationInfo.Index) to the nodeList
    func addNode(node: Index){
        self.nodeList.append(node)
    }

    /// Adds a SCNNode to the scnNodeList
    func addScnNode(node: SCNNode){
        scnNodeList.append(node)
    }

    /// Adds a lineNode to the lineNodeList
    func addLineNode(node: SCNNode){
        lineNodeList.append(node)
    }

    /// Removes the last SCNNode from the scnNodeList
    func removeLastScnNode(){
        scnNodeList.removeLast()
    }

    /// Removes the last node (LocationInfo.Index) from the nodeList
    func removeLastNode(){
        nodeList.removeLast()
    }

    /// Removes the last line SCNNode from the lineNodeList
    func removeLastLineNode(){
        lineNodeList.removeLast()
    }

    /// Generates a nodeList to be constructed to use for navigation. If exist, return completion(true)
    func generateNodeList(completion: @escaping(Bool) -> Void){
        if (!isNodeListGenerated) {
            var destination = self.dataModelSharedInstance!.getLocationDetails().getDestination()
            destination = destination.lowercased()
            let beaconNodeScannedName = referencedBeaconName

            let infoArray : [String?] = [
                destination,
                beaconNodeScannedName
            ]
            
            // Sends a network request to retrieve a Map from the server
            NetworkService.networkServiceSharedInstance.requestNavigationInfo(URLConstants.navigationRequest, infoArr: infoArray){ result in
                    switch result{
                        case .failure(_):
                            completion(false)
                        case .success(let data):
                            let jsonDecoded = Formatter.FormatterSharedInstance.decodeJSONDestination(JSONdata: data)
                            if jsonDecoded != nil {
                                self.nodeList = Formatter.FormatterSharedInstance.buildNodeListWithJsonData(jsonDecoded: jsonDecoded!)
                                
                                self.setIsNodeListGenerated(isSet: true)
                                completion(true)
                            } else { completion(false); }
                    }
                }
        } else {
            completion(true)
        }
    }
    
    //MARK: - Setters

    /// Sets the nodeList to an Array of Index(LocationInfo.Index)
    func setNodeList(list: Array<Index>){
        self.nodeList = list
    }

    /// Sets referencedBeaconName to a String of the referenced beacon
    func setReferencedBeaconName(name: String?){
        self.referencedBeaconName = name
    }

    /// Sets the referenceBeaconNode to SCNNode
    func setReferencedBeaconNode(node: SCNNode){
        self.referenceBeaconNode = node
    }

    /// Sets startingNodeIsSet to a boolean value
    func setStartingNodeIsSet(isSet: Bool){
        self.startingNodeIsSet = isSet
    }

    /// Sets destinationNodeIsSet to a boolean value
    func setDestinationNodeIsSet(isSet: Bool){
        self.destinationNodeIsSet = isSet
    }

    /// Sets lastReferencedNode to a SCNNode
    func setLastReferencedNode (node: SCNNode){
        lastReferencedNode = node
    }

    /// Sets isNodeListGenerated to a boolean value
    func setIsNodeListGenerated(isSet: Bool){
        self.isNodeListGenerated = isSet
    }

    /// Sets destinationScnNode to a SCNNode
    func setdestinationScnNode(node: SCNNode){
        destinationScnNode = node
    }
    
    //MARK: - Getters
    /// Returns nodeList
    func getNodeList() -> Array<Index>{
        return self.nodeList
    }

    /// Returns the referencedBeaconName
    func getReferencedBeaconName() -> String? {
        return self.referencedBeaconName
    }

    /// Returns the referencedBeaconNode
    func getReferencedBeaconNode() -> SCNNode? {
        return self.referenceBeaconNode
    }

    /// Returns startingNodeIsSet
    func getStartingNodeIsSet() -> Bool {
        return self.startingNodeIsSet
    }

    /// Returns destinationNodeIsSet
    func getDestinationNodeIsSet() -> Bool {
        return self.destinationNodeIsSet
    }

    /// Returns the lastReferencedNode
    func getLastReferencedNode() -> SCNNode? {
        return lastReferencedNode
    }

    /// Returns a clone of the arrowNode
    func getArrowNode() -> SCNNode {
        return self.arrowNode!.clone()
    }

    /// Returns a clone of the beaconNode
    func getbeaconNode() -> SCNNode {
        return self.beaconNode!.clone()
    }

    /// Returns the last line node in lineNodeList
    func getLastLineNode() -> SCNNode? {
        return lineNodeList.last
    }

    /// Returns nodeList.last
    func getLastNode() -> Index? {
        return nodeList.last
    }

    /// Returns the last scnNode in scnNodeList
    func getLastScnNode() -> SCNNode? {
        return scnNodeList.last
    }
    
    /// Returns length of nodeList
    func getLengthOfNodeList() -> Int{
        return nodeList.count
    }

    /// Returns length of scnNodeList
    func getLengthOfScnNodeList() -> Int{
        return scnNodeList.count
    }

    /// Returns length of lineNodeList
    func getLengthOfLineNodeList() -> Int {
        return lineNodeList.count
    }

    /// Returns isNodeListGenerated
    func getIsNodeListGenerated() -> Bool {
        return isNodeListGenerated
    }

    /// Returns the destinationScnNode
    func getdestinationScnNode() -> SCNNode?{
        return destinationScnNode
    }
}
