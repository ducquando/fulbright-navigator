//  ARIndoorNav
//
//  ViewController.swift
//
//  Created by Duc Quan Do on 5/25/23.
//
//  The view controller hosing the ARSceneView. Also houses the navigation to different
//  view controllers. Once the app is launched, it defaults to this screen.
//  Handles the user interaction with creating a custom map. Commands the delegate
//  ViewAR to handle the data handling of this process.

import UIKit
import SceneKit
import ARKit
import CoreLocation
import Firebase

class ViewController: UIViewController{
    
    //MARK: - Properties
    var sceneView: ARSCNView = ARSCNView()
    
    var cancelButton = UIButton(type: .system) as UIButton
    var mapsButton = UIButton(type: .system) as UIButton
    
    // Buttons for building a custom map
    var addButton = UIButton(type: .system) as UIButton
    var undoButton = UIButton(type: .system) as UIButton
    var endButton = UIButton(type: .system) as UIButton
    var saveButton = UIButton(type: .system) as UIButton
    
    // Label which notifies by on-screen instructions
    var bottomLabel: UILabel = UILabel()
    
    // Delegate = ViewContainer.swift
    var delegateViewContainer: ViewControllerDelegate?
    // Delegate = ViewAR.swift
    var viewARDelegate: ViewControllerDelegate?
    var dataModelSharedInstance: DataModel!
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModelSharedInstance = DataModel.dataModelSharedInstance
        dataModelSharedInstance.setSceneView(view: sceneView)
        checkUserAuthentication() { authenticated in
            switch authenticated {
            case true:
                self.checkCameraAccess(){ bool in
                    switch bool{
                    case false:
                        DispatchQueue.main.async {
                            self.alert(info: AlertConstants.cameraAccessError)
                        }
                    case true:
                        DispatchQueue.main.async {
                            self.configureUI()
                            self.setUpAndRunConfiguration()
                        }
                    }
                }
            case false:
                let viewLogin = ViewLogin()
                viewLogin.delegate = self
                self.navigationController?.pushViewController(viewLogin, animated: false)
            }
        }
    }
    
    /// Implementation of function that will run setUpAndRunConfiguration() everytime the view is about to appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpAndRunConfiguration()
    }
    
    /// Implementation of function that will pause the sceneView when the View controller disappears.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - Helper Functions
    
    /// Checks/prompts the user for camera access.
    /// Completion handler returns if the user has access
    private func checkCameraAccess(completion: @escaping(Bool) -> Void){
        if AVCaptureDevice.authorizationStatus(for: .video) != .authorized{
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if !granted {
                    completion(false)
                }
                completion(true)
            })
        } else { completion(true) }
    }
    /// This function is called every time the view will appear. It checks to see if camera usage is allowed.
    /// If so, it will make the configurations for the ARSceneView and point to the folder location where the AR Markers are stored.
    private func setUpAndRunConfiguration(){
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            if ARWorldTrackingConfiguration.isSupported{
                let configuration = ARWorldTrackingConfiguration()
                // The y-axis matches the direction of gravity as detected by the device's motion sensing hardware; that is, the vector (0,-1,0) points downward
                configuration.worldAlignment = .gravity
                
                // Reference marker images
                if let ARImages = ARReferenceImage.referenceImages(inGroupNamed: "ARResources", bundle: Bundle.main) {
                    configuration.detectionImages = ARImages
                } else {
                    print("Images could not be loaded")
                }
                // Cleans the ARScene
                sceneView.scene.rootNode.enumerateChildNodes{ (node, stop) in
                    node.removeFromParentNode()
                }
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            } else {
                alert(info: AlertConstants.arErrorMessage)
            }
        }
        
    }
    
    /// This functions notifies the user that they are now navigating.
    private func setUpForNavigation(){
        self.view.isUserInteractionEnabled = false
        self.toggleBottomLabel(shouldShow: true, text: TextConstants.findBeaconText)
        self.view.isUserInteractionEnabled = true
    }
    
    /// Removes all buttons from the view
    private func removeAllButtons(){
        cancelButton.removeFromSuperview()
        mapsButton.removeFromSuperview()
        addButton.removeFromSuperview()
        undoButton.removeFromSuperview()
        endButton.removeFromSuperview()
        saveButton.removeFromSuperview()
    }
    
    /// Resets the view to the initial resting phase
    func resetToNormalState(){
        bottomLabel.removeFromSuperview()
        toggleCancelButton(shouldShow: false)
        toggleMapsButton(shouldShow: true)
        toggleAddButton(shouldShow: false)
        toggleUndoButton(shouldShow: false)
        toggleEndButton(shouldShow: false)
        toggleSaveButton(shouldShow: false)
        
        sceneView.session.pause()
        setUpAndRunConfiguration()
    }

    /// Sets the bottom label text(Notifies the user of instructions)
    func setBottomLabelText(text: String){
        DispatchQueue.main.async {
            self.bottomLabel.text = text
        }
    }
    
    //MARK: - Configurations
    
    /// Configures the view
    func configureUI(){
        configureSceneView()
        toggleMapsButton(shouldShow: true)
    }
    
    /// Configures the ARSceneView and sets its delegate to ARSCNViewDelegate
    func configureSceneView(){
        self.view.addSubview(sceneView)
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        sceneView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        sceneView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        sceneView.delegate = dataModelSharedInstance!.ARSCNViewDelegateSharedInstance
    }

    /// Configures the cancel button
    func configureCancelButton(){
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        cancelButton.setImage(UIImage(systemName: "xmark", withConfiguration: boldConfig), for: .normal)
        cancelButton.backgroundColor = AppThemeColorConstants.white.withAlphaComponent(0.5)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        
        self.view.addSubview(cancelButton)
        
        // Constraints
        cancelButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: ButtonConstants.topPadding).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: ButtonConstants.rightPadding).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: ButtonConstants.width).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: ButtonConstants.height).isActive = true
        cancelButton.layer.cornerRadius = ButtonConstants.width/2
    }
    
    /// Configures the map button
    func configureMapsButton(){
        mapsButton.translatesAutoresizingMaskIntoConstraints = false
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        mapsButton.setImage(UIImage(systemName: "map", withConfiguration: boldConfig), for: .normal)
        mapsButton.tintColor = AppThemeColorConstants.white
        mapsButton.backgroundColor = AppThemeColorConstants.fulbrightBlue
        mapsButton.addTarget(self, action: #selector(mapsButtonClicked), for: .touchUpInside)
        
        self.view.addSubview(mapsButton)
        
        // Constraints
        mapsButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: ButtonConstants.topPadding * -1).isActive = true
        mapsButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: ButtonConstants.rightPadding - 10).isActive = true
        mapsButton.widthAnchor.constraint(equalToConstant: ButtonConstants.width).isActive = true
        mapsButton.heightAnchor.constraint(equalToConstant: ButtonConstants.height).isActive = true
        mapsButton.layer.cornerRadius = ButtonConstants.width/2
    }
    
    /// Configures the add button which appears when creating a custom map
    func configureAddButton(){
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: ButtonConstants.font)
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(AppThemeColorConstants.fulbrightBlue, for: .normal)
        addButton.backgroundColor = AppThemeColorConstants.white
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        self.view.addSubview(addButton)
        
        // Constraints
        addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: ButtonConstants.topPadding * -1).isActive = true
        addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: ButtonConstants.rightPadding).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: ButtonConstants.width).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: ButtonConstants.height).isActive = true
        addButton.layer.cornerRadius = ButtonConstants.width/2
    }
    
    /// Configures the undo button when creating a custom map
    /// Adds to the view
    func configureUndoButton(){
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        undoButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: ButtonConstants.font)
        undoButton.setTitle("Undo", for: .normal)
        undoButton.setTitleColor(AppThemeColorConstants.fulbrightBlue, for: .normal)
        undoButton.backgroundColor = AppThemeColorConstants.white
        undoButton.addTarget(self, action: #selector(undoButtonClicked), for: .touchUpInside)
        
        self.view.addSubview(undoButton)
        
        // Constraints
        undoButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: ButtonConstants.topPadding * -1).isActive = true
        undoButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: ButtonConstants.leftPadding).isActive = true
        undoButton.widthAnchor.constraint(equalToConstant: ButtonConstants.width).isActive = true
        undoButton.heightAnchor.constraint(equalToConstant: ButtonConstants.height).isActive = true
        undoButton.layer.cornerRadius = ButtonConstants.width/2
    }
    
    /// Configures the end button when creating a custom map
    /// Adds to the view
    func configureEndButton(){
        endButton.translatesAutoresizingMaskIntoConstraints = false
        endButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: ButtonConstants.font)
        endButton.setTitle("End", for: .normal)
        endButton.setTitleColor(AppThemeColorConstants.fulbrightBlue, for: .normal)
        endButton.backgroundColor = AppThemeColorConstants.white
        endButton.addTarget(self, action: #selector(endButtonClicked), for: .touchUpInside)
        
        self.view.addSubview(endButton)
        
        // Constraints
        endButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: ButtonConstants.topPadding * -1).isActive = true
        endButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: ButtonConstants.rightPadding - ButtonConstants.width - ButtonConstants.distanceBetweenButtons).isActive = true
        endButton.widthAnchor.constraint(equalToConstant: ButtonConstants.width).isActive = true
        endButton.heightAnchor.constraint(equalToConstant: ButtonConstants.height).isActive = true
        endButton.layer.cornerRadius = ButtonConstants.width/2
    }
    
    /// Configures the save button when creating a custom map
    /// Adds to the view
    func configureSaveButton(){
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: ButtonConstants.font)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(AppThemeColorConstants.fulbrightBlue, for: .normal)
        saveButton.backgroundColor = AppThemeColorConstants.white
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        
        self.view.addSubview(saveButton)
        
        // Constraints
        saveButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: ButtonConstants.topPadding * -1).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: ButtonConstants.rightPadding).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: ButtonConstants.width).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: ButtonConstants.height).isActive = true
    }
    
    /// Configures the bottom label with text
    /// Adds to the view
    func configureBottomLabel(text: String?){
        self.bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        self.bottomLabel.backgroundColor = AppThemeColorConstants.fulbrightBlue.withAlphaComponent(0.5)
        self.bottomLabel.textAlignment = .center
        self.bottomLabel.textColor = AppThemeColorConstants.white
        self.bottomLabel.text = text
        self.bottomLabel.font = self.bottomLabel.font.withSize(BottomLabelConstants.fontSize)
        //multiline
        self.bottomLabel.lineBreakMode = .byWordWrapping
        self.bottomLabel.numberOfLines = 0
        
        view.addSubview(bottomLabel)
        // Constraints
        self.bottomLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.bottomLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: BottomLabelConstants.leftPadding).isActive = true
        self.bottomLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: BottomLabelConstants.rightPadding).isActive = true
        self.bottomLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: BottomLabelConstants.bottomPadding).isActive = true
        self.bottomLabel.heightAnchor.constraint(equalToConstant: BottomLabelConstants.height).isActive = true
        self.bottomLabel.layer.masksToBounds = true
        self.bottomLabel.layer.cornerRadius = 5
        
    }
    
    //MARK: - Handlers
    
    /// Checks with Firebase whether or not the user is signed in.
    func checkUserAuthentication(completion: @escaping(Bool) -> Void) {
        if Auth.auth().currentUser == nil {
            completion(false)
        } else {
            completion(true)
        }
    }

    /// Is called after the user authentication is checked. Depending on the scenario, different things happen.
    /// 1. User is logged in, configures the ViewController's view.
    /// 2. User is not logged in, pushes the ViewLogin.swift VC.
    func handleResultsFromAuth(result: Bool, animated: Bool){
        switch result {
        case true:
            self.configureUI()
            self.setUpAndRunConfiguration()
        case false:
            let viewLogin = ViewLogin()
            viewLogin.delegate = self
            self.navigationController?.pushViewController(viewLogin, animated: false)
        }
    }
    
    /// Handles the cancel button being clicked while navigating.
    /// Resets the app to the normal state
    @objc func cancelButtonClicked(){
        self.view.isUserInteractionEnabled = false
        self.dataModelSharedInstance!.resetNavigationToRestingState()
        resetToNormalState()
        self.view.isUserInteractionEnabled = true
    }
    
    /// Handles the map button being clicked
    /// Refers to the delegate (ViewContainer) which slides the Viewcontroller over to the right to see the menu.
    @objc func mapsButtonClicked(){
        let viewMaps = ViewMaps()
        viewMaps.manageViewMapsDelegate = self //Allows for data transfer
        let controller = UINavigationController(rootViewController: viewMaps)
        controller.navigationItem.hidesSearchBarWhenScrolling = false
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    /// Handles the add button being clicked when creating a custom map.
    /// Refers to the delegate - ARSCeneViewDelegate - to update the data
    @objc func addButtonClicked(){
        if (dataModelSharedInstance.getLocationDetails().getIsCreatingCustomMap()) {
            viewARDelegate!.handleAddButton()
        }
    }
    
    /// Handles the undo button being clicked when creating a custom map.
    /// Refers to the delegate - ARSCeneViewDelegate - to update the data
    @objc func undoButtonClicked(){
        if (dataModelSharedInstance.getLocationDetails().getIsCreatingCustomMap()) {
            viewARDelegate!.handleUndoButton()
            if (dataModelSharedInstance.getNodeManager().getLengthOfScnNodeList() == 0){
                toggleUndoButton(shouldShow: false)
                toggleEndButton(shouldShow: false)
            }
        }
    }
    
    /// Handles the end button being clicked when creating a custom map.
    /// Refers to the delegate - ARSCeneViewDelegate - to update the data
    @objc func endButtonClicked(){
        viewARDelegate!.handleEndButton()
    }
    
    /// Handles the save button being clicked when creating a custom map.
    /// Calls generateSavePopUp() to instruct the user how to save the custom map.
    @objc func saveButtonClicked(){
        self.generateSavePopUp()
    }
    
    /// Toggles whether or not the button should be shown
    func toggleCancelButton(shouldShow : Bool){
        if shouldShow{
            configureCancelButton()
        } else {
            cancelButton.removeFromSuperview()
        }
    }
    
    /// Toggles whether or not the button should be shown
    func toggleMapsButton(shouldShow : Bool){
        if shouldShow{
            configureMapsButton()
        } else {
            mapsButton.removeFromSuperview()
        }
    }
    
    /// Toggles whether or not the button should be shown
    func toggleAddButton(shouldShow: Bool){
        if shouldShow{
            configureAddButton()
        } else {
            addButton.removeFromSuperview()
        }
    }
    
    /// Toggles whether or not the button should be shown
    func toggleUndoButton(shouldShow: Bool){
        if shouldShow{
            configureUndoButton()
        } else {
            undoButton.removeFromSuperview()
        }
    }
    /*/ toggleEndButton(shouldShow: Bool)
     toggles whether or not the button should be shown
     
     @param: Bool - boolean value determining if the button is shown
     */
    func toggleEndButton(shouldShow: Bool){
        if shouldShow{
            configureEndButton()
        } else {
            endButton.removeFromSuperview()
        }
    }
    /// Toggles whether or not the button should be shown
    func toggleSaveButton(shouldShow: Bool){
        if shouldShow{
            configureSaveButton()
        } else {
            saveButton.removeFromSuperview()
        }
    }

    /// Toggles whether or not the bottomLabel should be shown
    func toggleBottomLabel(shouldShow: Bool, text: String?){
        if shouldShow{
            self.bottomLabel.removeFromSuperview()
            configureBottomLabel(text: text)
        } else {
            self.bottomLabel.removeFromSuperview()
        }
    }

    /// This function is called when a marker is found. It checks to see if the user is navigating or creating a custom map.
    /// This updates the view with the necessary label/buttons.
    /// This function is called from the ViewAR
    func beaconFoundInitiateDisappear(){
        if (dataModelSharedInstance.getLocationDetails().getIsNavigating()){
            setBottomLabelText(text: TextConstants.beaconFound + "\n" + TextConstants.navigationBegan)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                self.toggleBottomLabel(shouldShow: false, text: nil)
            }
        } else if (dataModelSharedInstance.getLocationDetails().getIsCreatingCustomMap()){
            setBottomLabelText(text: TextConstants.beaconFoundAddStartNode)
            self.toggleAddButton(shouldShow: true)
        }
    }

    /// This function sets up the view to handle the process of creating a custom map.
    /// This function is called from ViewContainer
    func customMapEditingBegan(){ //Called from ViewContainer
        removeAllButtons()
        toggleCancelButton(shouldShow: true)
        toggleBottomLabel(shouldShow: true, text: TextConstants.findBeaconToBuildCustomMap)
    }

     /// This function generates the save popup when creating a custom map.
    func generateSavePopUp(){
        let alert = UIAlertController(title: "Save Custom Map", message: "Enter destination name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Destination"
            textField.autocorrectionType = .no
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let actionSave = UIAlertAction(title: "Save", style: .default) { (_) in
            
            let nm = self.dataModelSharedInstance!.getNodeManager()
            // Receives the name of the custom map which the user inputted and calls the nodeManager to make the data structure of the custom map.
            let customMap = nm.retrieveCustomMap(alert.textFields?.first?.text ?? "")
            
            // Saves the customMap, type=LocationInfo, to the dataStore.
            let dataStore = self.dataModelSharedInstance!.getDataStoreManager().dataStore
            var customMapList = dataStore.getLocationInfoList()
            customMapList.append(customMap)
            dataStore.setLocationInfoList(list: customMapList)
            self.dataModelSharedInstance!.getDataStoreManager().saveDataStore()
            
            // Resets to normal state
            self.dataModelSharedInstance!.resetNavigationToRestingState()
            self.resetToNormalState()
        }
        alert.addAction(actionCancel)
        alert.addAction(actionSave)
        self.present(alert,animated: true,completion: nil)
    }
    
}

 /// This extension allows the ViewSearch to initiate navigation from selecting a destination that is on the server destination list.
extension ViewController: ViewSearchDelegate{
    /// Called when the user selects a destination on the Search Controller.
    /// Sets up the main VC to handle navigation.
    func destinationFound(destination: String) {
        DispatchQueue.main.async{
            print("Destination Received: \(destination)")
            self.dataModelSharedInstance!.getLocationDetails().setDestination(destination: destination)
            self.dataModelSharedInstance!.getLocationDetails().setIsNavigating(isNav: true)
            self.toggleCancelButton(shouldShow: true)
            self.toggleMapsButton(shouldShow: false)
            self.setUpForNavigation()
        }
    }
}

/// Handles the action when the user decides to create a custom map within the ViewMaps VC. It links to the main VC and begins the process
extension ViewController: ViewMapsDelegate {
    /// Handles the button within ViewMaps VC that begins creating a custom map
    func createCustomMapProcess() {
        self.customMapEditingBegan()
    }
}

 /// This extension allows the class to handle actions from the ViewAR. More specifically, the view controller handles onscreen changes when the destination is reached.
extension ViewController: ViewARScnDelegate {
    /// Called when the user comes within range of the destination node.
    /// It changes the bottom text label to show and indicate that the destination has been reached.
    func destinationReached(){
        if (dataModelSharedInstance.getLocationDetails().getIsNavigating()){
            toggleBottomLabel(shouldShow: true, text: TextConstants.destinationReached)
        }
    }
}

/// Allows the class to handle actions of the ViewLogin by checking that the login button being pressed from the ViewLogin.swift
extension ViewController: ViewLoginDelegate {
    /// Check user authentication.
    /// Either dismiss the VC or call a helper function to handle population of the viewController
    func handleLoginButton() {
        checkUserAuthentication() { boo in
            switch boo {
            case true:
                self.handleResultsFromAuth(result: boo, animated: false)
            case false:
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
