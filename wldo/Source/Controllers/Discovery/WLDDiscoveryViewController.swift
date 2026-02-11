import UIKit

class WLDDiscoveryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView!

    
    // Data Source Arrays
    private var spotlightPosts: [WLDArticle] = []
    private var vibes: [String] = []
    private var editorialPosts: [WLDArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WLDAppConfig.Colors.background
        navigationItem.title = "Explore"
        setupCollectionView()
        loadData()
    }
    
    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        
        // Register Cells
        collectionView.register(WLDDiscoveryPostCell.self, forCellWithReuseIdentifier: "PostCell")
        collectionView.register(WLDDiscoveryCapsuleCell.self, forCellWithReuseIdentifier: "CapsuleCell")
        collectionView.register(WLDSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            let sectionKind = WLDDiscoverySection.allCases[sectionIndex]
            
            switch sectionKind {
            case .spotlight:
                // Portrait Cards (3:4)
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
                
                // Group width = 0.7 * ScreenWidth, Height = width * 1.33 (3:4 aspect)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalWidth(0.93))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 24, trailing: 0)
                
                let header = self.createSectionHeader()
                section.boundarySupplementaryItems = [header]
                return section
                
            case .vibes:
                // Vibes (Horizontal Pills)
                let estimatedWidth: CGFloat = 100
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth), heightDimension: .absolute(40))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16)
                section.interGroupSpacing = 10
                
                let header = self.createSectionHeader()
                section.boundarySupplementaryItems = [header]
                return section
                
            case .editorial:
                // The Editorial (Asymmetric Bento Grid)
                // Row 1: [2/3] [1/3]
                // Row 2: [1/3] [2/3]
                
                let rowHeight = NSCollectionLayoutDimension.fractionalWidth(0.5)
                
                // --- Items ---
                let heavyItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.66), heightDimension: .fractionalHeight(1.0)))
                heavyItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let lightItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.34), heightDimension: .fractionalHeight(1.0)))
                lightItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                // --- Groups ---
                // Row A: Heavy Left, Light Right
                let groupA = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: rowHeight), subitems: [heavyItem, lightItem])
                
                // Row B: Light Left, Heavy Right
                let groupB = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: rowHeight), subitems: [lightItem, heavyItem])
                
                // Main Group: Stack A and B
                let mainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)) // 2 rows of 0.5 = 1.0
                let mainGroup = NSCollectionLayoutGroup.vertical(layoutSize: mainGroupSize, subitems: [groupA, groupB])
                
                let section = NSCollectionLayoutSection(group: mainGroup)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 14, bottom: 20, trailing: 14)
                
                let header = self.createSectionHeader()
                section.boundarySupplementaryItems = [header]
                return section
            }
        }
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    // Classic DataSource Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return WLDDiscoverySection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionKind = WLDDiscoverySection.allCases[section]
        switch sectionKind {
        case .spotlight: return spotlightPosts.count
        case .vibes: return vibes.count
        case .editorial: return editorialPosts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionKind = WLDDiscoverySection.allCases[indexPath.section]
        switch sectionKind {
        case .spotlight:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! WLDDiscoveryPostCell
            cell.configure(with: spotlightPosts[indexPath.item])
            return cell
        case .vibes:
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CapsuleCell", for: indexPath) as! WLDDiscoveryCapsuleCell
             cell.configure(with: vibes[indexPath.item])
             return cell
        case .editorial:
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! WLDDiscoveryPostCell
             cell.configure(with: editorialPosts[indexPath.item])
             return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionKind = WLDDiscoverySection.allCases[indexPath.section]
        
        var selectedPost: WLDArticle?
        
        switch sectionKind {
        case .spotlight:
            selectedPost = spotlightPosts[indexPath.item]
        case .vibes:
            let tag = vibes[indexPath.item]
            // Navigate to dedicated Tag Feed
            let tagFeedVC = WLDTagFeedViewController()
            tagFeedVC.tagName = tag
            tagFeedVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(tagFeedVC, animated: true)
            return
        case .editorial:
            selectedPost = editorialPosts[indexPath.item]
        }
        
        if let post = selectedPost {
            let detailVC = WLDArticleDetailViewController()
            detailVC.post = post
            detailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! WLDSectionHeaderView
        let section = WLDDiscoverySection.allCases[indexPath.section]
        header.titleLabel.text = section.rawValue
        return header
    }

    private func configureDataSource() {
        collectionView.dataSource = self
    }
    
    private func loadData() {
        let allPosts = WLDInitialData.getPosts()
        
        // Sample distributions
        spotlightPosts = Array(allPosts.prefix(5))
        vibes = ["#DANCE", "#STREET", "#KRUMP", "#POPPING", "#LOCKING", "#BREAKING", "#JAZZ", "#BALLET", "#CONTEMPORARY", "#HIPHOP", "#LATIN", "#TAP", "#KPOP", "#CHOREO", "#FREESTYLE"]
        editorialPosts = allPosts
        
        collectionView.reloadData()
    }
}

// MARK: - Subviews

class WLDSectionHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.pin(to: self, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        titleLabel.font = WLDAppConfig.Fonts.header(size: 20)
        titleLabel.textColor = WLDAppConfig.Colors.textPrimary
    }
    required init?(coder: NSCoder) { fatalError() }
}

class WLDDiscoveryPostCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        imageView.pin(to: contentView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .gray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = WLDAppConfig.Fonts.caption(size: 12)
        label.textColor = .white
        
        // Gradient for text readability
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000) // Oversize
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
        imageView.layer.addSublayer(gradient)
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        ])
    }
    
    func configure(with post: WLDArticle) {
        WLDBitmapFetcher.shared.loadImage(from: post.postImageURL) { [weak self] img in
            self?.imageView.image = img
        }
        label.text = post.username
    }
    required init?(coder: NSCoder) { fatalError() }
}

class WLDDiscoveryCapsuleCell: UICollectionViewCell {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = WLDAppConfig.Colors.cardBackground
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = WLDAppConfig.Colors.reptileGreen.withAlphaComponent(0.3).cgColor
        
        contentView.addSubview(label)
        label.pin(to: contentView, insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        
        label.font = WLDAppConfig.Fonts.body(size: 14)
        label.textColor = WLDAppConfig.Colors.textPrimary
        label.textAlignment = .center
    }
    
    func configure(with text: String) {
        label.text = text
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.contentView.backgroundColor = self.isSelected ? WLDAppConfig.Colors.reptileGreen : WLDAppConfig.Colors.cardBackground
                self.label.textColor = self.isSelected ? .black : WLDAppConfig.Colors.textPrimary
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
