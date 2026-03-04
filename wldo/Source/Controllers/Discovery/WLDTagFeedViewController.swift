import UIKit

class WLDTagFeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, StaggeredGridLayoutDelegate {
    
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
        let layout = StaggeredGridLayout()
        layout.delegate = self
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 6, bottom: 20, right: 6)
        
        view.addSubview(collectionView)
        
        collectionView.register(WLDStaggeredFeedCell.self, forCellWithReuseIdentifier: "WLDStaggeredFeedCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let post = posts[indexPath.item]
        let isPortrait = (post.caption.count % 2 == 0)
        let baseHeight = width * (isPortrait ? 1.4 : 1.1)
        return baseHeight + 60
    }
    
    private func loadData() {
        let allPosts = WLDInitialData.getPosts()
        posts = allPosts.shuffled()
        collectionView.reloadData()
    }
    
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WLDStaggeredFeedCell", for: indexPath) as! WLDStaggeredFeedCell
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
