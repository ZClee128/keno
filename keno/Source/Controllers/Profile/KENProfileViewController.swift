import UIKit

class KENProfileHeaderReusableView: UICollectionReusableView {
    static let identifier = "KENProfileHeaderReusableView"
    private let headerView = KENProfileHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.pin(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(user: KENUser?, postCount: Int) {
        if let user = user {
            headerView.configure(name: user.username, bio: user.bio, avatarURL: user.avatarURL, postCount: postCount)
        } else if let currentUser = KENAuthManager.shared.currentUser {
            headerView.configure(name: currentUser.username, bio: currentUser.bio, avatarURL: currentUser.avatarURL, postCount: postCount)
        } else {
            // Default "Guest"
             headerView.configure(name: "Guest", bio: "Please log in to share your collection! 🦎", avatarURL: "avatar_guest", postCount: 0)  // Local guest avatar
        }
    }
}

// KENUser moved to Source/Models/KENUser.swift


class KENProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var user: KENUser? // If nil, it's "Me"
    private var collectionView: UICollectionView!
    private var posts: [KENPost] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = user?.username ?? "Profile"
        view.backgroundColor = KENConstants.Colors.background
        setupCollectionView()
        setupNavBar()
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name("KENNewPostAdded"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh data when returning to view (e.g., after login/logout)
        loadData()
    }
    
    @objc private func loadData() {
        let allPosts = KENPostManager.shared.getAllPosts()
        if let targetId = user?.id {
            posts = allPosts.filter { $0.userId == targetId }
        } else {
            // Me: Show only my posts
            let myId = KENAuthManager.shared.currentUser?.id ?? "Guest"
            posts = allPosts.filter { $0.userId == myId }
        }
        collectionView?.reloadData()
    }

    private func setupNavBar() {
        if user == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(didTapSettings))
        }
    }
    
    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(KENPhotoGridCell.self, forCellWithReuseIdentifier: "KENPhotoGridCell")
        collectionView.register(KENProfileHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: KENProfileHeaderReusableView.identifier)
        
        view.addSubview(collectionView)
        collectionView.pin(to: view)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            // Grid Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/3.0), heightDimension: .fractionalWidth(1.0/3.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0/3.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            
            // Header
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
    
    // MARK: DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KENPhotoGridCell", for: indexPath) as! KENPhotoGridCell
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KENProfileHeaderReusableView.identifier, for: indexPath) as! KENProfileHeaderReusableView
        header.configure(user: self.user, postCount: self.posts.count)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let detailVC = KENPostDetailViewController()
        detailVC.post = post
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc private func didTapSettings() {
        let settingsVC = KENSettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}
