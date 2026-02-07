import UIKit

class KENFeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, KENStoriesViewDelegate, KENPostCellDelegate {

    private var collectionView: UICollectionView!

    
    private var posts: [KENPost] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed"
        view.backgroundColor = KENConstants.Colors.background
        
        setupCollectionView()
        configureDataSource()
        loadData()
        setupNavBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFeed), name: NSNotification.Name("KENNewPostAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFeed), name: NSNotification.Name("KENUserBlocked"), object: nil)
    }
    
    @objc private func refreshFeed() {
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    
    private func loadData() {
        posts = KENPostManager.shared.getAllPosts()
        collectionView.reloadData()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
//        let cameraBtn = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(didTapCamera))
        let chatBtn = UIBarButtonItem(image: UIImage(systemName: "message"), style: .plain, target: self, action: #selector(didTapChat))
        
//        navigationItem.leftBarButtonItem = cameraBtn
        navigationItem.rightBarButtonItem = chatBtn
        
        navigationController?.navigationBar.tintColor = KENConstants.Colors.reptileGreen
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        // Register Cells
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "StoryContainerCell") // Container for StoriesView
        collectionView.register(KENSpotlightCell.self, forCellWithReuseIdentifier: "SpotlightCell") // Reusing PostCell for Spotlight
        collectionView.register(KENMosaicCell.self, forCellWithReuseIdentifier: "MosaicCell") // New Simple Cell
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            let sectionKind = KENFeedSection.allCases[sectionIndex]
            
            switch sectionKind {
            case .stories:
                // Full width, fixed height container
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                return section
                
            case .spotlight:
                // Large Paging Card (Spotlight)
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // 90% width to show next item peeking
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(1.1))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 30, trailing: 0)
                return section
                
            case .mosaic:
                // Complex Mosaic
                let fullItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
                fullItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

                let largeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.66), heightDimension: .fractionalHeight(1.0)))
                largeItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let stackedItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
                stackedItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let stackedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.34), heightDimension: .fractionalHeight(1.0)), subitem: stackedItem, count: 2)
                
                let groupA = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.7)), subitems: [largeItem, stackedGroup])
                
                let section = NSCollectionLayoutSection(group: groupA)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10)
                return section
            }
        }
    }
    
    // Classic DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return KENFeedSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionKind = KENFeedSection.allCases[section]
        switch sectionKind {
        case .stories:
            return 1
        case .spotlight:
            return min(posts.count, 3)
        case .mosaic:
            return max(0, posts.count - 3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionKind = KENFeedSection.allCases[indexPath.section]
        switch sectionKind {
        case .stories:
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryContainerCell", for: indexPath)
             if cell.contentView.subviews.isEmpty {
                 let storiesView = KENStoriesView(frame: cell.bounds)
                 storiesView.delegate = self
                 cell.contentView.addSubview(storiesView)
                 storiesView.pin(to: cell.contentView)
             }
             return cell
             
        case .spotlight:
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotlightCell", for: indexPath) as! KENSpotlightCell
             let post = posts[indexPath.item]
             cell.configure(with: post)
             cell.delegate = self
             return cell
             
        case .mosaic:
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MosaicCell", for: indexPath) as! KENMosaicCell
             let post = posts[indexPath.item + 3]
             cell.configure(with: post)
             return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionKind = KENFeedSection.allCases[indexPath.section]
        
        var selectedPost: KENPost?
        
        switch sectionKind {
        case .stories:
            return // Handled by inner view delegate
        case .spotlight:
            selectedPost = posts[indexPath.item]
        case .mosaic:
            if indexPath.item + 3 < posts.count {
                selectedPost = posts[indexPath.item + 3]
            }
        }
        
        if let post = selectedPost {
            let detailVC = KENPostDetailViewController()
            detailVC.post = post
            detailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    private func configureDataSource() {
        collectionView.dataSource = self
    }
    
    // Actions...
    @objc private func didTapCamera() {
        KENAuthManager.shared.ensureLoggedIn(on: self) { [weak self] in
            let cameraVC = KENCameraViewController()
            cameraVC.modalPresentationStyle = .fullScreen
            self?.present(cameraVC, animated: true)
        }
    }
    
    @objc private func didTapChat() {
        KENAuthManager.shared.ensureLoggedIn(on: self) { [weak self] in
            let chatListVC = KENChatListViewController()
            self?.navigationController?.pushViewController(chatListVC, animated: true)
        }
    }
    
    @objc private func didTapNotifications() {
        let alert = UIAlertController(title: "Notifications", message: "No new notifications", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // Delegates
    func didSelectStory(name: String, isMyStory: Bool) {
        if isMyStory {
             didTapCamera() // Open camera for My Story
        } else {
             let vc = KENStoryDetailViewController()
             vc.storyName = name
             vc.modalPresentationStyle = .fullScreen
             present(vc, animated: true)
        }
    }
    
    func didTapUser(username: String, avatarURL: String) {
        let profileVC = KENProfileViewController()
        profileVC.user = KENUser(id: "user_\(username)", username: username, email: "\(username.lowercased())@example.com", avatarURL: avatarURL, bio: "Reptile lover 🦎")
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func didTapShare(post: KENPost, sourceView: UIView) {
        // Build share content
        var itemsToShare: [Any] = []
        
        // Add caption text
        let shareText = "\(post.caption)\n\n- Shared from Keno 🦎"
        itemsToShare.append(shareText)
        
        // Try to load and share the image
        KENImageLoader.shared.loadImage(from: post.postImageURL) { [weak self] image in
            guard let self = self else { return }
            
            if let image = image {
                itemsToShare.append(image)
            }
            
            // Create and present activity view controller
            let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            
            // For iPad: set popover presentation
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = sourceView
                popover.sourceRect = sourceView.bounds
            }
            
            // Exclude some activity types if needed
            activityVC.excludedActivityTypes = [
                .addToReadingList,
                .assignToContact,
                .openInIBooks
            ]
            
            self.present(activityVC, animated: true)
        }
    }
}

// Cells
class KENMosaicCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.pin(to: contentView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
    }
    
    func configure(with post: KENPost) {
        KENImageLoader.shared.loadImage(from: post.postImageURL) { [weak self] img in
            self?.imageView.image = img
        }
    }
    required init?(coder: NSCoder) { fatalError() }
}

class KENSpotlightCell: UICollectionViewCell {
    weak var delegate: KENPostCellDelegate? // Reusing protocol
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let playButtonImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "play.fill")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        iv.isHidden = true
        return iv
    }()
    
    private var post: KENPost?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = KENConstants.Colors.cardBackground
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(playButtonImageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        playButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8), // 80% image
            
            avatarImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            playButtonImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            playButtonImageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            playButtonImageView.widthAnchor.constraint(equalToConstant: 50),
            playButtonImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(with post: KENPost) {
        self.post = post
        titleLabel.text = post.caption
        playButtonImageView.isHidden = post.videoName == nil
        KENImageLoader.shared.loadImage(from: post.postImageURL) { [weak self] img in self?.imageView.image = img }
        KENImageLoader.shared.loadImage(from: post.userAvatarURL) { [weak self] img in self?.avatarImageView.image = img }
    }
    
    @objc private func didTapAvatar() {
        guard let post = post else { return }
        delegate?.didTapUser(username: post.username, avatarURL: post.userAvatarURL)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
