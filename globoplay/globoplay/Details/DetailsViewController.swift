//
//  DetailsViewController.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//

import UIKit
import WebKit

protocol DetailsDisplayLogic: AnyObject {
    func displayScreenValues(movie: Details.Model.Response)
}

final class DetailsViewController: UIViewController, DetailsDisplayLogic {
    
    // MARK: - Archtecture Objects
    
    private var interactor: DetailsBusinessLogic?
    private var router: (NSObjectProtocol & DetailsRoutingLogic & DetailsDataPassing)?
    private var IDMovie: Int
    private var videoKey: String = ""
    private var isInWatchlist: Bool = false
    
    private let scrollView: UIScrollView = {
        var view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        return view
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
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: DetailsKeys.Localized.backButton.rawValue)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = GloboColors.white
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view =  UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        layer.locations = [0.0, 0.5]
        return layer
    }()
    
    private let gradientView: UIView = {
        let gradientView = UIView()
        return gradientView
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = GloboColors.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var yearLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = GloboColors.secondaryGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = GloboColors.secondaryGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        var stack = UIStackView()
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let watchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: DetailsKeys.Localized.playImage.rawValue)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = GloboColors.primaryGray
        button.setTitle(DetailsKeys.Localized.watchButton.rawValue, for: .normal)
        button.setTitleColor(GloboColors.primaryGray, for: .normal)
        button.backgroundColor = GloboColors.white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(watchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let myListButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: HomeKeys.Localized.myListImage.rawValue)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = GloboColors.secondaryGray
        button.setTitle(DetailsKeys.Localized.myListButton.rawValue, for: .normal)
        button.setTitleColor(GloboColors.secondaryGray, for: .normal)
        button.backgroundColor = GloboColors.black
        button.layer.borderColor = GloboColors.secondaryGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(myListButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let detailsStackView: UIStackView = {
        var stack = UIStackView()
        stack.spacing = 20
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.backgroundColor = GloboColors.primaryGray
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var detailsTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = DetailsKeys.Localized.technicalSheet.rawValue
        label.textColor = GloboColors.white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private var detailsLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = GloboColors.secondaryGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - ViewController Lifecycle
    
    init(idMovie: Int) {
        self.IDMovie = idMovie
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffectView.frame = view.bounds
        gradientLayer.frame = view.bounds
        gradientView.frame = view.bounds
        addComponents()
        addComponentsConstraints()
        loadScreenValues()
        isInWatchlist = WatchlistFactory.shared.isMovieInWatchlist(movieID: IDMovie)
        displayButtonValues()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = DetailsInteractor()
        let presenter = DetailsPresenter()
        let router = DetailsRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - Private Functions
    
    private func loadScreenValues() {
        interactor?.fetchData(id: IDMovie)
    }
    
    func UsersVotesPercentage(voteAverage: Double) -> Double {
        let maxScore = 10.0
        let acceptancePercentage = (voteAverage / maxScore) * 100
        return round(acceptancePercentage)
    }
    
    func displayButtonValues() {
        if isInWatchlist {
            myListButton.setImage(UIImage(named: HomeKeys.Localized.checkImage.rawValue)?.withRenderingMode(.alwaysTemplate), for: .normal)
            myListButton.setTitle(DetailsKeys.Localized.myListAdd.rawValue, for: .normal)
        } else {
            myListButton.setImage(UIImage(named: HomeKeys.Localized.myListImage.rawValue)?.withRenderingMode(.alwaysTemplate), for: .normal)
            myListButton.setTitle(DetailsKeys.Localized.myListButton.rawValue, for: .normal)
        }
    }
    
    func configure(with imageURL: String?) {
        guard let url =  imageURL else {
            backgroundImageView.image = UIImage(named: "home.png")
            imageView.image = UIImage(named: "home.png")
            return
        }
        ImageDownloader.shared.downloadImage(from: url) { image in
            if let downloadedImage = image {
                self.backgroundImageView.image = downloadedImage
                self.imageView.image = downloadedImage
            } else {
                self.backgroundImageView.image = UIImage(named: "home.png")
                self.imageView.image = UIImage(named: "home.png")
            }
        }
    }
    
    // MARK: - Action Functions
    
    @objc func backButtonTapped() {
        navigationController?.popToRootViewController(animated: false)
    }
    
    @objc func watchButtonTapped() {
        router?.routeToPlayerVideo(key: videoKey)
    }
    
    @objc func myListButtonTapped() {
         if !isInWatchlist {
             interactor?.addToMyList(id: IDMovie, addToWatchlist: true) { [weak self] result in
                 guard let self = self else { return }
                 
                 switch result {
                 case .success:
                     isInWatchlist = true
                     myListButton.setImage(UIImage(named: HomeKeys.Localized.checkImage.rawValue)?.withRenderingMode(.alwaysTemplate), for: .normal)
                     myListButton.setTitle(DetailsKeys.Localized.myListAdd.rawValue, for: .normal)
                 case .failure:
                     self.showAlert(title: DetailsKeys.Localized.error.rawValue, message: DetailsKeys.Localized.addWatchListError.rawValue)
                 }
             }
         } else {
             interactor?.addToMyList(id: IDMovie, addToWatchlist: false) { [weak self] result in
                 guard let self = self else { return }
                 
                 switch result {
                 case .success:
                     isInWatchlist = false
                     myListButton.setImage(UIImage(named: HomeKeys.Localized.myListImage.rawValue)?.withRenderingMode(.alwaysTemplate), for: .normal)
                     myListButton.setTitle(DetailsKeys.Localized.myListButton.rawValue, for: .normal)
                 case .failure:
                     self.showAlert(title: DetailsKeys.Localized.error.rawValue, message: DetailsKeys.Localized.addWatchListError.rawValue)
                 }
             }
         }
    }
    
    // MARK: - Layout Functions
    
    private func addComponents() {

        backgroundImageView.addSubview(blurEffectView)
        gradientView.layer.addSublayer(gradientLayer)
        backgroundImageView.addSubview(gradientView)
        headerView.addSubview(backButton)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(yearLabel)
        stackView.addArrangedSubview(descriptionLabel)
        buttonStackView.addArrangedSubview(watchButton)
        buttonStackView.addArrangedSubview(myListButton)
        stackView.addArrangedSubview(buttonStackView)
        detailsStackView.addArrangedSubview(detailsTitleLabel)
        detailsStackView.addArrangedSubview(detailsLabel)
        stackView.addArrangedSubview(detailsStackView)
        view.addSubview(backgroundImageView)
        scrollView.addSubview(stackView)
        view.addSubview(headerView)
        view.addSubview(scrollView)
    }
    
    private func addComponentsConstraints() {
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
          
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
       
            imageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 180),
 
            watchButton.heightAnchor.constraint(equalToConstant: 60),
            myListButton.heightAnchor.constraint(equalToConstant: 60),
            buttonStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            detailsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            detailsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            detailsTitleLabel.topAnchor.constraint(equalTo: detailsStackView.topAnchor,  constant: 32),
            detailsTitleLabel.leadingAnchor.constraint(equalTo: detailsStackView.leadingAnchor,  constant: 32),
            detailsTitleLabel.trailingAnchor.constraint(equalTo:  detailsStackView.trailingAnchor,  constant: -32),
 
            detailsLabel.leadingAnchor.constraint(equalTo: detailsStackView.leadingAnchor,  constant: 32),
            detailsLabel.trailingAnchor.constraint(equalTo: detailsStackView.trailingAnchor,  constant: -32),
            detailsLabel.bottomAnchor.constraint(equalTo: detailsStackView.bottomAnchor,  constant: 300),
        ])
    }
    
    // MARK: - Display Logic
    
    func displayScreenValues(movie: Details.Model.Response) {
        videoKey = movie.videos.results.first(where: { $0.type == "Trailer" && $0.site == "YouTube" })?.key ?? ""
        configure(with: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
        titleLabel.text = movie.title
        yearLabel.text = movie.releaseDate
        descriptionLabel.text = movie.overview
        let concatenatedText =
            """
            Título Original: \(movie.title)
            Idioma: \(movie.originalLanguage)
            Ano de produção: \(movie.releaseDate)
            País: \(movie.originCountry)
            Produtora: \(movie.productionCompanies.first?.name ?? "Não disponível")
            Aprovação dos usuários: \(UsersVotesPercentage(voteAverage: movie.voteAverage))%
            
            """
        detailsLabel.text = concatenatedText
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
