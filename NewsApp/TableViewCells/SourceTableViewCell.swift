//
//  SourceTableViewCell.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 29/1/2023.
//

import UIKit

class SourceTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SourceTableViewCell"
    
    var headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints  =  false
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints  =  false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ data: SourcesDTO) {
        headerLabel.text = data.name
        descriptionLabel.text = data.description
    }
    
    func setupViews() {
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant:-15)
        ])
        
    }
    
}
