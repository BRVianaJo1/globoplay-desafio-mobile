//
//  HomeViewController.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 17/11/24.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayScreenValues(genreList: [GenreList])
}

final class HomeViewController: UIViewController, HomeDisplayLogic {
    
    // MARK: - Archtecture Objects
    
    private var interactor: HomeBusinessLogic?
    private var router: (NSObjectProtocol & HomeRoutingLogic)?
    
    private var data: [GenreList] = []
    private var type: String = "popular"
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = GloboColors.secondaryGray
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
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
    
    private let buttonStackView: UIStackView = {
        var stack = UIStackView()
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let PopularButton: UIButton = {
        let button = UIButton()
        button.tintColor = GloboColors.secondaryGray
        button.setTitle(HomeKeys.Localized.popularButton.rawValue, for: .normal)
        button.setTitleColor(GloboColors.primaryGray, for: .normal)
        button.backgroundColor = GloboColors.white
        button.layer.borderColor = GloboColors.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(didTapFilterPopButton), for: .touchUpInside)
        return button
    }()
    
    private let PlayingButton: UIButton = {
        let button = UIButton()
        button.tintColor = GloboColors.secondaryGray
        button.setTitle(HomeKeys.Localized.playButton.rawValue, for: .normal)
        button.setTitleColor(GloboColors.secondaryGray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = GloboColors.secondaryGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(didTapFilterPlayButton), for: .touchUpInside)
        return button
    }()
    
    private let UpcomingButton: UIButton = {
        let button = UIButton()
        button.tintColor = GloboColors.secondaryGray
        button.setTitle(HomeKeys.Localized.upcomingButton.rawValue, for: .normal)
        button.setTitleColor(GloboColors.secondaryGray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = GloboColors.secondaryGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(didTapFilterUpButton), for: .touchUpInside)
        return button
    }()
    
    private let TopButton: UIButton = {
        let button = UIButton()
        button.tintColor = GloboColors.secondaryGray
        button.setTitle(HomeKeys.Localized.topButton.rawValue, for: .normal)
        button.setTitleColor(GloboColors.secondaryGray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = GloboColors.secondaryGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(didTapFilterTopButton), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        return tableView
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
        tableView.dataSource = self
        tableView.delegate = self
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
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    // MARK: - Private Functions
    
    private func loadScreenValues() {
        interactor?.fetchData(type: type)
    }
    
    private func resetButtonColors() {
        let buttons = [PopularButton, PlayingButton, UpcomingButton, TopButton]
        for button in buttons {
            button.backgroundColor = .clear
            button.layer.borderColor = GloboColors.secondaryGray.cgColor
            button.setTitleColor(GloboColors.secondaryGray, for: .normal)
        }
    }
    
    // MARK: - Action Functions
    
    @objc private func didPullToRefresh() {
        interactor?.fetchData(type: type)
    }
    
    @objc private func didTapFilterPopButton() {
        resetButtonColors()
        PopularButton.backgroundColor = GloboColors.white
        PopularButton.layer.borderColor = GloboColors.white.cgColor
        PopularButton.setTitleColor(GloboColors.primaryGray, for: .normal)
        type = "popular"
        interactor?.fetchData(type: type)
    }
    
    @objc private func didTapFilterTopButton() {
        resetButtonColors()
        TopButton.backgroundColor = GloboColors.white
        TopButton.layer.borderColor = GloboColors.white.cgColor
        TopButton.setTitleColor(GloboColors.primaryGray, for: .normal)
        type = "top_rated"
        interactor?.fetchData(type: type)
    }
    
    @objc private func didTapFilterUpButton() {
        resetButtonColors()
        UpcomingButton.backgroundColor = GloboColors.white
        UpcomingButton.layer.borderColor = GloboColors.white.cgColor
        UpcomingButton.setTitleColor(GloboColors.primaryGray, for: .normal)
        type = "upcoming"
        interactor?.fetchData(type: type)
    }
    
    @objc private func didTapFilterPlayButton() {
        resetButtonColors()
        PlayingButton.backgroundColor = GloboColors.white
        PlayingButton.layer.borderColor = GloboColors.white.cgColor
        PlayingButton.setTitleColor(GloboColors.primaryGray, for: .normal)
        type = "now_playing"
        interactor?.fetchData(type: type)
    }
    
    // MARK: - Layout Functions
    
    private func addComponents() {
        view.addSubview(headerView)
        headerView.addSubview(headerImageView)
        buttonStackView.addArrangedSubview(PopularButton)
        buttonStackView.addArrangedSubview(TopButton)
        buttonStackView.addArrangedSubview(UpcomingButton)
        buttonStackView.addArrangedSubview(PlayingButton)
        view.addSubview(buttonStackView)
        view.addSubview(tableView)
        tableView.refreshControl = refreshControl
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
           
           buttonStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
           buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
           buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
           buttonStackView.heightAnchor.constraint(equalToConstant: 80),
            
           tableView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
           tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
           tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Display Logic
    
    func displayScreenValues(genreList: [GenreList]) {
       data = genreList
       tableView.reloadData()
       tableView.layoutIfNeeded()
       refreshControl.endRefreshing() 
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath as IndexPath) as? HomeTableViewCell else {
        return UITableViewCell()
    }
        cell.set(genere: data[indexPath.row].genre, movies: data[indexPath.row].movies)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    func didSelectMovie(idMovie: Int) {
        router?.routeToDetails(idMovie: idMovie)
    }
}
