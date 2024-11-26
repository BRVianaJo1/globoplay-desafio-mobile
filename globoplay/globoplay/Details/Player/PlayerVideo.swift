//
//  PlayerVideo.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 25/11/24.
//

import UIKit
import WebKit

class PlayerVideoViewController: UIViewController, WKNavigationDelegate {
    
    var videoURL: String
    private var timeoutTimer: Timer?
    private let timeoutInterval: TimeInterval = 10.0 

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
    
    private var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = false
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private var loader: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    // MARK: - ViewController Lifecycle
    
    init(videoURL: String) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addComponents()
        addComponentsConstraints()
        setupWebView()
        loadVideo()
    }
    
    // MARK: - Setup
    
    private func setupWebView() {
        webView.navigationDelegate = self
    }
    
    // MARK: - Private Functions
    
    private func loadVideo() {
        if let videoURL = URL(string: videoURL) {
            let request = URLRequest(url: videoURL)
            showLoadingState()
            webView.load(request)
        
            timeoutTimer = Timer.scheduledTimer(
                timeInterval: timeoutInterval,
                target: self,
                selector: #selector(handleTimeout),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    @objc private func handleTimeout() {
        webView.stopLoading()
        hideLoadingState()
        let alert = UIAlertController(
            title: "Erro",
            message: DetailsKeys.Localized.playerError.rawValue + " Tempo limite excedido.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showLoadingState() {
        blurEffectView.isHidden = false
        loader.startAnimating()
    }
    
    private func hideLoadingState() {
        blurEffectView.isHidden = true
        loader.stopAnimating()
    }
    
    // MARK: - Action Functions
    
    @objc func backButtonTapped() {
        navigationController?.popToRootViewController(animated: false)
    }
    
    // MARK: - Layout Functions
    
    func addComponents() {
        headerView.addSubview(backButton)
        view.addSubview(headerView)
        view.addSubview(webView)
        view.addSubview(blurEffectView)
        view.addSubview(loader)
    }
    
    func addComponentsConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            webView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        timeoutTimer?.invalidate()
        hideLoadingState()
        let playAndFullscreenScript = """
            var video = document.querySelector('video');
            if (video) {
                video.play();
                if (video.requestFullscreen) {
                    video.requestFullscreen();
                } else if (video.mozRequestFullScreen) { // Firefox
                    video.mozRequestFullScreen();
                } else if (video.webkitRequestFullscreen) { // Safari
                    video.webkitRequestFullscreen();
                } else if (video.msRequestFullscreen) { // IE/Edge
                    video.msRequestFullscreen();
                }
            }
        """
        webView.evaluateJavaScript(playAndFullscreenScript) { result, error in
            if let error = error {
                print("Erro: \(error.localizedDescription)")
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        timeoutTimer?.invalidate()
        hideLoadingState()
        showErrorAlert(error: error)
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Erro",
            message: DetailsKeys.Localized.playerError.rawValue + (error.localizedDescription),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
