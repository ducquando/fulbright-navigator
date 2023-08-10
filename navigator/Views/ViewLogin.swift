//  ARIndoorNav
//
//  ViewLogin.swift
//
//  Created by Duc Quan Do on 05/21/23.
//
//  This class is responsible for the login process within the app.
//  Firebase is utilized for all authentication purposes.

import UIKit
import Firebase

class ViewLogin: UIViewController {
    
    //MARK: - Properties
    var errorLabel: UILabel?
    // Delegate = ViewContainer.swift
    var delegate: ViewLoginDelegate?
    let formTitleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Fulbright Navigator"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = AppThemeColorConstants.white
        return label
    }()
    lazy var emailContainerView: UIView = {
        let view = UIView()
        let image = UIImage(systemName: "envelope.fill")
        return view.textContainerView(view: view, image!, emailTextField, tintColor: AppThemeColorConstants.white, addMiniText: false, miniText: nil, miniTextTintColor: nil)
    }()
    lazy var passwordContainerView: UIView = {
        let view = UIView()
        let image = UIImage(systemName: "lock.fill")
        return view.textContainerView(view: view, image!, passwordTextField, tintColor: AppThemeColorConstants.white, addMiniText: false, miniText: nil, miniTextTintColor: nil)
    }()
    lazy var emailTextField: UITextField = {
        var tf = UITextField()
        tf = tf.textField(withPlaceholder: "Email", isSecureTextEntry: false, tintColor: AppThemeColorConstants.white)
        tf.delegate = self
        return tf
    }()
    lazy var passwordTextField: UITextField = {
        var tf = UITextField()
        tf = tf.textField(withPlaceholder: "Password", isSecureTextEntry: true, tintColor: AppThemeColorConstants.white)
        tf.delegate = self
        return tf
    }()
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("LOG IN", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(AppThemeColorConstants.fulbrightBlue, for: .normal)
        button.backgroundColor = AppThemeColorConstants.white
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    //MARK: - Init
    
    /// Implementation of function that initializes the view components and class properties.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureViewComponents()
    }
    
    /// Implementation of function that sets the navigationBar to hidden.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Helpers
    
    /// Configures the view for the login controller.
    func configureViewComponents(){
        view.backgroundColor = AppThemeColorConstants.fulbrightBlue

        view.addSubview(formTitleView)
        formTitleView.setConstraints(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 240, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50
        )
        formTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailContainerView)
        emailContainerView.setConstraints(top: formTitleView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.setConstraints(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(loginButton)
        loginButton.setConstraints(top: passwordContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
    }
    
    //MARK: - API
    /// Handles the login when the login button is pressed
    @objc func handleLogin(){
        if errorLabel != nil {
            errorLabel!.removeFromSuperview()
        }
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        logUserIn(withEmail: email, password: password, completion: { result in
            switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                    // ViewContainer.swift handler
                    self.delegate!.handleLoginButton()
                case .failure(let error):
                    //Located in Exentsions.swift
                    self.errorLabel = self.view.errorLabel(text: error.localizedDescription)
                    DispatchQueue.main.async {
                        self.view.addSubview(self.errorLabel!)
                        self.errorLabel!.setConstraints(top: self.passwordContainerView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
                    }
                    return
            }
        })
    }

    /// Function logs a user in with provided email and password. It makes a call to the Firebase API to try and log the user in.
    func logUserIn(withEmail email:String, password: String, completion: @escaping(Result<Bool, Error>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                completion(.success(true))
            }
        }
    }
}

/// This extension allows the class to handle actions with the textFields.
extension ViewLogin: UITextFieldDelegate{
    /// Implementation of function that ends editing when return is clicked while editing text
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
