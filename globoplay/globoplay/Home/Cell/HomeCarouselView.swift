//
//  HomeCarouselView.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 23/11/24.
//

import UIKit

class HomeCarouselView: UICollectionViewCell {
   
    static let identifier = "HomeCarouselView"
  
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 180),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
       ])
    }

    func configure(with imageURL: String?) {
        guard let url =  imageURL else {
            imageView.image = UIImage(named: "home.png")
            return
        }
        ImageDownloader.shared.downloadImage(from: url) { image in
            if let downloadedImage = image {
                self.imageView.image = downloadedImage
            } else {
                self.imageView.image = UIImage(named: "home.png")
            }
        }
    }
}

