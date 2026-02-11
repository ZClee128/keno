import UIKit

class WLDCoinStoreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView!
    private let packages = [
        (100, "$0.99"),
        (500, "$4.99"),
        (1000, "$9.99"),
        (5000, "$49.99")
    ]
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = WLDAppConfig.Fonts.header(size: 32)
        label.textColor = WLDAppConfig.Colors.reptileGreen
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Coin Store"
        view.backgroundColor = WLDAppConfig.Colors.background
        setupUI()
        updateBalance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBalance), name: NSNotification.Name("WLDCoinBalanceChanged"), object: nil)
    }
    
    @objc private func updateBalance() {
        balanceLabel.text = "🪙 \(WLDCoinManager.shared.balance)"
    }
    
    private func setupUI() {
        view.addSubview(balanceLabel)
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WLDCoinCell.self, forCellWithReuseIdentifier: "CoinCell")
        
        view.addSubview(collectionView)
        collectionView.pin(to: view, insets: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoinCell", for: indexPath) as! WLDCoinCell
        let pkg = packages[indexPath.item]
        cell.configure(amount: pkg.0, price: pkg.1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pkg = packages[indexPath.item]
        // IAP Coming Soon
        let alert = UIAlertController(title: "Coming Soon", message: "In-app purchases will be available in a future update!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

class WLDCoinCell: UICollectionViewCell {
    private let container = UIView()
    private let titleLabel = UILabel()
    private let priceButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(container)
        container.pin(to: contentView)
        container.backgroundColor = WLDAppConfig.Colors.cardBackground
        container.layer.cornerRadius = 16
        
        container.addSubview(titleLabel)
        container.addSubview(priceButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = WLDAppConfig.Fonts.header(size: 24)
        titleLabel.textColor = WLDAppConfig.Colors.textPrimary
        
        priceButton.translatesAutoresizingMaskIntoConstraints = false
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.backgroundColor = WLDAppConfig.Colors.reptileGreen
        priceButton.layer.cornerRadius = 20
        priceButton.isUserInteractionEnabled = false // Tap cell instead
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -20),
            
            priceButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            priceButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            priceButton.widthAnchor.constraint(equalToConstant: 100),
            priceButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(amount: Int, price: String) {
        titleLabel.text = "\(amount) 🪙"
        priceButton.setTitle(price, for: .normal)
    }
}
