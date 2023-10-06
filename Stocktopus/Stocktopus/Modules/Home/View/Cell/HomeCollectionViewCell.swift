//
//  HomeCollectionViewCell.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    static let identifier = "HomeCollectionViewCell"
    
    private let tickerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with provider: HomeCollectionViewCellProvider) {
        tickerLabel.text = provider.ticker
        companyNameLabel.text = provider.companyName
    }
}

// MARK: - Helpers
private extension HomeCollectionViewCell {
    func setupViews() {
        addSubViews([tickerLabel, companyNameLabel, chevronImageView])
        
        tickerLabel.setConstraint(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: chevronImageView.leadingAnchor,
            topConstraint: 8,
            leadingConstraint: 16,
            trailingConstraint: 16
        )
        
        companyNameLabel.setConstraint(
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: chevronImageView.leadingAnchor,
            leadingConstraint: 16,
            bottomConstraint: 8,
            trailingConstraint: 16
        )
        
        chevronImageView.setConstraint(
            trailing: trailingAnchor,
            trailingConstraint: 16,
            centerY: centerYAnchor,
            width: 17,
            height: 24
        )
    }
}
