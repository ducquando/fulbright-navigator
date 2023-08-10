//  ARIndoorNav
//
//  Protocols.swift
//
//  Created by Bryan Ung on 6/30/20.
//  Modified by Duc Quan Do on 5/25/23.
//
//  This swift file houses the protocol definitions that classes within the app use

import Foundation
protocol ViewControllerDelegate {
    func handleAddButton()
    func handleUndoButton()
    func handleEndButton()
}
protocol ViewSearchDelegate{
    func destinationFound(destination: String)
}
protocol ViewMapsDelegate{
    func createCustomMapProcess()
}
protocol ViewARScnDelegate{
    func destinationReached()
    func toggleUndoButton(shouldShow: Bool)
    func toggleEndButton(shouldShow: Bool)
    func toggleSaveButton(shouldShow: Bool)
    func toggleAddButton(shouldShow: Bool)
}
protocol ViewLoginDelegate {
    func handleLoginButton()
}
