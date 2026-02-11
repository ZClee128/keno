import UIKit

class WLDTagFeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tagName: String? {
        didSet {
            title = tagName
        }
    }
    
    private var collectionView: UICollectionView!
    private var posts: [WLDArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WLDAppConfig.Colors.background
        
        setupCollectionView()
        loadData()
    }
    
    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        
        collectionView.register(WLDMosaicCell.self, forCellWithReuseIdentifier: "PostCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // Simple 2-column grid
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.66)) // 3:4 aspect ratio items effectively
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func loadData() {
        // In a real app, filter by tagName. Here, just shuffle or duplicate.
        let allPosts = WLDInitialData.getPosts()
        posts = allPosts.shuffled() // Shuffle to look different
        collectionView.reloadData()
    }
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! WLDMosaicCell
        cell.configure(with: posts[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = WLDArticleDetailViewController()
        detailVC.post = posts[indexPath.item]
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
