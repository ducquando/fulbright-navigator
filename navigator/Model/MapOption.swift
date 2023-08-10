//  ARIndoorNav
//
//  MapOption.swift
//
//  Created by Bryan Ung on 7/7/20.
//  Modified by Duc Quan Do on 5/25/23.
//
//  This file serves as a model for a custom map cell option within the ViewMaps

import UIKit

class MapOption: UITableViewCell {

    //MARK: - Properties
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = AppThemeColorConstants.white
        return iv
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppThemeColorConstants.white
        label.font = UIFont.systemFont(ofSize: MapViewConstants.font)
        label.text = "Sample Text"
        return label
    }()
    
    //MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = AppThemeColorConstants.fulbrightBlue
        self.selectionStyle = .default
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: TableViewConstants.leftPadding).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: MapViewConstants.height).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: MapViewConstants.width).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: MapViewConstants.leftDescriptionPadding).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
