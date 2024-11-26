//
//  HomeTableViewCell.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 23/11/24.
//

import Foundation
import UIKit

protocol HomeTableViewCellDelegate: AnyObject {
    func didSelectMovie(idMovie: Int)
}

class HomeTableViewCell: UITableViewCell {
    
    private var movies: [CarouselMovies] = []
    weak var delegate: HomeTableViewCellDelegate?
    
    private var genreTitleLabel: UILabel = {
        var title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = GloboColors.white
        title.textAlignment = .left
        title.numberOfLines = 0
        return title
    }()
    
    private var carouselView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(HomeCarouselView.self, forCellWithReuseIdentifier: HomeCarouselView.identifier)
        return collectionView
    }()
    
    private let stackView: UIStackView = {
        var stack = UIStackView()
        stack.spacing = 20
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "HomeTableViewCell")
        self.selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupCollectionView()
        addComponents()
        addComponentsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponents() {
        stackView.addArrangedSubview(genreTitleLabel)
        stackView.addArrangedSubview(carouselView)
        contentView.addSubview(stackView)
    }
    
    func addComponentsConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            genreTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            genreTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            genreTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            carouselView.heightAnchor.constraint(equalToConstant: 180),
            carouselView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    func set(genere: String, movies: [CarouselMovies]) {
        genreTitleLabel.text = genere
        self.movies = movies
        carouselView.reloadData()
    }
    
    private func setupCollectionView() {
        carouselView.showsHorizontalScrollIndicator = false
        carouselView.dataSource = self
        carouselView.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.layer.cornerRadius = 8
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        self.contentView.layer.shadowColor = UIColor.label.cgColor
        self.contentView.layer.shadowOpacity = 0.1
        self.contentView.layer.shadowOffset = .zero
        self.contentView.layer.shadowRadius = 2
    }
}

extension HomeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = carouselView.dequeueReusableCell(withReuseIdentifier: HomeCarouselView.identifier, for: indexPath) as? HomeCarouselView else {
            return UICollectionViewCell()
        }
        let image = movies[indexPath.item].imageURL
        cell.configure(with: image)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectMovie(idMovie: movies[indexPath.item].id)
    }
}
