//
//  MyListCell.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 25/11/24.
//

import UIKit

class MyListCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    func configure(with movie: Home.Model.Result) {
        ImageDownloader.shared.downloadImage(from: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") { image in
            if let downloadedImage = image {
                self.imageView.image = downloadedImage
            } else {
                self.imageView.image = UIImage(named: "home.png")
            }
        }
    }
}
