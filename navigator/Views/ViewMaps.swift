//  ARIndoorNav
//
//  ViewMaps.swift
//
//  Created by Duc Quan Do on 05/21/23.
//
//  This class is a separate ViewController which is navigated to by the Hamburger Menu button on the main View Controller. This handles all actions regarded to the mangagement of maps. Users can kick off uploading a map, starting navigation using a custom map, or downloading custom maps.

import UIKit
import Firebase

//Reuse Identifer Variable for the table cells.
private let reuseIdentifier = "MapOption"

class ViewMaps: UIViewController {
    
    // MARK: - Properties
    var tableView: UITableView!
    var dataModelSharedInstance: DataModel?
    var manageViewMapsDelegate: ViewMapsDelegate?
    var cancelButton = UIButton(type: .system) as UIButton
    
    // MARK: - Init
    /// Initialization of the datamodel instance, view, and table
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataModelSharedInstance = DataModel.dataModelSharedInstance
        resetState()
        hideKeyboardWhenTappedAround()
        configureUI()
        configureTableView()
    }
    
    // MARK: - Selectors
    /// Dismisses the View Controller when the navigation Bar left button is clicked.
    @objc func handleDismiss(){
        self.dismiss(animated: true, completion: nil)
        self.dataModelSharedInstance!.getLocationDetails().setIsUploadingMap(isSet: false)
    }

    /// Handles the Navigation Bar Right Button when clicked.
    @objc func handleAdd(){
        generatePopUp()
    }

    /// Handles the cancel button when clicked.
    @objc func handleCancel(){
        toggleCancelButton(shouldShow: false)
        self.dataModelSharedInstance!.getLocationDetails().setIsUploadingMap(isSet: false)
    }
    
    // MARK: - Helper Functions
    /// Resets the View Controller state to the normal state by resetting the DataModel.LocationDetails variables to false
    private func resetState(){
        self.dataModelSharedInstance!.getLocationDetails().setIsCreatingCustomMap(isCreatingCustomMap: false)
        self.dataModelSharedInstance!.getLocationDetails().setIsUploadingMap(isSet: false)
    }

    /// This function is called when the button on the ViewMaps (top right) is clicked.
    /// It presents an actionsheet with options to 'create' 'upload' 'download' a custom map.
    private func generatePopUp(){
        // Gets the number of custom maps stored on the device.
        let listCount = dataModelSharedInstance!.getDataStoreManager().dataStore.getLocationInfoList().count
        let alertController = UIAlertController(title: nil, message: "What would you like to do?", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Create New Map", style: .default, handler: { _ in
            self.dataModelSharedInstance!.getLocationDetails().setIsCreatingCustomMap(isCreatingCustomMap: true)
            // Refers to delegate, ViewContainer and calls the function createCustomMapProcess() which invokes the main VC (housing the ARSceneView) to begin creating a custom map.
            self.manageViewMapsDelegate!.createCustomMapProcess()
            self.dismiss(animated: true, completion: nil)
        }))
        
        // User will only allow uploading of maps if they are logged in.
        alertController.addAction(UIAlertAction(title: "Upload Maps", style: .default, handler: { _ in
            if Auth.auth().currentUser == nil {
                self.alert(info: AlertConstants.notLoggedIn)
            } else if (listCount <= 0){
                // If there are no saved maps, you can't upload a map.
                self.alert(info: AlertConstants.createMapToUpload)
            } else {
                // Prepares user to click on a map to upload
                self.alert(info: AlertConstants.selectMapToUpload)
                self.dataModelSharedInstance!.getLocationDetails().setIsUploadingMap(isSet: true)
                self.dataModelSharedInstance!.getLocationDetails().setIsCreatingCustomMap(isCreatingCustomMap:false)
                self.toggleCancelButton(shouldShow: true)
            }
        }))
        
        // Users will only be allowed to download maps if they are logged in.
        alertController.addAction(UIAlertAction(title: "Download Maps", style: .default, handler: { _ in
            if Auth.auth().currentUser == nil {
                self.alert(info: AlertConstants.notLoggedIn)
            } else {
                let loadingIndicator = ViewController.getLoadingIndicator()
                DispatchQueue.main.async {
                    self.present(loadingIndicator, animated: false, completion: nil)
                    self.toggleCancelButton(shouldShow: false)
                    self.dataModelSharedInstance!.getLocationDetails().setIsUploadingMap(isSet: false)
                    self.dataModelSharedInstance!.getLocationDetails().setIsCreatingCustomMap(isCreatingCustomMap:false)
                }
                // Network request to the node.js server to get a list of downloaded custom map names.
                NetworkService.networkServiceSharedInstance.requestDownloadCustomMapNames(URLConstants.downloadableMapNames, uid: Auth.auth().currentUser!.uid, completion: { results in
                    switch results{
                        case .failure(_):
                            DispatchQueue.main.async {
                                loadingIndicator.dismiss(animated: false, completion: {
                                    self.alert(info: AlertConstants.serverRequestFailed)
                                })
                            }
                        case .success(let data):
                            DispatchQueue.main.async {
                                loadingIndicator.dismiss(animated: false, completion: {
                                    self.generateDownloadableOptionsAlert(data: data)
                                })
                            }
                    }
                })
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))

        present(alertController, animated: true, completion: nil)
    }

    /// Receives data from the node.js server and parses it into a list of selectable names for a user to select which map to download.
    private func generateDownloadableOptionsAlert(data: Data) {
        let options = Formatter.FormatterSharedInstance.decodeDownloadableCustomMapsNames(JSONdata: data)
        if options != nil {
            let alertController = UIAlertController(title: "Select the Custom Map to download", message: "Note: Maps with the same name will be overwritten", preferredStyle: .alert)
            
            for (_, ele) in options!.enumerated() {
                alertController.addAction(UIAlertAction(title: ele, style: .default, handler: { (action) in
                    let title = action.title
                    self.downloadCustomMap(title: title!)
                }))
            }
            alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.present(alertController, animated: false, completion: nil)
        } else {
            self.alert(info: "No Custom Maps are saved in your profile")
        }
    }

    /// Receives a title of the name of the map the user wants to download. It uses this name to make a request to the node.js server for navigation information which then saves the map to the user's device.
    private func downloadCustomMap(title: String) {
        let loadingIndicator = ViewController.getLoadingIndicator()
        DispatchQueue.main.async {
            self.present(loadingIndicator, animated: false, completion: nil)
        }
        
        // Request to the network service handler - NetworkService.swift
        NetworkService.networkServiceSharedInstance.requestDownloadCustomMap(URLConstants.downloadCustomMap, mapName: title, uid: Auth.auth().currentUser!.uid, completion: { result in
            switch result{
            case .failure(_):
                DispatchQueue.main.async {
                        loadingIndicator.dismiss(animated: false, completion: {
                        self.alert(info: AlertConstants.serverRequestFailed)
                    })
                }
            case .success(let data):
                DispatchQueue.main.async {
                        loadingIndicator.dismiss(animated: false, completion: {
                            // Decodes the data through a formatter class.
                            let locInfo = Formatter.FormatterSharedInstance.decodeJSONDestination(JSONdata: data)
                            let ds = DataStoreManager.dataStoreManagerSharedInstance.dataStore
                            var list = ds.getLocationInfoList()
                            
                            // Loops through currently saved maps, if the name matches the one that was just downloaded, it is removed.
                            for (i, e) in list.enumerated(){
                                if e.destination == title {
                                    list.remove(at: i)
                                }
                            }
                            list.append(locInfo!)
                            ds.setLocationInfoList(list: list)
                            DataStoreManager.dataStoreManagerSharedInstance.saveDataStore()
                            
                            self.tableView.reloadData()
                    })
                }
            }
        })
    }

    /// Toggles the visibility of the cancel button.
    func toggleCancelButton(shouldShow : Bool){
        if shouldShow{
            configureCancelButton()
        } else {
            cancelButton.removeFromSuperview()
        }
    }
    
    //MARK: -Configurations

    /// Configures the UI of the VC.
    private func configureUI(){
        view.backgroundColor = AppThemeColorConstants.fulbrightBlue
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 0/255, green: 20/255, blue: 90/255, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: AppThemeColorConstants.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: AppThemeColorConstants.white]
        
        self.navigationController?.navigationBar.tintColor = AppThemeColorConstants.white
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.navigationController?.navigationBar.prefersLargeTitles = true // Makes bigger
        self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Maps"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(handleDismiss))
   
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(handleAdd))
    }

    /// Initializes the TableView and set its delegates, and adds it to the view.
    private func configureTableView(){
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = AppThemeColorConstants.fulbrightBlue
        tableView.rowHeight = 100
        
        tableView.register(MapOption.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        tableView.tableFooterView = UIView()
    }

    /// Configures the CancelButton and adds it to the view.
    func configureCancelButton(){
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.backgroundColor = AppThemeColorConstants.fulbrightBlue.withAlphaComponent(0.60)
        self.cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        self.cancelButton.setTitle("Cancel", for: .normal)
        self.cancelButton.setTitleColor(AppThemeColorConstants.red, for: .normal)
        
        view.addSubview(cancelButton)
        //constraints
        self.cancelButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.cancelButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: BottomLabelConstants.bottomPadding).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 75).isActive = true
        self.cancelButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -75).isActive = true
        self.cancelButton.layer.cornerRadius = 5
        
        self.cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
}

/// This extension allows the viewcontroller to handle the responsibility of the tableView.
/// Handles all actions within the tableview accounting for the changes in state.
extension ViewMaps: UITableViewDelegate, UITableViewDataSource {
    /// Implemented function which decides how many rows are available within the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Count of saved custom maps stored on device
        let length = dataModelSharedInstance!.getDataStoreManager().dataStore.getLocationInfoList().count
        return length
    }

    /// Implemented function which handles the appearance of each cell. Uses a MapOption as the cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locInfo = dataModelSharedInstance!.getDataStoreManager().dataStore.getLocationInfoList()[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier
            , for: indexPath) as! MapOption
        
        cell.descriptionLabel.text = locInfo.destination
        cell.iconImageView.image = UIImage(systemName: "map.fill") ?? UIImage()
        
        return cell
    }

    /// Handles what happens when a cell is selected. There are two states (normal/uploading).
    /// - Clicking on a cell in normal state kicks off navigation.
    /// - Clicking on a cell during uploading kicks off uploading the map to Firebase through node.js server.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locInfo = dataModelSharedInstance!.getDataStoreManager().dataStore.getLocationInfoList()[indexPath.row]
        
        // Code block for uploading a custom map.
        if (dataModelSharedInstance!.getLocationDetails().isUploadingMap) {
            self.tableView.deselectRow(at: indexPath, animated: true)
            let name = locInfo.destination
            let fullString = "Is '\(name)' the correct map?\n\nNote: Maps with the same name will be overwritten"
            
            let alert = UIAlertController(title: "Alert", message: fullString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                let loadingIndicator = ViewController.getLoadingIndicator()
                DispatchQueue.main.async {
                    self.present(loadingIndicator, animated: false, completion: nil)
                }
                guard let uid = Auth.auth().currentUser?.uid else {
                    self.alert(info: AlertConstants.notLoggedIn)
                    return
                }
                NetworkService.networkServiceSharedInstance.requestUploadCustomMap(URLConstants.uploadCustomMapRequest, uid: uid, locInfo: locInfo, completion: { results in
                    switch results{
                        case .failure(_):
                            DispatchQueue.main.async {
                                loadingIndicator.dismiss(animated: false, completion: {
                                    self.alert(info: AlertConstants.failedMapUpload)
                                })
                            }
                        case .success(let data):
                            //Server sends back a message indicating success/failure.
                            let message = Formatter.FormatterSharedInstance.decodeJSONMessage(JSONdata: data)
                            DispatchQueue.main.async {
                                loadingIndicator.dismiss(animated: false, completion: {
                                    self.alert(info: message)
                                })
                            }
                    }
                })
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            // Code block for clicking on a map in normal state.
            self.dismiss(animated: true, completion: nil)
            let destinationName = locInfo.destination
            let nodeList = locInfo.nodes.index
            let referencedBeaconName = locInfo.beaconName
            
            dataModelSharedInstance!.getNodeManager().setNodeList(list: nodeList)
            dataModelSharedInstance!.getNodeManager().setIsNodeListGenerated(isSet: true)

            DispatchQueue.main.async {
                self.dataModelSharedInstance!.getMainVC().destinationFound(destination: destinationName)
            }
        }
    }

    /// Allows the sliding motion of the cell in order to allow deletion.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    /// Handles the deletion of the custom map.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let row = indexPath.row
            var list = dataModelSharedInstance!.getDataStoreManager().dataStore.getLocationInfoList()
            list.remove(at: row)
            dataModelSharedInstance!.getDataStoreManager().dataStore.setLocationInfoList(list: list)
            dataModelSharedInstance!.getDataStoreManager().saveDataStore()
            self.tableView.reloadData()
        }
    }
}
