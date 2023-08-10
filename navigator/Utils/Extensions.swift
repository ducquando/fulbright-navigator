//  ARIndoorNav
//
//  Extensions.swift
//
//  Created by Allie Do on 8/3/20.
//  Modifed by Duc Quan Do on 5/25/23.
//
//
//  Generalized Class for extensions related to components used in many classes

import UIKit

extension UIView {
    /// Programatically set the constraints of any UIView given they provide the following parameters.
    func setConstraints(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat,
        width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }

    /// Create a UIView consiting of two textfields for the purpose of creating a neat looking first & last name view.
    func firstLastNameView(view: UIView, _ image: UIImage, _ textField1: UITextField, _ textField2: UITextField, tintColor: UIColor, width: CGFloat) -> UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        let constantWidth = width/2-56
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.tintColor = tintColor
        view.addSubview(imageView)
        imageView.setConstraints(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 28, height: 28)
        
        view.addSubview(textField1)
        textField1.setConstraints(top: nil, left: imageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: constantWidth, height: 0)
        textField1.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let separatorView1 = UIView()
        view.addSubview(separatorView1)
        separatorView1.backgroundColor = tintColor
        separatorView1.setConstraints(top: textField1.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: constantWidth, height: 0.75)
        separatorView1.centerXAnchor.constraint(equalTo: textField1.centerXAnchor).isActive = true
        
        view.addSubview(textField2)
        textField2.setConstraints(top: nil, left: textField1.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 8, width: constantWidth, height: 0)
        textField2.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let separatorView2 = UIView()
        view.addSubview(separatorView2)
        separatorView2.backgroundColor = tintColor
        separatorView2.setConstraints(top: textField2.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: constantWidth, height: 0.75)
        separatorView2.centerXAnchor.constraint(equalTo: textField2.centerXAnchor).isActive = true
        return view
    }

    /// Create a UIView consiting of a textfield, image, and option to have mini text underneath textfield
    func textContainerView(view: UIView, _ image: UIImage, _ textField: UITextField, tintColor: UIColor, addMiniText: Bool, miniText: String?, miniTextTintColor: UIColor?) -> UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.tintColor = tintColor
        view.addSubview(imageView)
        imageView.setConstraints(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 28, height: 28)
        imageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        view.addSubview(textField)
        textField.setConstraints(top: nil, left: imageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = tintColor
        view.addSubview(separatorView)
        if (!addMiniText) {
            separatorView.setConstraints(top: textField.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 6, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.75)
        } else {
            separatorView.setConstraints(top: textField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 6, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.75)
            
            let miniTextLabel = UILabel()
            view.addSubview(miniTextLabel)
                
            miniTextLabel.backgroundColor = .clear
            miniTextLabel.text = miniText
            miniTextLabel.textColor = miniTextTintColor?.withAlphaComponent(0.75)
            miniTextLabel.font = UIFont.systemFont(ofSize: 10)
            
            miniTextLabel.setConstraints(top: separatorView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 2, paddingLeft: 50, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        }
        
        return view
    }

    /// This creates an error UILabel with the given text provided.
    func errorLabel (text: String) -> UILabel{
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = AppThemeColorConstants.red
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = text
        return label
    }
}


extension UITextField {
    ///  Creates a TextField with placeHolder text, ability to determine secureEntry, and tintColor TextField for the Login/Sign-Up Pages
    func textField(withPlaceholder placeholder:String, isSecureTextEntry: Bool, tintColor: UIColor) -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = tintColor
        tf.isSecureTextEntry = isSecureTextEntry
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: tintColor])
        return tf
    }
}

extension UIViewController {
    /// If hideKeyboardWhenTappedAround() is called, anywhere on the screen tapped when keyboard is showing will remove the keyboard from view.
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    /// Alert to be generated on current screen
    func alert(info: String) {
        let alert = UIAlertController(title: "Alert", message: info, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    /// Returns an Alert Controller embedded within a UIActivityIndictorView
    static func getLoadingIndicator() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        return alert
    }
}

extension String {
    /// Provides ability to apply patterns on numbers
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character, maxNum: Int) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return String(pureNumber.prefix(maxNum)) }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return String(pureNumber.prefix(maxNum))
    }

    /// Returns the String back capitalizing the first letter
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

extension UILabel {
    /// Returns a profile circle UILabel
    static func getProfileCircle(initial: String, height: CGFloat, width: CGFloat) -> UILabel{
        let iv = UILabel()
        
        iv.clipsToBounds = true
        iv.textColor = AppThemeColorConstants.white
        iv.font = UIFont.systemFont(ofSize: 48)
        iv.textAlignment = .center
        iv.text = initial
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = AppThemeColorConstants.fulbrightBlue
        iv.heightAnchor.constraint(equalToConstant: height).isActive = true
        iv.widthAnchor.constraint(equalToConstant: width).isActive = true
        iv.layer.cornerRadius = width/2
        
        return iv
    }
}

extension Float {
    /// Truncate floating number
    func truncate(places : Int) -> Float {
        return Float(floor(pow(10.0, Float(places)) * self) / pow(10.0, Float(places)))
    }
}
