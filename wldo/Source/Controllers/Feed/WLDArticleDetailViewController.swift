import UIKit

class WLDArticleDetailViewController: UIViewController {

    var post: WLDArticle?
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView = UIImageView()
    private var videoPlayerView: WLDVideoPlayerView?
    private let contentContainer = UIView()
    private let timeLabel = UILabel()
    private let captionLabel = UILabel()
    private let tagsLabel = UILabel()
    
    // Bottom Action Bar
    private let bottomBar = UIView()
    private let likeButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let downloadButton = UIButton(type: .system)
    private let likesCountLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WLDAppConfig.Colors.background
        navigationItem.largeTitleDisplayMode = .never
        
        setupUI()
        configureData()
    }
    
    private func setupUI() {
        // Tab Bar and Nav Bar transparency
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = WLDAppConfig.Colors.textPrimary
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never // Let image go under nav bar
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = WLDAppConfig.Colors.sand
        contentView.addSubview(imageView)
        
        // Setup Video Player (Lazy initialized if nil but here for simplicity)
        let player = WLDVideoPlayerView()
        player.translatesAutoresizingMaskIntoConstraints = false
        player.isHidden = true
        contentView.addSubview(player)
        self.videoPlayerView = player
        
        // Info Container
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.backgroundColor = WLDAppConfig.Colors.background
        contentView.addSubview(contentContainer)
        
        // Time
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = WLDAppConfig.Fonts.caption(size: 13)
        timeLabel.textColor = WLDAppConfig.Colors.textSecondary
        contentContainer.addSubview(timeLabel)
        
        // Caption
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.font = WLDAppConfig.Fonts.body(size: 16)
        captionLabel.numberOfLines = 0
        captionLabel.textColor = WLDAppConfig.Colors.textPrimary
        contentContainer.addSubview(captionLabel)
        
        // Tags
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsLabel.font = WLDAppConfig.Fonts.body(size: 15)
        tagsLabel.textColor = .systemBlue // Or your accent color
        tagsLabel.numberOfLines = 0
        contentContainer.addSubview(tagsLabel)
        
        // Bottom Bar
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.backgroundColor = WLDAppConfig.Colors.background
        
        // Top border for bottom bar
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = WLDAppConfig.Colors.sand
        bottomBar.addSubview(separator)
        
        view.addSubview(bottomBar)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = WLDAppConfig.Colors.textPrimary
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        bottomBar.addSubview(likeButton)
        
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        likesCountLabel.font = WLDAppConfig.Fonts.title(size: 15)
        likesCountLabel.textColor = WLDAppConfig.Colors.textPrimary
        bottomBar.addSubview(likesCountLabel)
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = WLDAppConfig.Colors.textPrimary
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        bottomBar.addSubview(shareButton)
        
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
        downloadButton.tintColor = WLDAppConfig.Colors.textPrimary
        downloadButton.addTarget(self, action: #selector(didTapDownload), for: .touchUpInside)
        bottomBar.addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor), // Edge to edge
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Image (Full Width, dynamic height)
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65), // 65% of screen
            
            // Video Player Match Image
            videoPlayerView!.topAnchor.constraint(equalTo: imageView.topAnchor),
            videoPlayerView!.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            videoPlayerView!.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            videoPlayerView!.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            
            // Info Container
            contentContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Info Text elements
            timeLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            
            // Caption
            captionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 12),
            captionLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            captionLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
            
            // Tags
            tagsLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 12),
            tagsLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
            tagsLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
            tagsLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -100), // Padding below
            
            // Bottom Bar
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 60),
            
            separator.topAnchor.constraint(equalTo: bottomBar.topAnchor),
            separator.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            likeButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 20),
            likeButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            likesCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8),
            likesCountLabel.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            shareButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -20),
            shareButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            downloadButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -20),
            downloadButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
        ])
    }
    
    private func configureData() {
        guard let post = post else { return }
        timeLabel.text = post.timestamp
        captionLabel.text = post.caption.components(separatedBy: " #").first
        
        let tagsText = post.tags.map { $0.hasPrefix("#") ? $0 : "#\($0)" }.joined(separator: " ")
        tagsLabel.text = tagsText
        
        let isLiked = UserDefaults.standard.bool(forKey: "post_liked_\(post.id)")
        likeButton.tintColor = isLiked ? .systemRed : WLDAppConfig.Colors.textPrimary
        likeButton.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
        
        let totalLikes = isLiked ? post.likes + 1 : post.likes
        likesCountLabel.text = "\(totalLikes)"
        
        if let videoName = post.videoName, !videoName.isEmpty {
            videoPlayerView?.isHidden = false
            imageView.isHidden = true
            videoPlayerView?.configure(with: videoName, coverURL: post.postImageURL)
        } else {
            videoPlayerView?.isHidden = true
            imageView.isHidden = false
            WLDBitmapFetcher.shared.loadImage(from: post.postImageURL) { [weak self] img in self?.imageView.image = img }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayerView?.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPlayerView?.play()
    }
    
    @objc private func didTapLike() {
        guard let post = post else { return }
        let key = "post_liked_\(post.id)"
        let isLiked = UserDefaults.standard.bool(forKey: key)
        let newLikedState = !isLiked
        
        UserDefaults.standard.set(newLikedState, forKey: key)
        
        // Update UI
        likeButton.tintColor = newLikedState ? .systemRed : WLDAppConfig.Colors.textPrimary
        likeButton.setImage(UIImage(systemName: newLikedState ? "heart.fill" : "heart"), for: .normal)
        
        // Animate
        UIView.animate(withDuration: 0.1, animations: {
            self.likeButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.likeButton.transform = .identity
            }
        }
        
        let totalLikes = newLikedState ? post.likes + 1 : post.likes
        likesCountLabel.text = "\(totalLikes)"
        
        // Notify Feed to refresh
        NotificationCenter.default.post(name: NSNotification.Name("WLDNewPostAdded"), object: nil) // We reuse this to just reloadData
    }
    
    @objc private func didTapShare() {
        guard let post = post else { return }
        var itemsToShare: [Any] = []
        let shareText = "\(post.caption)\n\n- Shared from Keno 📸"
        itemsToShare.append(shareText)
        
        WLDBitmapFetcher.shared.loadImage(from: post.postImageURL) { [weak self] image in
            if let img = image { itemsToShare.append(img) }
            let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            self?.present(activityVC, animated: true)
        }
    }
    
    @objc private func didTapDownload() {
        guard let post = post else { return }
        let downloadCost = 10
        
        // Check balance
        guard WLDCoinManager.shared.balance >= downloadCost else {
            let alert = UIAlertController(
                title: "Insufficient Coins",
                message: "You need \(downloadCost) coins to download this content. Go to the Coin Store to recharge!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Go to Coin Store", style: .default) { [weak self] _ in
                let vc = WLDCoinStoreViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        // Spend coins
        _ = WLDCoinManager.shared.spendCoins(downloadCost)
        
        // Save image or video
        if let videoName = post.videoName, !videoName.isEmpty,
           let url = Bundle.main.url(forResource: videoName.components(separatedBy: ".").first,
                                     withExtension: videoName.components(separatedBy: ".").last) {
            // Save video
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(download_completed(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            // Save image
            WLDBitmapFetcher.shared.loadImage(from: post.postImageURL) { [weak self] img in
                guard let img = img else { return }
                UIImageWriteToSavedPhotosAlbum(img, self, #selector(self?.download_completed(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    @objc private func download_completed(_ obj: Any, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let success = error == nil
        let alert = UIAlertController(
            title: success ? "Saved! (-10 🪙)" : "Save Failed",
            message: success ? "Content saved to your Photos album." : error?.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
