import UIKit

class WLDArticleDetailViewController: UIViewController {
    
    var post: WLDArticle?
    
    // UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let videoPlayerView = WLDVideoPlayerView()
    private let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        return iv
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = WLDAppConfig.Fonts.title(size: 18)
        label.textColor = WLDAppConfig.Colors.textPrimary
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = WLDAppConfig.Fonts.body(size: 16)
        label.textColor = WLDAppConfig.Colors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = WLDAppConfig.Fonts.caption(size: 14)
        label.textColor = WLDAppConfig.Colors.textSecondary
        return label
    }()
    
    // Placeholder Comments Section
    private let commentsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Comments"
        label.font = WLDAppConfig.Fonts.title(size: 16)
        label.textColor = WLDAppConfig.Colors.textPrimary
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WLDAppConfig.Colors.background
        setupUI()
        setupNavBar()
        configureData()
    }
    
    private func setupNavBar() {
        let shareBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        let moreBtn = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(didTapMore))
        navigationItem.rightBarButtonItems = [moreBtn, shareBtn]
        navigationController?.navigationBar.tintColor = WLDAppConfig.Colors.reptileGreen
    }
    
    @objc private func didTapShare() {
        guard let post = post else { return }
        
        var itemsToShare: [Any] = []
        let shareText = "\(post.caption)\n\n- Shared from Keno 🦎"
        itemsToShare.append(shareText)
        
        // Load and share the image
        WLDBitmapFetcher.shared.loadImage(from: post.postImageURL) { [weak self] image in
            guard let self = self else { return }
            
            if let image = image {
                itemsToShare.append(image)
            }
            
            let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            
            if let popover = activityVC.popoverPresentationController {
                popover.barButtonItem = self.navigationItem.rightBarButtonItems?.last
            }
            
            activityVC.excludedActivityTypes = [
                .addToReadingList,
                .assignToContact,
                .openInIBooks
            ]
            
            self.present(activityVC, animated: true)
        }
    }
    
    @objc private func didTapMore() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { _ in
            self.showReportConfirmation()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showReportConfirmation() {
        let alert = UIAlertController(title: "Report Submitted", message: "Thank you for reporting this post. Our team will review it shortly.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pin(to: view)
        contentView.pin(to: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        contentView.addSubview(mainImageView)
        contentView.addSubview(videoPlayerView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(captionLabel)
        contentView.addSubview(commentsHeaderLabel)
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0),
            
            videoPlayerView.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            videoPlayerView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
            videoPlayerView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
            videoPlayerView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            captionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            timeLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            commentsHeaderLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 32),
            commentsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            commentsHeaderLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50) // Padding at bottom
        ])
    }
    
    private func configureData() {
        guard let post = post else { return }
        nameLabel.text = post.username
        captionLabel.text = post.caption
        timeLabel.text = post.timestamp
        
        if let videoName = post.videoName {
            mainImageView.isHidden = true
            videoPlayerView.isHidden = false
            videoPlayerView.configure(with: videoName, coverURL: post.postImageURL)
        } else {
            mainImageView.isHidden = false
            videoPlayerView.isHidden = true
            WLDBitmapFetcher.shared.loadImage(from: post.postImageURL) { [weak self] img in
                self?.mainImageView.image = img
            }
        }
        
        WLDBitmapFetcher.shared.loadImage(from: post.userAvatarURL) { [weak self] img in
            self?.avatarImageView.image = img
        }
    }
    
    deinit {
        videoPlayerView.cleanup()
    }
}
