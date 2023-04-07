//
//  PlayerViewController.swift
//  PhotographySchoolTestApp
//
//  Created by Anton Agafonov on 31.03.2023.
//

import UIKit
import AVKit

final class PlayerViewController: UIViewController {
    private var lesson: Lesson
    private let onDownloadTapped: () -> Void
    private let onNextTapped: () -> Void
    private var player: AVPlayer?
    
    private lazy var playerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.customBlack.color
        return view
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.customBlack.color
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: Constants.largeFontSize)
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: Constants.regularFontSize)
        return label
    }()
    private lazy var nextLessonButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: Constants.regularFontSize)
        button.setTitle(Constants.nextLessonButtonTitle, for: .normal)
        button.setImage(UIImage(systemName: AppConstants.chevronRight), for: .normal)
        button.addTarget(self, action: #selector(onNextButtonTapped), for: .touchUpInside)
        button.semanticContentAttribute = .forceRightToLeft
        button.accessibilityIdentifier = Identifiers.nextButton
        return button
    }()
    private lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.trailingNavBarButtonTitle, for: .normal)
        button.setImage(UIImage(systemName: AppConstants.downloadIcon), for: .normal)
        button.addTarget(self, action: #selector(onDownloadButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = Identifiers.downloadButton
        return button
    }()

    init(lesson: Lesson,
         onDownloadTapped: @escaping () -> Void,
         onNextTapped: @escaping () -> Void) {
        self.lesson = lesson
        self.onDownloadTapped = onDownloadTapped
        self.onNextTapped = onNextTapped
        super.init(nibName: nil, bundle: nil)
}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.customBlack.color
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
    }

    @objc
    private func onNextButtonTapped() {
        onNextTapped()
    }

    @objc
    private func onDownloadButtonTapped() {
        onDownloadTapped()
    }
    
    func updateView(with newLesson: Lesson) {
        if lesson != newLesson {
            lesson = newLesson
            setupUI()
        }
    }
    
    func buttonIsEnable(_ isEnable: Bool) {
        downloadButton.isEnabled = isEnable
    }
}

extension PlayerViewController {
    private func setupUI() {
        setupPlayerContainerView()
        setupScrollView()
        setupLabels()
        setupNextLessonButton()
    }
    
    private func setupNavigationBar() {
        parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: downloadButton)
        parent?.navigationItem.leftBarButtonItem?.accessibilityIdentifier = Identifiers.backButton
    }

    private func setupPlayerContainerView() {
        view.addSubview(playerContainerView)
        playerContainerView.translatesAutoresizingMaskIntoConstraints = false
        playerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        playerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerContainerView.heightAnchor.constraint(equalTo: playerContainerView.widthAnchor, multiplier: Constants.videoFrameMultiplier).isActive = true
        configureVideoPlayer()
    }
    
    private func configureVideoPlayer() {
        guard let url = prepareUrlForPlayer() else { return }
        player = AVPlayer(url: url)
        let avpVC = AVPlayerViewController()
        avpVC.player = player
        avpVC.videoGravity = AVLayerVideoGravity.resizeAspect
        addChild(avpVC)
        avpVC.view.frame = playerContainerView.bounds
        playerContainerView.addSubview(avpVC.view)
        playerContainerView.layer.masksToBounds = true
    }
    
    private func prepareUrlForPlayer() -> URL? {
        var url: URL?
        if StorageService.shared.checkStorageContains(url: lesson.videoURL) {
            url = StorageService.shared.getLocalUrlFromString(lesson.videoURL)
        } else {
            url = URL(string: lesson.videoURL)
        }
        return url
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: playerContainerView.bottomAnchor, constant: AppConstants.defaultPadding).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    private func setupLabels() {
        contentView.addSubview(titleLabel)
        titleLabel.text = lesson.name
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppConstants.defaultPadding).isActive = true
        titleLabel.topAnchor.constraint(equalTo: playerContainerView.bottomAnchor, constant: AppConstants.defaultPadding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppConstants.defaultPadding).isActive = true

        contentView.addSubview(descriptionLabel)
        descriptionLabel.text = lesson.description
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppConstants.defaultPadding).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppConstants.defaultPadding).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppConstants.defaultPadding).isActive = true
    }
    
    private func setupNextLessonButton() {
        contentView.addSubview(nextLessonButton)
        nextLessonButton.translatesAutoresizingMaskIntoConstraints = false
        nextLessonButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: AppConstants.defaultPadding).isActive = true
        nextLessonButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppConstants.defaultPadding).isActive = true
        nextLessonButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppConstants.defaultPadding).isActive = true
    }
}

private extension PlayerViewController {
    struct Constants {
        static let trailingNavBarButtonTitle = "Download"
        static let nextLessonButtonTitle = "Next lesson "
        static let largeFontSize: CGFloat = 24
        static let regularFontSize: CGFloat = 14
        static let videoFrameMultiplier: CGFloat = 9/16
    }
}
