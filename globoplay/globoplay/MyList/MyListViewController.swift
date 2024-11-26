//
//  MyListViewController.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 20/11/24.
//

import UIKit

protocol MyListDisplayLogic: AnyObject {
    func displayScreenValues(movieList: [Home.Model.Result])
}

final class MyListViewController: UIViewController, MyListDisplayLogic {
    
    // MARK: - Architecture Objects
    
    private var interactor: MyListBusinessLogic?
    private var router: (NSObjectProtocol & MyListRoutingLogic)?
    
    private var movies: [Home.Model.Result] = []
    
    // MARK: - UI Elements
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: HomeKeys.Localized.logoHeader.rawValue)
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = MyListKeys.Localized.noDataLabel.rawValue
        label.textColor = GloboColors.secondaryGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private var titleLabel: UILabel = {
        var title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = GloboColors.white
        title.textAlignment = .left
        title.numberOfLines = 0
        title.text = MyListKeys.Localized.titleLabel.rawValue
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let totalSpacing = layout.minimumInteritemSpacing * 2 + 64
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / 3
        layout.itemSize = CGSize(width: itemWidth, height: 200)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(MyListCell.self, forCellWithReuseIdentifier: "MyListCell")
        return collectionView
    }()
    
    // MARK: - ViewController Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addComponents()
        addComponentsConstraints()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = GloboColors.primaryGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadScreenValues()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = MyListInteractor()
        let presenter = MyListPresenter()
        let router = MyListRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    // MARK: - Private Functions
    
    private func loadScreenValues() {
        interactor?.fetchData()
    }
    
    // MARK: - Layout Functions
    
    private func addComponents() {
        view.addSubview(headerView)
        headerView.addSubview(headerImageView)
        view.addSubview(emptyStateLabel)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func addComponentsConstraints() {
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            headerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            headerImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 120),
            headerImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -120),
            headerImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Display Logic
    
    func displayScreenValues(movieList: [Home.Model.Result]) {
       movies = movieList
       collectionView.reloadData()
       emptyStateLabel.isHidden = !movies.isEmpty
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MyListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyStateLabel.isHidden = !movies.isEmpty
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyListCell", for: indexPath) as! MyListCell
        let movie = movies[indexPath.row]
        
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.routeToDetails(idMovie: movies[indexPath.item].id)
    }
}

