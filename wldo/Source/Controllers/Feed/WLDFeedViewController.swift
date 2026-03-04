import UIKit

class WLDFeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, StaggeredGridLayoutDelegate {

    private var collectionView: UICollectionView!
    private var posts: [WLDArticle] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "For You"
        view.backgroundColor = WLDAppConfig.Colors.background
        
        setupNavBar()
        setupCollectionView()
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFeed), name: NSNotification.Name("WLDNewPostAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFeed), name: NSNotification.Name("WLDProfileBlocked"), object: nil)
    }
    
    @objc private func refreshFeed() {
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    
    private func loadData() {
        posts = WLDFeedController.shared.getAllPosts() // Stable order: videos first
        collectionView.reloadData()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        // Add a sleek modern logo or title view instead of large titles
        let titleLabel = UILabel()
        titleLabel.text = "KENO"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        titleLabel.textColor = WLDAppConfig.Colors.textPrimary
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        navigationItem.rightBarButtonItem = nil
        
        navigationController?.navigationBar.tintColor = WLDAppConfig.Colors.textPrimary
    }
    
    private func setupCollectionView() {
        let layout = StaggeredGridLayout()
        layout.delegate = self
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 6, bottom: 20, right: 6)
        collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(collectionView)
        
        // Register New Staggered Cell
        collectionView.register(WLDStaggeredFeedCell.self, forCellWithReuseIdentifier: "WLDStaggeredFeedCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Layout Delegate
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        // Randomize heights slightly or based on aspect ratio to simulate staggered waterfall
        let post = posts[indexPath.item]
        let isPortrait = (post.caption.count % 2 == 0) // Fake aspect ratio determination
        let baseHeight = width * (isPortrait ? 1.4 : 1.1)
        
        // Add space for the text area at the bottom
        let textPadding: CGFloat = 60
        return baseHeight + textPadding
    }
    
    // MARK: - Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WLDStaggeredFeedCell", for: indexPath) as! WLDStaggeredFeedCell
        cell.configure(with: posts[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.item]
        let detailVC = WLDArticleDetailViewController()
        detailVC.post = selectedPost
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // Actions completely removed since no chat
}

// MARK: - Minimalist Staggered Cell
class WLDStaggeredFeedCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let likesLabel = UILabel()
    private let heartIcon = UIImageView()
    private let playIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        
        // Image Container
        let imageContainer = UIView()
        imageContainer.layer.cornerRadius = 12
        imageContainer.clipsToBounds = true
        imageContainer.backgroundColor = WLDAppConfig.Colors.sand
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageContainer)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(imageView)
        
        // Text Info Container
        let infoContainer = UIView()
        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoContainer)
        
        titleLabel.font = WLDAppConfig.Fonts.title(size: 14) // Slightly smaller, bolder title
        titleLabel.numberOfLines = 2
        titleLabel.textColor = WLDAppConfig.Colors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoContainer.addSubview(titleLabel)
        
        likesLabel.font = WLDAppConfig.Fonts.caption(size: 11)
        likesLabel.textColor = WLDAppConfig.Colors.textSecondary
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        heartIcon.image = UIImage(systemName: "heart")
        heartIcon.tintColor = WLDAppConfig.Colors.textSecondary
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        
        playIcon.image = UIImage(systemName: "play.circle.fill")
        playIcon.tintColor = UIColor(white: 1.0, alpha: 0.8)
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        playIcon.isHidden = true
        imageContainer.addSubview(playIcon)
        
        let likesStack = UIStackView(arrangedSubviews: [heartIcon, likesLabel])
        likesStack.axis = .horizontal
        likesStack.spacing = 3
        likesStack.alignment = .center
        likesStack.translatesAutoresizingMaskIntoConstraints = false
        infoContainer.addSubview(likesStack)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: infoContainer.topAnchor, constant: -8),
            
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
            infoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            infoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            infoContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoContainer.heightAnchor.constraint(equalToConstant: 52), // Text area height
            
            titleLabel.topAnchor.constraint(equalTo: infoContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            
            likesStack.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: -4),
            likesStack.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            
            heartIcon.widthAnchor.constraint(equalToConstant: 12),
            heartIcon.heightAnchor.constraint(equalToConstant: 12),
            
            playIcon.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            playIcon.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            playIcon.widthAnchor.constraint(equalToConstant: 36),
            playIcon.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func configure(with post: WLDArticle) {
        titleLabel.text = post.caption.components(separatedBy: " #").first // Get text before tags
        
        let isLiked = UserDefaults.standard.bool(forKey: "post_liked_\(post.id)")
        let totalLikes = isLiked ? post.likes + 1 : post.likes
        likesLabel.text = "\(totalLikes)"
        
        heartIcon.image = UIImage(systemName: isLiked ? "heart.fill" : "heart")
        heartIcon.tintColor = isLiked ? .systemRed : WLDAppConfig.Colors.textSecondary
        
        if let videoName = post.videoName, !videoName.isEmpty {
            playIcon.isHidden = false
        } else {
            playIcon.isHidden = true
        }
        
        WLDBitmapFetcher.shared.loadImage(from: post.postImageURL) { [weak self] img in self?.imageView.image = img }
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
import UIKit

protocol StaggeredGridLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
}

class StaggeredGridLayout: UICollectionViewLayout {
    weak var delegate: StaggeredGridLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView, cache.isEmpty else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath, with: columnWidth) ?? 200
            let height = cellPadding * 2 + photoHeight
            
            // Find shortest column
            column = 0
            var shortestHeight = yOffset[0]
            for (idx, y) in yOffset.enumerated() {
                if y < shortestHeight {
                    shortestHeight = y
                    column = idx
                }
            }
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
        contentHeight = 0
    }
}
