//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 18/1/2023.
//

import UIKit
import SDWebImage

class ArticleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ArticleTableViewCell"
    
    var newsImageView: UIImageView = {
        let imageV = UIImageView(frame: .zero)
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 10
        imageV.image = UIImage(named: "placeholder")
        imageV.translatesAutoresizingMaskIntoConstraints  =  false
        return imageV
    }()
    var headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints  =  false
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints  =  false
        return label
    }()
    
    var authorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints  =  false
        return label
    }()
    
    let imageStackView = UIStackView()
    let labelStackView = UIStackView()
    let footerSatckView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configure(_ data: ArticleDTO) {
        headerLabel.text = data.title
        descriptionLabel.text = data.description
        authorLabel.text =  data.author
        newsImageView.sd_setImage(with: URL(string: data.urlToImage), placeholderImage: UIImage(named: "placeholderNews"))
    }
    

    func setupViews() {
        
        contentView.addSubview(imageStackView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(labelStackView)
        contentView.addSubview(footerSatckView)
        
        imageStackView.addArrangedSubview(newsImageView)
        labelStackView.addArrangedSubview(descriptionLabel)
        footerSatckView.addArrangedSubview(authorLabel)

        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        
        footerSatckView.translatesAutoresizingMaskIntoConstraints = false
        footerSatckView.axis = .vertical
        
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.axis = .vertical

        NSLayoutConstraint.activate([
            
           
            imageStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            newsImageView.heightAnchor.constraint(equalToConstant: 200),
            
            headerLabel.topAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: 10),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            labelStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 5),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
           // labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant:-15),
            
            footerSatckView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            footerSatckView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            footerSatckView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            footerSatckView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant:-15),
            
        ])
 
        
    }
    
}
